package com.threadlyapp.threadly;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

/**
 * A placeholder fragment containing a simple view.
 */
public class PromotionsMessagesFragment extends Fragment
{

	public PromotionsMessagesFragment ()
	{
	}

	@Override
	public View onCreateView (LayoutInflater inflater, ViewGroup container,
	                          Bundle savedInstanceState)
	{
		return inflater.inflate(R.layout.fragment_promotions_messages, container, false);
	}
}
