package com.avoprojects.dummygram

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.os.PersistableBundle
import android.util.LruCache
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CACHE_CHANNEL = "dummygram.android/lrucache"

    /*private fun setupPermissions() {
        val perms: Array<String> = arrayOf(
                Manifest.permission.CAMERA,
                Manifest.permission.ACCESS_NETWORK_STATE,
                Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE,
                Manifest.permission.INTERNET
        );
        val unGrantedPerms: Array<String> = arrayOf();
        perms.forEach {

            val permission = ContextCompat.checkSelfPermission(this,
                    it)

            if (permission != PackageManager.PERMISSION_GRANTED) {
                unGrantedPerms[perms.indexOf(it)] = it
            }
        }
        print(unGrantedPerms)
        if(unGrantedPerms.isNotEmpty())
            requestPermissions(unGrantedPerms, 1);
    }

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        setupPermissions();
        super.onCreate(savedInstanceState, persistentState)
    }

    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<out String>,
            grantResults: IntArray) {

        grantResults.forEach {
            if(it != PackageManager.PERMISSION_GRANTED)
                finishAndRemoveTask()
        }
    }*/

    var cache0 =
    object : LruCache<String, ByteArray>(20 * 1024 * 1024 /*20 MiB*/) {
        override fun sizeOf(key: String, value: ByteArray): Int {
            return value.size
        }
    }

    var cache1 =
    object : LruCache<String, ByteArray>(20 * 1024 * 1024 /*20 MiB*/) {
        override fun sizeOf(key: String, value: ByteArray): Int {
            return value.size
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CACHE_CHANNEL).setMethodCallHandler {
            call, result -> handleMethod(call, result)
        }
    }

    private fun handleMethod(call: MethodCall, result: MethodChannel.Result){
        when(call.method){
            "getFromCache0" -> {
                val res = getFromCache0(call.arguments as String)
                result.success(res)
                return
            }
            "addToCache0" -> {
                val args = call.arguments as List<*>
                val res = addToCache0(args[0] as String, args[1] as ByteArray)
                result.success(res)
                return
            }
            "clearCache0" -> {
                val res = clearCache0()
                result.success(res)
                return
            }

            "getFromCache1" -> {
                val res = getFromCache1(call.arguments as String)
                result.success(res)
                return
            }
            "addToCache1" -> {
                val args = call.arguments as List<*>
                val res = addToCache1(args[0] as String, args[1] as ByteArray)
                result.success(res)
                return
            }
            "clearCache1" -> {
                val res = clearCache1()
                result.success(res)
                return
            }
            else -> result.notImplemented()
        }
    }

    private fun getFromCache0(key: String) : ByteArray? {
        return try {
            synchronized(cache0) {
                cache0.get(key)
            }
        }catch(e: Exception){
            null
        }
    }

    private fun addToCache0(key: String, value: ByteArray) : String? {
        return try {
            synchronized(cache0) {
                if(cache0.get(key) == null) {
                    cache0.put(key, value)
                }
            }
            null
        }catch(e: Exception){
            e.message
        }
    }

    private fun clearCache0() : Boolean {
        return try {
            synchronized(cache0) {
                cache0.evictAll()
            }
            true
        }catch(e: Exception){
            false
        }
    }

    private fun getFromCache1(key: String) : ByteArray? {
        return try {
            synchronized(cache1) {
                cache1.get(key)
            }
        }catch(e: Exception){
            null
        }
    }

    private fun addToCache1(key: String, value: ByteArray) : String? {
        return try {
            synchronized(cache1) {
                if(cache1.get(key) == null) {
                    cache1.put(key, value)
                }
            }
            null
        }catch(e: Exception){
            e.message
        }
    }

    private fun clearCache1() : Boolean{
        return try {
            synchronized(cache1) {
                cache1.evictAll()
            }
            true
        }catch(e: Exception){
            false
        }
    }

}

