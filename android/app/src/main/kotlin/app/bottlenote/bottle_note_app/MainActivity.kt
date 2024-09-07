package app.bottlenote.bottle_note_app

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import java.net.URISyntaxException
import android.util.Log

class MainActivity: FlutterActivity() {
       private val CHANNEL = "intent.channel"

        override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "handleIntentURI") {
                val url = call.argument<String>("url")
                handleIntentUri(url)
                result.success(null)
            }
        }
    }

        private fun handleIntentUri(url: String?) {
        if (url == null) return

        try {
            val intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME)
            if (intent.resolveActivity(packageManager) != null) {
                startActivity(intent)
            } else {
                val fallbackUrl = intent.getStringExtra("browser_fallback_url")
                if (fallbackUrl != null) {
                    // Fallback URL 처리
                }
            }
        } catch (e: URISyntaxException) {
            Log.e("MainActivity", "Invalid intent request", e)
        }
    }
}
