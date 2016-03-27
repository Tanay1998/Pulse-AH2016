package com.threadlyapp.threadly;

import android.app.Application;
import android.content.SharedPreferences;
import android.os.StrictMode;
import android.preference.PreferenceManager;

/**
 * Created by Tanay on 27/03/16.
 */
public class ThreadlyApplication extends Application
{
	public static SharedPreferences preferences;

	@Override
	public void onCreate ()
	{
		super.onCreate();
		StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
		StrictMode.setThreadPolicy(policy);
	}
}
