package com.threadlyapp.threadly;

import android.app.Activity;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.support.v4.app.Fragment;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;

import com.threadlyapp.threadly.data.SendManager;

import org.w3c.dom.Text;

import java.util.ArrayList;

/**
 * A placeholder fragment containing a simple view.
 */
public class ComposeSmsFragment extends Fragment
{

	public ComposeSmsFragment ()
	{
	}

	@Override
	public View onCreateView (LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		final View v = inflater.inflate(R.layout.fragment_compose_sms, container, false);
		ImageButton sendMessageButton = (ImageButton) v.findViewById(R.id.sendMessageButton);
		sendMessageButton.setOnClickListener(new View.OnClickListener()
		{
			@Override
			public void onClick (View k)
			{
				SendManager smsSender = new SendManager();
				TextView recep = (TextView) v.findViewById(R.id.phoneNo);
				TextView smsText = (TextView) v.findViewById(R.id.smsText);
				ArrayList<String> receps = new ArrayList<String>();
				receps.add(0, recep.getText().toString());
				AppCompatActivity host = (AppCompatActivity) v.getContext();
				smsSender.SetActivity(host);
				smsSender.SendSMS(receps, smsText.getText().toString());
			}
		});
		return v;
	}
}
