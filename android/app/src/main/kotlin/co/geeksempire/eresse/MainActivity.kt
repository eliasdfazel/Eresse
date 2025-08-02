package co.geeksempire.eresse

import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

import io.flutter.embedding.android.FlutterActivity

public class MainActivity: FlutterActivity() {

    companion object {
        const val CHANNEL: String = "app.channel.shared.data"
    }
    var sharedText: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val intent = getIntent()
        val action = intent.getAction()
        val type = intent.getType()

        if (Intent.ACTION_SEND == action) {
            if (intent.hasExtra(Intent.EXTRA_TEXT)) {
                handleSendText(intent) // Handle text being sent
            }
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
                { call, result ->
                    if (call.method.contentEquals("receiveSharedText")) {
                        result.success(sharedText)
                        sharedText = null
                    }
                }
            )
    }

    fun handleSendText(intent: Intent) {
        sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)
    }

}