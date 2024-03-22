package com.example.bpc_swvre_example;

import android.os.Bundle;

import androidx.annotation.Nullable;

import com.example.bpc_swvre.MyApplication;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    private static MainActivity sInstance;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        sInstance = this;
    }

    public static MainActivity getInstance() {
        return sInstance;
    }
}
