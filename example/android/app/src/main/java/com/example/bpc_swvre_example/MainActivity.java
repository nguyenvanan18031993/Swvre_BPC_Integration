package com.example.bpc_swvre_example;

import android.os.Bundle;
import android.util.Log;

import androidx.annotation.Nullable;

import com.swrve.sdk.SwrveSDK;
import com.swrve.sdk.config.SwrveConfig;
import com.swrve.sdk.config.SwrveStack;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    private static MainActivity sInstance;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        sInstance = this;

        try {
            SwrveConfig config = new SwrveConfig();
            // To use the EU stack, include this in your config.
             config.setSelectedStack(SwrveStack.EU);
            SwrveSDK.createInstance(getApplication(), 7179, "general-PNdXX9jQXcSq5Oz1CMag", config);
        } catch (IllegalArgumentException exp) {
            Log.e("SwrveDemo", "Could not initialize the Swrve SDK", exp);
        }
    }

    public static MainActivity getInstance() {
        return sInstance;
    }
}
