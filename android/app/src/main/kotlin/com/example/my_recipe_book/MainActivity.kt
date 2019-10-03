package com.example.my_recipe_book

import android.content.Intent;
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.ActivityLifecycleListener
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class MainActivity: FlutterActivity() {

  private var sharedData: String? = null
  override fun onCreate(savedInstanceState: Bundle) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    // Handle intent when app is initially opened
    handleSendIntent(getIntent())
    
    MethodChannel(flutterView, "app.channel.shared.data").setMethodCallHandler { call, result ->
      if (call.method.contentEquals("getSharedData")) {
        result.success(sharedData)
      }
    }
  }

  override fun onNewIntent(intent: Intent) {
    // Handle intent when app is resumed
    super.onNewIntent(intent)
    handleSendIntent(intent)
  }

  private fun handleSendIntent(intent: Intent) {
    val action = intent.getAction()
    val type = intent.getType()

    // We only care about sharing intent that contain plain text
    if (Intent.ACTION_SEND.equals(action) && type != null) {
      if ("application/zip" == type) {
        println(intent.toString())
        var filePath = intent.toString();
        if (filePath.startsWith("file:///")) {
          sharedData = filePath.substring(7)
        } else {
          sharedData = filePath;
        }
      }
    }
  }
}
