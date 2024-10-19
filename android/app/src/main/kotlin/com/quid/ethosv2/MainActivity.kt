package com.quid.ethosv2

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.quid.ethosv2/security_check"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "isDeviceCompromised") {
                result.success(isDeviceCompromised())
            } else {
                result.notImplemented()
            }
        }
    }

    private fun isDeviceCompromised(): Boolean {
        return isPackageInstalled("com.topjohnwu.magisk") ||
                isPackageInstalled("com.noshufou.android.su") ||
                isPackageInstalled("com.thirdparty.superuser") ||
                isPackageInstalled("eu.chainfire.supersu") ||
                isPackageInstalled("com.koushikdutta.superuser") ||
                isPackageInstalled("com.zachspong.temprootremovejb") ||
                isPackageInstalled("com.ramdroid.appquarantine")
    }

    private fun isPackageInstalled(packageName: String): Boolean {
        return try {
            packageManager.getPackageInfo(packageName, 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }
}