package com.hyydra.notes

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Rect
import android.os.Bundle
import android.widget.RemoteViews
import java.io.File

class NotesWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        ids.forEach { id -> update(context, manager, id) }
    }

    // Resizing the card changes how much of the page fits, so it is drawn again.
    override fun onAppWidgetOptionsChanged(
        context: Context, manager: AppWidgetManager, id: Int, newOptions: Bundle
    ) {
        update(context, manager, id)
    }
    companion object {
        fun instanceCount(context: Context): Int =
            AppWidgetManager.getInstance(context)
                .getAppWidgetIds(ComponentName(context, NotesWidget::class.java)).size

        fun updateAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(ComponentName(context, NotesWidget::class.java))
            ids.forEach { update(context, manager, it) }
        }
        // The page is one phone wide, so it is scaled to the card's width and the
        // top of it is shown as far down as the card is tall. Fitting the whole
        // page instead shrinks it into a narrow strip on a short card.
        private fun fillWidth(context: Context, manager: AppWidgetManager, id: Int, page: Bitmap): Bitmap {
            val options = manager.getAppWidgetOptions(id)
            val density = context.resources.displayMetrics.density
            val portrait = context.resources.configuration.orientation == Configuration.ORIENTATION_PORTRAIT
            val widthDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 0)
            val heightDp = options.getInt(
                if (portrait) AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT
                else AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 0)
            // The card's own padding and title row are not part of the picture.
            val width = ((widthDp - 20) * density).toInt()
            val height = ((heightDp - 20 - 36) * density).toInt()
            if (width < 32 || height < 32) return page
            val scale = width.toFloat() / page.width
            val sourceHeight = minOf(page.height, (height / scale).toInt())
            val out = Bitmap.createBitmap(width, (sourceHeight * scale).toInt().coerceAtLeast(1), Bitmap.Config.ARGB_8888)
            Canvas(out).drawBitmap(page, Rect(0, 0, page.width, sourceHeight), Rect(0, 0, out.width, out.height), null)
            return out
        }

        private fun update(context: Context, manager: AppWidgetManager, id: Int) {
            val views = RemoteViews(context.packageName, R.layout.notes_widget)
            val prefs = context.getSharedPreferences("notes_widget", Context.MODE_PRIVATE)
            views.setTextViewText(R.id.widget_title, prefs.getString("title", "Pennino"))
            val file = File(context.filesDir, "notes_widget.png")
            if (file.exists()) {
                val opts = BitmapFactory.Options().apply { inPreferredConfig = Bitmap.Config.ARGB_8888 }
                BitmapFactory.decodeFile(file.absolutePath, opts)?.let { page ->
                    views.setImageViewBitmap(R.id.widget_image, fillWidth(context, manager, id, page))
                }
            }
            val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            if (intent != null) {
                val pending = PendingIntent.getActivity(context, 0, intent,
                    PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
                views.setOnClickPendingIntent(R.id.widget_root, pending)
                views.setOnClickPendingIntent(R.id.widget_image, pending)
            }
            manager.updateAppWidget(id, views)
        }
    }
}
