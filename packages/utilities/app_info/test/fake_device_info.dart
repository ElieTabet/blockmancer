import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

AndroidDeviceInfo fakeAndroidDeviceInfo({
  required String manufacturer,
  required String model,
  required String release,
  required int sdkInt,
}) => AndroidDeviceInfo.setMockInitialValues(
  availableRamSize: 0,
  board: '',
  bootloader: '',
  brand: '',
  device: '',
  display: '',
  fingerprint: '',
  freeDiskSize: 0,
  hardware: '',
  host: '',
  id: '',
  isLowRamDevice: false,
  isPhysicalDevice: true,
  manufacturer: manufacturer,
  model: model,
  name: '',
  physicalRamSize: 0,
  product: '',
  supported32BitAbis: const [],
  supported64BitAbis: const [],
  supportedAbis: const [],
  systemFeatures: const [],
  tags: '',
  time: 0,
  totalDiskSize: 0,
  type: '',
  version: AndroidBuildVersion.setMockInitialValues(
    codename: 'REL',
    incremental: '',
    previewSdkInt: 0,
    release: release,
    sdkInt: sdkInt,
  ),
);

IosDeviceInfo fakeIosDeviceInfo({
  required String model,
  required String modelName,
  required String systemName,
  required String systemVersion,
}) => IosDeviceInfo.setMockInitialValues(
  availableRamSize: 0,
  freeDiskSize: 0,
  isPhysicalDevice: true,
  isiOSAppOnMac: false,
  isiOSAppOnVision: false,
  localizedModel: model,
  model: model,
  modelName: modelName,
  name: '',
  physicalRamSize: 0,
  systemName: systemName,
  systemVersion: systemVersion,
  totalDiskSize: 0,
  utsname: IosUtsname.setMockInitialValues(
    machine: '',
    nodename: '',
    release: '',
    sysname: '',
    version: '',
  ),
);

PackageInfo fakePackageInfo({
  required String buildNumber,
  required String version,
}) => PackageInfo(
  appName: 'Blockmancer',
  buildNumber: buildNumber,
  packageName: 'com.elietabet.blockmancer',
  version: version,
);
