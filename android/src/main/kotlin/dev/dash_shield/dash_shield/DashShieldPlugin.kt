package dev.dash_shield.dash_shield

import android.app.Activity
import android.view.WindowManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class DashShieldPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private var activity: Activity? = null
  private var globalScreenshotPrevention = false  // Tracks if screenshots are prevented globally

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dash_shield")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "preventScreenshots" -> {
        if (!globalScreenshotPrevention) {
          // Set FLAG_SECURE only for the current screen
          activity?.window?.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE
          )
        }
        result.success(null)
      }
      "allowScreenshots" -> {
        if (!globalScreenshotPrevention) {
          // Clear FLAG_SECURE to allow screenshots if global prevention is not active
          activity?.window?.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
        }
        result.success(null)
      }
      "preventScreenshotsGlobally" -> {
        globalScreenshotPrevention = true
        // Set FLAG_SECURE for all screens globally
        activity?.window?.setFlags(
          WindowManager.LayoutParams.FLAG_SECURE,
          WindowManager.LayoutParams.FLAG_SECURE
        )
        result.success(null)
      }
      "allowScreenshotsGlobally" -> {
        globalScreenshotPrevention = false
        // Clear FLAG_SECURE globally to allow screenshots on all screens
        activity?.window?.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    // Reapply global prevention if active when activity is reattached
    if (globalScreenshotPrevention) {
      activity?.window?.setFlags(
        WindowManager.LayoutParams.FLAG_SECURE,
        WindowManager.LayoutParams.FLAG_SECURE
      )
    }
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}