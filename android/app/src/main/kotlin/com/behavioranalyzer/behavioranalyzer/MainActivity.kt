package com.behavioranalyzer.behavioranalyzer

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes
import android.R.attr.start
import android.util.Log


class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    AppCenter.setLogLevel(Log.VERBOSE)
    AppCenter.start(getApplication(), "a353abf6-1d20-41d6-a1bb-b61840d6737b",
            Analytics::class.java, Crashes::class.java)
    GeneratedPluginRegistrant.registerWith(this)

  }
}
