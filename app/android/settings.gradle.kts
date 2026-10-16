pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.0.1" apply false
    id("org.jetbrains.kotlin.android") version "2.3.20" apply false
    // Reads google-services.json into the build. Pinned to the current line:
    // this module is on AGP 9, which the older 4.4.x releases predate.
    id("com.google.gms.google-services") version "4.5.0" apply false
    // Uploads the R8 mapping, so a native stack trace in a crash report reads.
    id("com.google.firebase.crashlytics") version "3.0.8" apply false
}

include(":app")
