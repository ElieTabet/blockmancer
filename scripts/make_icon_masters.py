"""Builds the two square icon masters from the logo.

Pure stdlib: the repo has no image tooling, and this runs once per logo.

Usage: python3 scripts/make_icon_masters.py [--ground RRGGBB]
"""
import struct, zlib, sys

SRC = 'packages/dsm/assets/source/logo.png'

# DSColor.primary — the same colour the launch screen and the in-app splash
# use, so the icon and the first frame are one continuous surface. Pass the
# brand's own with --ground when it changes.
_hex = sys.argv[sys.argv.index('--ground') + 1] if '--ground' in sys.argv else '14172B'
GROUND = tuple(int(_hex.lstrip('#')[i:i + 2], 16) for i in (0, 2, 4))


def decode(path):
    raw = open(path, 'rb').read()
    w, h = struct.unpack('>II', raw[16:24])
    depth, colour = raw[24], raw[25]
    assert depth == 8 and colour == 6, f'expected 8-bit RGBA, got depth={depth} type={colour}'
    idat, pos = b'', 8
    while pos < len(raw):
        ln = struct.unpack('>I', raw[pos:pos + 4])[0]
        if raw[pos + 4:pos + 8] == b'IDAT':
            idat += raw[pos + 8:pos + 8 + ln]
        pos += 12 + ln
    data = zlib.decompress(idat)
    stride, ch = w * 4, 4
    prev, rows, p = bytearray(stride), [], 0
    for _ in range(h):
        f = data[p]; p += 1
        line = bytearray(data[p:p + stride]); p += stride
        if f:
            for i in range(stride):
                a = line[i - ch] if i >= ch else 0
                b = prev[i]
                c = prev[i - ch] if i >= ch else 0
                if f == 1: line[i] = (line[i] + a) & 255
                elif f == 2: line[i] = (line[i] + b) & 255
                elif f == 3: line[i] = (line[i] + (a + b) // 2) & 255
                else:
                    pa, pb, pc = abs(b - c), abs(a - c), abs(a + b - 2 * c)
                    pr = a if (pa <= pb and pa <= pc) else (b if pb <= pc else c)
                    line[i] = (line[i] + pr) & 255
        prev = line
        rows.append(bytes(line))
    return w, h, rows


def encode(path, w, h, rows, colour_type):
    ch = 4 if colour_type == 6 else 3
    scan = b''.join(b'\x00' + bytes(r) for r in rows)
    def chunk(tag, body):
        return struct.pack('>I', len(body)) + tag + body + struct.pack('>I', zlib.crc32(tag + body) & 0xffffffff)
    png = (b'\x89PNG\r\n\x1a\n'
           + chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, colour_type, 0, 0, 0))
           + chunk(b'IDAT', zlib.compress(scan, 9))
           + chunk(b'IEND', b''))
    open(path, 'wb').write(png)
    return len(png)


def bounds(w, h, rows):
    """Tight box around anything that is not fully transparent."""
    minx, maxx, miny, maxy = w, -1, h, -1
    for y in range(h):
        r = rows[y]
        for x in range(w):
            if r[x * 4 + 3]:
                if x < minx: minx = x
                if x > maxx: maxx = x
                if y < miny: miny = y
                if y > maxy: maxy = y
    return minx, miny, maxx, maxy


def box_scale(rows, sx, sy, sw, sh, dw, dh):
    """Area-average downscale of a sub-rectangle. Premultiplies so that
    transparent pixels do not bleed their colour into the edges."""
    out = []
    for dy in range(dh):
        y0 = sy + dy * sh // dh
        y1 = max(y0 + 1, sy + (dy + 1) * sh // dh)
        line = bytearray(dw * 4)
        for dx in range(dw):
            x0 = sx + dx * sw // dw
            x1 = max(x0 + 1, sx + (dx + 1) * sw // dw)
            ar = ag = ab = aa = n = 0
            for yy in range(y0, y1):
                r = rows[yy]
                for xx in range(x0, x1):
                    o = xx * 4
                    a = r[o + 3]
                    ar += r[o] * a; ag += r[o + 1] * a; ab += r[o + 2] * a; aa += a
                    n += 1
            i = dx * 4
            if aa:
                line[i] = min(255, ar // aa)
                line[i + 1] = min(255, ag // aa)
                line[i + 2] = min(255, ab // aa)
            line[i + 3] = aa // n
        out.append(bytes(line))
    return out


def compose(size, scaled, sw, sh, ground):
    """Centres the scaled logo on `ground`, or on transparency when ground is None."""
    ch = 3 if ground else 4
    fill = bytes(ground) if ground else b'\x00\x00\x00\x00'
    rows = [bytearray(fill * size) for _ in range(size)]
    ox, oy = (size - sw) // 2, (size - sh) // 2
    for y in range(sh):
        src = scaled[y]
        dst = rows[oy + y]
        for x in range(sw):
            s = x * 4
            a = src[s + 3]
            if not a:
                continue
            d = (ox + x) * ch
            if ground:
                for k in range(3):
                    dst[d + k] = (src[s + k] * a + dst[d + k] * (255 - a)) // 255
            else:
                dst[d] = src[s]; dst[d + 1] = src[s + 1]
                dst[d + 2] = src[s + 2]; dst[d + 3] = a
    return rows, ch


w, h, rows = decode(SRC)
minx, miny, maxx, maxy = bounds(w, h, rows)
bw, bh = maxx - minx + 1, maxy - miny + 1
print(f'source {w}x{h}, ink box {bw}x{bh} at ({minx},{miny}), ground #%02x%02x%02x' % GROUND)

SIZE = 1024
for name, fraction, bg in (
    ('icon.png', 0.78, GROUND),          # iOS + legacy Android: opaque, RGB, no alpha
    # The adaptive foreground is padded by flutter_launcher_icons as well — it
    # writes a 16% inset either side — so this is deliberately close to full
    # bleed. 0.78 x 0.68 lands the logo at about 80% of the visible circle;
    # padding it here too would leave it stranded in the middle.
    ('icon_foreground.png', 0.78, None),
):
    scale = min(SIZE * fraction / bw, SIZE * fraction / bh)
    dw, dh = max(1, round(bw * scale)), max(1, round(bh * scale))
    scaled = box_scale(rows, minx, miny, bw, bh, dw, dh)
    out, ch = compose(SIZE, scaled, dw, dh, bg)
    n = encode(f'packages/dsm/assets/source/{name}', SIZE, SIZE, out, 6 if ch == 4 else 2)
    print(f'  {name}: {SIZE}x{SIZE}, logo {dw}x{dh} ({int(fraction*100)}%), '
          f'{"RGB (no alpha)" if ch == 3 else "RGBA"}, {n // 1024} KiB')
