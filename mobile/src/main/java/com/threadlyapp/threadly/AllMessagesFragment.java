package com.threadlyapp.threadly;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.threadlyapp.threadly.adapters.MessageListAdapter;
import com.threadlyapp.threadly.data.InboxManager;
import com.threadlyapp.threadly.models.ShortMessage;

import java.util.ArrayList;
import java.util.List;

/**
 * A placeholder fragment containing a simple view.
 */
public class AllMessagesFragment extends Fragment
{
	MessageListAdapter adapter;
	public AllMessagesFragment ()
	{

	}

	@Override
	public View onCreateView (LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		View v = inflater.inflate(R.layout.fragment_all_messages, container, false);
		ListView allMessagesList = (ListView) v.findViewById(R.id.allMessageList);
		ArrayList<ShortMessage> smsList = InboxManager.GetInbox();
		adapter = new MessageListAdapter(smsList, null);  // TODO
		allMessagesList.setAdapter(adapter);
		return v;
	}
}
