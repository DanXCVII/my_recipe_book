package com.release.my_recipe_book

import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStream
import java.lang.Exception

class MainActivity : FlutterActivity() {
    private var sharedText: String? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        handleShareIntent()

        MethodChannel(flutterEngine.dartExecutor, "app.channel.shared.data")
                .setMethodCallHandler { call, result ->
                    if (call.method.contentEquals("getSharedText")) {
                        result.success(sharedText)
                        sharedText = null
                    }
                }
    }

    fun handleShareIntent() {
        val action = intent.action
        val type = intent.type

        if (Intent.ACTION_VIEW == action && type != null) {
            if ("application/zip" == type) {
                handleFile(intent)
            }
        }
    }

    private fun handleFile(intent: Intent) {
        if (intent.data == null) {
            return
        }

        val uri = intent.data
        sharedText = uri?.toString()
        var out: FileOutputStream? = null
        var inn: InputStream? = null

        val outputFile = File(cacheDir.absolutePath + "/importRecipe.zip")

        try {
            outputFile.createNewFile()
        } catch (e: Exception) {
            println(e.toString())
        }
        try {
            inn = contentResolver.openInputStream(uri)
            out = FileOutputStream(outputFile)
            val buf = ByteArray(1024)
            var len = inn.read(buf)
            while (len > 0) {
                out.write(buf, 0, len)
                len = inn.read(buf)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        } finally {
            try {
                out?.close()
                inn?.close()
            } catch (e: IOException) {
                e.printStackTrace()
            }
        }
        sharedText = outputFile.absolutePath
    }
}
