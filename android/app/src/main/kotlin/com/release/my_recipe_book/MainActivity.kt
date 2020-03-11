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
    private var processedIntent: Intent? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        println("initializing app")
        processedIntent = intent;

        MethodChannel(flutterEngine.dartExecutor, "app.channel.shared.data")
                .setMethodCallHandler { call, result ->
                    if (call.method.contentEquals("getSharedText")) {
                        handleShareIntent()
                        result.success(sharedText)
                        sharedText = null
                    }
                }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent);
        processedIntent = intent;
    }

    fun handleShareIntent() {
        val action = processedIntent?.action
        val type = processedIntent?.type

        if (Intent.ACTION_VIEW == action && type != null) {
            if ("application/zip" == type) {
                val intentk = processedIntent;
                handleFile(processedIntent)
            }
        } else {
            println("intent type is null or ACTION_VIEW not equal to action");
        }
    }

    private fun handleFile(intent: Intent?) {
        if (intent?.data == null) {
            println("intent data is null");
            return
        }
        println("processing valid intent");

        val uri = intent?.data
        sharedText = uri?.toString()
        var out: FileOutputStream? = null
        var inn: InputStream? = null

        var failedFileCreation = false;
        var failedWriting = false;
        var failedClosing = false;


        val outputFile = File(cacheDir.absolutePath + "/importRecipe.zip")

        try {
            outputFile.createNewFile()
        } catch (e: Exception) {
            failedFileCreation = true;
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
            failedWriting = true;
            e.printStackTrace()
        } finally {
            try {
                out?.close()
                inn?.close()
            } catch (e: IOException) {
                failedClosing = true;
                e.printStackTrace()
            }
        }
        if (failedFileCreation) {
            sharedText = "failedFileCreation"
        } else if (failedWriting) {
            sharedText = "failedWriting"
        } else if(failedClosing) {
            sharedText = "failedClosing";
        } else {
            println("finished processing intent with sharedText: $sharedText");
            processedIntent = null;
            sharedText = outputFile.absolutePath
        }
    }
}
