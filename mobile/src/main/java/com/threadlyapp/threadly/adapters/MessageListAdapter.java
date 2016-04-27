package com.threadlyapp.threadly.adapters;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.threadlyapp.threadly.R;
import com.threadlyapp.threadly.data.InboxManager;
import com.threadlyapp.threadly.models.ShortMessage;

import java.util.ArrayList;

/**
 * Created by Tanay on 28/04/16.
 */
public class MessageListAdapter extends BaseAdapter
{
	private ArrayList<ShortMessage> smsList;
	private static LayoutInflater inflater = null;
	public Resources res;

	public MessageListAdapter (ArrayList<ShortMessage> smss, Resources resLocal)
	{
		smsList = smss;
		res = resLocal;
		inflater = (LayoutInflater) InboxManager.GetActivity().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
	}


	@Override
	public int getCount ()
	{
		return (smsList == null ? 0 : smsList.size());
	}

	@Override
	public Object getItem (int position)
	{
		return smsList.get(position);
	}

	@Override
	public long getItemId (int position)
	{
		return position;
	}

	ShortMessage tempMessage = null;

	@Override
	public View getView (int position, View convertView, ViewGroup parent)
	{
		View v = convertView;
		ThreadlyViewHolder holder;

		if (convertView == null)
		{
			v = inflater.inflate(R.layout.message_list_row, null);

			holder = new ThreadlyViewHolder();
			holder.picView = (ImageView) v.findViewById(R.id.messageListImage);
			holder.nameView = (TextView) v.findViewById(R.id.messageListName);
			holder.snippetView = (TextView) v.findViewById(R.id.messageListText);
		}
		else
		{
			holder = (ThreadlyViewHolder) v.getTag();
		}

		tempMessage = smsList.get(position);

		holder.picView.setImageResource(R.drawable.new_message_fab);    // TODO
		holder.nameView.setText(tempMessage.GetSender());
		holder.snippetView.setText(tempMessage.GetBody());

		return v;
	}

	public class ThreadlyViewHolder
	{
		public ImageView picView;
		public TextView nameView, snippetView;
	}
}
