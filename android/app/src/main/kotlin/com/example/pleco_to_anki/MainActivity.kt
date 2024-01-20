package com.example.pleco_to_anki

import android.content.pm.PackageManager
import androidx.core.content.ContextCompat
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import com.ichi2.anki.api.AddContentApi

class MainActivity: FlutterActivity() {
  private val CHANNEL = "com.example.pleco_to_anki/ankidroid"
  private val REQ_PERM_CODE = 1

  private var requestPermissionResult: MethodChannel.Result? = null

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    val api = AddContentApi(applicationContext)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      if (call.method == "requestPermission") {
        ActivityCompat.requestPermissions(activity, arrayOf("com.ichi2.anki.permission.READ_WRITE_DATABASE"), REQ_PERM_CODE)
        requestPermissionResult = result
        return@setMethodCallHandler
      }

      val permission = ContextCompat.checkSelfPermission(applicationContext, "com.ichi2.anki.permission.READ_WRITE_DATABASE")
      if (permission != PackageManager.PERMISSION_GRANTED) {
        result.error("Permission to use and modify AnkiDroid database not granted!", "Permission to use and modify AnkiDroid database not granted!", null)
      }
      when (call.method) {
        "deckList" -> result.success(api.deckList)

        "addNewDeck" -> {
          val deckName = call.argument<String>("deckName")!!
          result.success(api.addNewDeck(deckName))
        }

        "modelList" -> result.success(api.modelList)

        "addNewCustomModel" -> {
          val name = call.argument<String>("name")!!
          val fields = call.argument<List<String>>("fields")!!
          val cards = call.argument<List<String>>("cards")!!
          val qfmt = call.argument<List<String>>("qfmt")!!
          val afmt = call.argument<List<String>>("afmt")!!
          val css = call.argument<String>("css")!!
          val did = call.argument<Int?>("did")?.toLong()
          val sortf = call.argument<Int?>("sortf")
          result.success(api.addNewCustomModel(name, fields.toTypedArray(), cards.toTypedArray(), qfmt.toTypedArray(), afmt.toTypedArray(), css, did, sortf))
        }

        "findDuplicateNotesWithKey" -> {
          val mid = call.argument<Long>("mid")!!
          val key = call.argument<String>("key")!!
          val dupes = api.findDuplicateNotes(mid, key).map {hashMapOf(
            "id" to it!!.getId(),
            "fields" to it.getFields().toList(),
            "tags" to it.getTags().toList()
          )}
          result.success(dupes)
        }

        "addNote" -> {
          val modelId = call.argument<Long>("modelId")!!
          val deckId = call.argument<Long>("deckId")!!
          val fields = call.argument<List<String>>("fields")!!.toTypedArray()
          val tags = call.argument<List<String>>("tags")!!.toSet()
          result.success(api.addNote(modelId, deckId, fields, tags))
        }

        else -> result.notImplemented()
      }
    }
  }

  override fun onRequestPermissionsResult(
    requestCode: Int,
    permissions: Array<out String>,
    grantResults: IntArray
  ) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    if (requestCode == REQ_PERM_CODE && requestPermissionResult != null) {
      requestPermissionResult!!.success(grantResults[0] == PackageManager.PERMISSION_GRANTED)
    }
  }
}
