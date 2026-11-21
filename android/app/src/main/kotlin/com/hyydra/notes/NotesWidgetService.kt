package com.hyydra.notes

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import java.io.File

/** Feeds the card's list: one picture per page of the note. */
class NotesWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory =
        PagesFactory(applicationContext, intent.getIntExtra(
            AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID))

    private class PagesFactory(
        private val context: Context,
        private val widgetId: Int
    ) : RemoteViewsFactory {
        private var pageFiles: List<File> = emptyList()

        override fun onCreate() { load() }
        override fun onDataSetChanged() { load() }
        override fun onDestroy() { pageFiles = emptyList() }

        private fun load() {
            val prefs = context.getSharedPreferences("notes_widget", Context.MODE_PRIVATE)
            val count = prefs.getInt("pages", 0)
            pageFiles = (0 until count)
                .map { File(context.filesDir, "notes_widget_page_$it.png") }
                .filter { it.exists() }
        }

        override fun getCount(): Int = pageFiles.size

        override fun getViewAt(position: Int): RemoteViews {
            val views = RemoteViews(context.packageName, R.layout.notes_widget_page)
            val file = pageFiles.getOrNull(position) ?: return views
            val options = BitmapFactory.Options().apply {
                // A page is opaque paper, so two bytes a pixel are enough.
                inPreferredConfig = Bitmap.Config.RGB_565
            }
            BitmapFactory.decodeFile(file.absolutePath, options)?.let {
                views.setImageViewBitmap(R.id.widget_page_image, it)
            }
            // Tapping a page opens the app, through the template the card sets.
            views.setOnClickFillInIntent(R.id.widget_page_image, Intent())
            return views
        }

        override fun getLoadingView(): RemoteViews? = null
        override fun getViewTypeCount(): Int = 1
        override fun getItemId(position: Int): Long = position.toLong()
        override fun hasStableIds(): Boolean = true
    }
}
