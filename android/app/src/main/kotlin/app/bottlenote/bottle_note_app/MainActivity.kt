package app.bottlenote.bottle_note_app

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import java.net.URISyntaxException
import android.util.Log
import android.net.Uri

class MainActivity : FlutterActivity() {
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
                    Log.d("MainActivity", "Fallback URL: $fallbackUrl")

                    // 브라우저에서 fallback URL 열기 위한 Intent 생성
                    val fallbackIntent = Intent(Intent.ACTION_VIEW, Uri.parse(fallbackUrl))

                    // 해당 URL을 처리할 수 있는 앱이 있는지 확인
                    if (fallbackIntent.resolveActivity(packageManager) != null) {
                        startActivity(fallbackIntent)
                    } else {
                        Log.e("MainActivity", "No application can handle the fallback URL")
                    }
                }
            }
        } catch (e: URISyntaxException) {
            Log.e("MainActivity", "Invalid intent request", e)
        }
    }
}
