package com.memedko.choose_name

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "choose_name/share",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "shareText" -> {
                    val text = call.argument<String>("text").orEmpty()
                    val subject = call.argument<String>("subject")
                    if (text.isBlank()) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    val sendIntent = Intent(Intent.ACTION_SEND).apply {
                        type = "text/plain"
                        putExtra(Intent.EXTRA_TEXT, text)
                        if (!subject.isNullOrBlank()) {
                            putExtra(Intent.EXTRA_SUBJECT, subject)
                        }
                    }
                    val chooser = Intent.createChooser(sendIntent, subject ?: "")
                    startActivity(chooser)
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }
    }
}
