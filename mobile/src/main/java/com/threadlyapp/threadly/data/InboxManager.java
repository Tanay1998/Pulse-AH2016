package com.threadlyapp.threadly.data;

import android.content.ContentResolver;
import android.database.Cursor;
import android.net.Uri;
import android.provider.Telephony;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.widget.ListView;

import com.threadlyapp.threadly.AllMessagesFragment;
import com.threadlyapp.threadly.MainActivity;
import com.threadlyapp.threadly.R;
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
	static AppCompatActivity activity;

	public static void Start (AppCompatActivity a)
	{
		activity = a;
		AddDummyMessage();
	//	RefreshInbox();
	}

	private static void AddDummyMessage ()
	{
		messages = new ArrayList<>();
		ShortMessage sms = new ShortMessage(new Date(), "You can't see me, my time is now.", "John Cena");
		messages.add(sms);
	}


	public static void Migrate ()
	{
//		ContentResolver contentResolver = activity.getContentResolver();
//		Cursor smsInboxCursor = contentResolver.query(Uri.parse("content://sms/inbox"), null, null, null, null);
//		int indexBody = smsInboxCursor.getColumnIndex("body");
//		int indexAddress = smsInboxCursor.getColumnIndex("address");
//		long timeMillis = smsInboxCursor.getColumnIndex("date");
//		Date date = new Date(timeMillis);
//		SimpleDateFormat format = new SimpleDateFormat("dd/MM/yy");
//		String dateText = format.format(date);
//
//		if (indexBody < 0 || !smsInboxCursor.moveToFirst())
//			return;
//
//		do {
//
//		} while (smsInboxCursor.moveToNext());
	}

	public static void RefreshInbox ()
	{
		messages = new ArrayList<>();
		ContentResolver contentResolver = activity.getContentResolver();
		//String[] cols = {"_id", "thread_id", "address", "body"};
		// Last parameter is for sorting, Second column is for selection. Third for projection
		// Create Sent box URI
		Uri sentURI = Uri.parse("content://sms/inbox");

		// List required columns
		String[] reqCols = new String[] { "_id", "person", "seen", "thread_id", "address", "body" };

		Cursor c = contentResolver.query(sentURI, null, null, null, null);

		int x = 0;
		if (c != null && c.moveToFirst())
		{
			do
			{
//				String out = String.valueOf(c.getLong(0)) + " @ " + String.valueOf(c.getLong(1)) + " @ " + c.getString(2)
//						+ " @ " + c.getString(4) + " @ " + String.valueOf(c.getLong(4)) + " @ " +
//						String.valueOf(c.getInt(6)) + " @ " + String.valueOf(c.getInt(7)) + " @ " +
//						String.valueOf(c.getInt(8)) + " @ " + c.getString(10) + " @ " + c.getString(11) + " @ " +
//						String.valueOf(c.getInt(13));
				String out = c.getString(c.getColumnIndex("body"));

				ShortMessage sms = new ShortMessage();
				sms.SetBody(c.getString(c.getColumnIndex("body")));
				sms.AddSender(c.getString(c.getColumnIndex("person")));
				sms.SetID(c.getLong(c.getColumnIndex("_id")));
				sms.SetThreadID(c.getLong(c.getColumnIndex("thread_id")));
				sms.SetSeenStatus((int)c.getLong(c.getColumnIndex("seen")));
				messages.add(sms);


			/*
			0:      _id
			1:     thread_id
			2:     address              String
			3:     person               String
			4:     date                 Date
			5:     protocol
			-6:     read
			-7:    status
			-8:    type
			9:    reply_path_present
			-(null)10:    subject              String
			-11:    body                 String
			12:    service_center
			13:    locked
			14:     error code
			15:     seen
			 */
				Log.d("Message Details", out);
				x++;
			} while (c.moveToNext());
		}
		Log.d("Message Details", String.valueOf(x) + " messages found.");
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

	public static AppCompatActivity GetActivity ()
	{
		return activity;
	}

}
