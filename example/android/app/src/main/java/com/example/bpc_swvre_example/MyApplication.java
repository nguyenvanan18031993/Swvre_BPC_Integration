package com.example.bpc_swvre_example;

import android.util.Log;

import com.swrve.sdk.SwrveSDK;
import com.swrve.sdk.config.SwrveConfig;
import com.swrve.sdk.config.SwrveStack;

import io.flutter.app.FlutterApplication;

public class MyApplication extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();

        try {
            SwrveConfig config = new SwrveConfig();
            // To use the EU stack, include this in your config.
            config.setSelectedStack(SwrveStack.EU);
            SwrveSDK.createInstance(this, 6974, "DZqhrkzFOqEo9eReySOl", config);
        } catch (IllegalArgumentException exp) {
            Log.e("SwrveDemo", "Could not initialize the Swrve SDK", exp);
        }
    }
}
