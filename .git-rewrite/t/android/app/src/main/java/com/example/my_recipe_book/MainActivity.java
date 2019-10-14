package com.example.my_recipe_book;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private String sharedText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        Intent intent = getIntent();
        String action = intent.getAction();
        String type = intent.getType();

        if (Intent.ACTION_VIEW.equals(action) && type != null) {
            if ("application/zip".equals(type)) {
                handleFile(intent); // Handle text being sent
            }
        }

        new MethodChannel(getFlutterView(), "app.channel.shared.data").setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.contentEquals("getSharedText")) {
                            result.success(sharedText);
                            sharedText = null;
                        }
                    }
                });
    }

    @Override
    protected void onNewIntent(Intent intent) {
        // Handle intent when app is resumed
        super.onNewIntent(intent);
        handleFile(intent);
    }

    void handleFile(Intent intent) {
        if (intent == null || intent.getData() == null) {
            return;
        }
        Uri _uri = intent.getData();

        sharedText = _uri.toString();

        OutputStream out = null;
        InputStream in = null;

        File outputFile = new File(getCacheDir().getAbsolutePath() + "/importRecipe.zip");

        try {
            outputFile.createNewFile();
        }
         catch
        (Exception e) {
            System.out.println(e.toString());
        }

        try {
            in = getContentResolver().openInputStream(_uri);
            out = new FileOutputStream(outputFile);
            byte[] buf = new byte[1024];
            int len;
            while ((len = in.read(buf)) > 0) {
                out.write(buf, 0, len);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Ensure that the InputStreams are closed even if there's an exception.
            try {
                if (out != null) {
                    out.close();
                }

                // If you want to close the "in" InputStream yourself then remove this
                // from here but ensure that you close it yourself eventually.
                in.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        sharedText = outputFile.getAbsolutePath();
/*
        String filePath = null;
        if (_uri != null && "content".equals(_uri.getScheme())) {
            Cursor cursor = this.getContentResolver().query(_uri, new String[]{android.provider.MediaStore.Images.ImageColumns.DATA}, null, null, null);
            cursor.moveToFirst();
            filePath = cursor.getString(0);

            cursor.close();
        } else {
            filePath = _uri.getPath();
        }
        sharedText = filePath;
        **/
    }
}