import 'package:blockmancer_engine/src/random/mulberry32.dart';

/// Independent random sequences derived from one run seed, so what a player
/// does in one cannot shift another: Quarry's stones never move the offers.
enum RngStream {
  offers(0x0FFE125),
  pieces(0x91ECE5),
  stones(0x570E5);

  const RngStream(this.salt);

  /// Fixed per stream rather than the enum index, so reordering or adding a
  /// stream never changes an existing seeded run.
  final int salt;
}

/// The seed of [stream]'s [index]-th sequence in the run seeded [runSeed].
///
/// Each round draws pieces and stones from its own sequence, and each joker
/// pick its offers, so one round's play never changes the next round's pieces.
int deriveSeed({
  required int index,
  required int runSeed,
  required RngStream stream,
}) {
  var hash = _fmix32(runSeed & 0xFFFFFFFF);
  hash = _fmix32(hash ^ imul32(stream.salt, 0x9E3779B9));

  return _fmix32(hash ^ imul32(index + 1, 0x85EBCA6B));
}

/// MurmurHash3's finalizer: spreads every input bit over the whole word.
int _fmix32(int value) {
  var hash = value & 0xFFFFFFFF;
  hash = imul32(hash ^ (hash >>> 16), 0x85EBCA6B);
  hash = imul32(hash ^ (hash >>> 13), 0xC2B2AE35);

  return (hash ^ (hash >>> 16)) & 0xFFFFFFFF;
}

Mulberry32 streamFor({
  required int index,
  required int runSeed,
  required RngStream stream,
}) => Mulberry32(deriveSeed(index: index, runSeed: runSeed, stream: stream));
