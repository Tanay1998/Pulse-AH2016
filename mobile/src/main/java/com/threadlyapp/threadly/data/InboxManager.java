package com.threadlyapp.threadly.data;

import android.content.ContentResolver;
import android.database.Cursor;
import android.net.Uri;

import com.threadlyapp.threadly.MainActivity;
import com.threadlyapp.threadly.models.ShortMessage;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

/**
 * Created by Tanay on 27/03/16.
 */
public class InboxManager
{
	static ArrayList<ShortMessage> messages;
	static MainActivity activity;

	public static void Migrate ()
	{
		ContentResolver contentResolver = activity.getContentResolver();
		Cursor smsInboxCursor = contentResolver.query(Uri.parse("content://sms/inbox"), null, null, null, null);
		int indexBody = smsInboxCursor.getColumnIndex("body");
		int indexAddress = smsInboxCursor.getColumnIndex("address");
		long timeMillis = smsInboxCursor.getColumnIndex("date");
		Date date = new Date(timeMillis);
		SimpleDateFormat format = new SimpleDateFormat("dd/MM/yy");
		String dateText = format.format(date);

		if (indexBody < 0 || !smsInboxCursor.moveToFirst())
			return;

		do {

		} while (smsInboxCursor.moveToNext());
	}

	public static void RefreshInbox ()
	{
		messages = new ArrayList<>();


		// Get SMS
		// Get corresponding data from SQLite datastore
		// Link both of them
	}

	public static ArrayList<ShortMessage> GetInbox ()
	{
		return messages;
	}

	public static ArrayList<ShortMessage> GetInboxForTag (String tag)
	{
		ArrayList<ShortMessage> results = new ArrayList<>();
		for (ShortMessage msg : messages)
		{
			if (msg.ContainsTag(tag))
				results.add(msg);

		}
		return results;
	}
}
