package com.avx.beep

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor  // Import this

class MainActivity : FlutterActivity() {

    companion object {
        var engine: FlutterEngine? = null

        fun provideEngine(context: Context): FlutterEngine {
            if (engine == null) {
                engine = FlutterEngine(context)
                engine!!.dartExecutor.executeDartEntrypoint(
                    DartExecutor.DartEntrypoint.createDefault()
                )
            }
            return engine!!
        }
    }
}
