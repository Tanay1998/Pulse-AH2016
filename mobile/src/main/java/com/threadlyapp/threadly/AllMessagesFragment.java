package com.threadlyapp.threadly;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.threadlyapp.threadly.data.InboxManager;
import com.threadlyapp.threadly.models.ShortMessage;

/**
 * A placeholder fragment containing a simple view.
 */
public class AllMessagesFragment extends Fragment
{

	public AllMessagesFragment ()
	{
	}

	@Override
	public View onCreateView (LayoutInflater inflater, ViewGroup container,
	                          Bundle savedInstanceState)
	{
		ListView messages = (ListView) getView().findViewById(R.id.allMessageList);

		return inflater.inflate(R.layout.fragment_all_messages, container, false);
	}
}
