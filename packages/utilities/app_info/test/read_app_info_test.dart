import 'package:app_info/app_info.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'fake_device_info.dart';

void main() {
  Future<PackageInfo> release() async =>
      fakePackageInfo(buildNumber: '2', version: '1.0.0');

  test(
    'Given an iPhone, When read, Then its model name and iOS version are reported',
    () async {
      final info = await readAppInfo(
        loadDeviceInfo: () async => fakeIosDeviceInfo(
          model: 'iPhone',
          modelName: 'iPhone 15 Pro',
          systemName: 'iOS',
          systemVersion: '18.1',
        ),
        loadPackageInfo: release,
      );

      expect(
        info,
        const AppInfo(
          build: '2',
          device: 'iPhone 15 Pro',
          os: 'iOS 18.1',
          version: '1.0.0',
        ),
      );
    },
  );

  test(
    'Given an iPhone with no model name, When read, Then its model is reported',
    () async {
      final info = await readAppInfo(
        loadDeviceInfo: () async => fakeIosDeviceInfo(
          model: 'iPhone',
          modelName: '',
          systemName: 'iOS',
          systemVersion: '18.1',
        ),
        loadPackageInfo: release,
      );

      expect(info.device, 'iPhone');
    },
  );

  test(
    'Given an Android phone, When read, Then its maker, model, release and SDK are reported',
    () async {
      final info = await readAppInfo(
        loadDeviceInfo: () async => fakeAndroidDeviceInfo(
          manufacturer: 'Google',
          model: 'Pixel 8',
          release: '15',
          sdkInt: 35,
        ),
        loadPackageInfo: release,
      );

      expect(
        info,
        const AppInfo(
          build: '2',
          device: 'Google Pixel 8',
          os: 'Android 15 (SDK 35)',
          version: '1.0.0',
        ),
      );
    },
  );

  test(
    'Given a model that already names its maker, When read, Then the maker is not repeated',
    () async {
      final info = await readAppInfo(
        loadDeviceInfo: () async => fakeAndroidDeviceInfo(
          manufacturer: 'OnePlus',
          model: 'ONEPLUS A6013',
          release: '11',
          sdkInt: 30,
        ),
        loadPackageInfo: release,
      );

      expect(info.device, 'ONEPLUS A6013');
    },
  );

  test(
    'Given the device lookup fails, When read, Then the version is still reported',
    () async {
      final info = await readAppInfo(
        loadDeviceInfo: () async =>
            throw PlatformException(code: 'channel-error'),
        loadPackageInfo: release,
      );

      expect(
        info,
        const AppInfo(
          build: '2',
          device: 'unknown',
          os: 'unknown',
          version: '1.0.0',
        ),
      );
    },
  );

  test(
    'Given the version lookup fails, When read, Then the device is still reported',
    () async {
      final info = await readAppInfo(
        loadDeviceInfo: () async => fakeIosDeviceInfo(
          model: 'iPhone',
          modelName: 'iPhone 15 Pro',
          systemName: 'iOS',
          systemVersion: '18.1',
        ),
        loadPackageInfo: () async =>
            throw MissingPluginException('no implementation found'),
      );

      expect(
        info,
        const AppInfo(
          build: 'unknown',
          device: 'iPhone 15 Pro',
          os: 'iOS 18.1',
          version: 'unknown',
        ),
      );
    },
  );

  test(
    'Given a build with no build number, When read, Then the build reads unknown',
    () async {
      final info = await readAppInfo(
        loadDeviceInfo: () async => fakeAndroidDeviceInfo(
          manufacturer: 'Google',
          model: 'Pixel 8',
          release: '15',
          sdkInt: 35,
        ),
        loadPackageInfo: () async =>
            fakePackageInfo(buildNumber: '', version: '1.0.0'),
      );

      expect(info.build, 'unknown');
    },
  );

  test(
    'Given a platform that is neither iOS nor Android, When read, Then the device reads unknown',
    () async {
      final info = await readAppInfo(
        loadDeviceInfo: () async => BaseDeviceInfo(const {}),
        loadPackageInfo: release,
      );

      expect((info.device, info.os), ('unknown', 'unknown'));
    },
  );
}
