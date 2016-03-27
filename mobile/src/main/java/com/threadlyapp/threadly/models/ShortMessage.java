package com.threadlyapp.threadly.models;

import com.threadlyapp.threadly.helpers.TextProcessor;

import java.util.ArrayList;
import java.util.Date;

/**
 * Created by Tanay on 27/03/16.
 */
public class ShortMessage
{
	String body;
	Date date;
	String recipients;
	String civilBody;
	ArrayList<String> tags;

	/*
	CONSTRUCTORS
	 */

	public ShortMessage ()
	{
		SetBody("");
		recipients = "";
		date = new Date();
		tags = new ArrayList<>();
	}

	public ShortMessage (Date d, String text, String person)
	{
		date = d;
		SetBody(text);
		recipients = person;
		tags = new ArrayList<>();
	}

	/*
	SET and GET
	 */

	public void SetBody (String text)
	{
		body = text;
		civilBody = TextProcessor.CivilizeText(body);
	}

	public String GetBody ()
	{
		return body;
	}

	public String GetCivilBody ()
	{
		return civilBody;
	}

	public void AddSender (String person)
	{
		if (recipients.length() > 0)
			recipients += ";";
		recipients += person;
	}

	public void AddTag (String tag)
	{
		tags.add(tag);
	}

	public void RemoveTag (String tag)
	{
		tags.remove(tag);
	}

	public ArrayList<String> GetTagList ()
	{
		return tags;
	}

	public boolean ContainsTag (String tag)
	{
		return tags.contains(tag);
	}
}
