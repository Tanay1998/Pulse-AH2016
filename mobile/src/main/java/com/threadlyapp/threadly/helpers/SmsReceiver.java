package com.threadlyapp.threadly.helpers;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.telephony.SmsMessage;
import android.widget.Toast;

import com.threadlyapp.threadly.models.ShortMessage;

import org.w3c.dom.Text;

import java.util.Date;

public class SmsReceiver extends BroadcastReceiver
{
	public static final String SMS_BUNDLE = "pdus";

	public void onReceive (Context context, Intent intent)
	{
		final Bundle bundle = intent.getExtras();
		try
		{
			if (bundle != null)
			{
				final Object[] pdusObj = (Object[]) bundle.get("pdus");

				for (int c = 0; c < pdusObj.length; c++)
				{
					SmsMessage currentMessage = SmsMessage.createFromPdu((byte[]) pdusObj[c]);

					String body = currentMessage.getDisplayMessageBody();
					String recep = currentMessage.getDisplayOriginatingAddress();
					long mills = currentMessage.getTimestampMillis();
					Date date = new Date(mills);
					int status = currentMessage.getStatus();
					ShortMessage message = new ShortMessage(date, body, recep);

					Toast.makeText(context, TextProcessor.CivilizeText(body), Toast.LENGTH_SHORT).show();
				}
			}
		}
		catch (Exception e) { }
	}
}