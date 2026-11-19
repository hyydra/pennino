package com.hyydra.notes

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.net.Uri
import android.os.Bundle
import android.widget.RemoteViews

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
            manager.notifyAppWidgetViewDataChanged(ids, R.id.widget_list)
        }

        private fun update(context: Context, manager: AppWidgetManager, id: Int) {
            val views = RemoteViews(context.packageName, R.layout.notes_widget)
            val prefs = context.getSharedPreferences("notes_widget", Context.MODE_PRIVATE)
            views.setTextViewText(R.id.widget_title, prefs.getString("title", "Pennino"))

            // The card is the note's paper colour, and its title is dark or
            // light, whichever reads on that paper.
            val background = prefs.getInt("background", Color.parseColor("#FFFCF5"))
            views.setInt(R.id.widget_bg, "setColorFilter", background)
            val luminance = (0.299 * Color.red(background) + 0.587 * Color.green(background) +
                0.114 * Color.blue(background)) / 255.0
            views.setTextColor(R.id.widget_title,
                if (luminance > 0.5) Color.parseColor("#243036") else Color.parseColor("#F5F0E5"))

            // The pages are a scrolling list; each id has its own adapter intent.
            val adapter = Intent(context, NotesWidgetService::class.java).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, id)
                data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
            }
            views.setRemoteAdapter(R.id.widget_list, adapter)

            val launch = context.packageManager.getLaunchIntentForPackage(context.packageName)
            if (launch != null) {
                val flags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
                val pending = PendingIntent.getActivity(context, 0, launch, flags)
                views.setPendingIntentTemplate(R.id.widget_list, pending)
                views.setOnClickPendingIntent(R.id.widget_title, pending)
            }
            manager.updateAppWidget(id, views)
        }
    }
}
