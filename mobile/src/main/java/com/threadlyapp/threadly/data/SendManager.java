package com.threadlyapp.threadly.data;

import android.support.v7.app.AppCompatActivity;
import android.telephony.SmsManager;
import android.widget.Toast;

import java.util.ArrayList;

/**
 * Created by Tanay on 28/03/16.
 */
public class SendManager
{
	private static AppCompatActivity activity;

	public static void SetActivity (AppCompatActivity a)
	{
		activity = a;
	}

	public static boolean SendSMS (ArrayList<String> receps, String body)
	{
		try
		{
			for (String recep : receps)
			{
				SmsManager smsManager = SmsManager.getDefault();
				smsManager.sendTextMessage(recep, null, body, null, null);
			}
			Toast.makeText(activity, "SMS Sent!", Toast.LENGTH_LONG).show();
		}
		catch (Exception e)
		{
			Toast.makeText(activity, "SMS failed, please try again later!", Toast.LENGTH_LONG).show();
			e.printStackTrace();
			return false;
		}
		return true;
	}
}
