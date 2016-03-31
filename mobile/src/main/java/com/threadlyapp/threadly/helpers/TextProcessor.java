package com.threadlyapp.threadly.helpers;

import android.net.Uri;
import android.util.Log;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;

/**
 * Created by Tanay on 27/03/16.
 */
public class TextProcessor
{
	public static String CivilizeText (String body)
	{
//		Log.d("HERE", "HERE");
//		String api1 = "http://threadlyapp.com/apis/slang/1.php?s=" + Uri.encode(body);
//		String out1 = "";
//		try
//		{
//			URL url = new URL(api1);
//
//			BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));
//
//			String line;
//			StringBuilder lines = new StringBuilder();
//			while ((line = in.readLine()) != null)
//			{
//				lines.append(line);
//			}
//			in.close();
//			out1 = lines.toString();
//		}
//		catch (MalformedURLException e)
//		{
//			System.out.println("Malformed URL: " + e.getMessage());
//			return body;
//		}
//		catch (IOException e)
//		{
//			System.out.println("I/O Error: " + e.getMessage());
//			return body;
//		}
//
		return body;
	}
}

/* MAKE ASYNC

private class SendfeedbackJob extends AsyncTask<String, Void, String> {

    @Override
    protected String doInBackground(String[] params) {
        // do above Server call here
        return "some message";
    }

    @Override
    protected void onPostExecute(String message) {
        //process message
    }
}

SendfeedbackJob job = new SendfeedbackJob();
job.execute(pass, email);

 */