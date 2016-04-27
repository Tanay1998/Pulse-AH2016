package com.threadlyapp.threadly.models;

import com.threadlyapp.threadly.helpers.TextProcessor;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;

import io.realm.RealmObject;
import io.realm.annotations.Index;

/**
 * Created by Tanay on 27/03/16.
 */
public class ShortMessage extends RealmObject
{
	@Index
	String body;
	Date date;
	String recipients;
	String civilBody;
	String tags;
	long thread_id;
	boolean seen;
	long id;

	/*
	CONSTRUCTORS
	 */

	public ShortMessage ()
	{
		SetBody("");
		recipients = "";
		date = new Date();
		tags = "";
	}

	public ShortMessage (Date d, String text, String person)
	{
		date = d;
		SetBody(text);
		recipients = person;
		tags = "";
	}

	/*
	SETTERS and GETTERS
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

	public String GetSender ()
	{
		if (recipients.indexOf(";") == -1)
			return recipients;
		return recipients.substring(0, recipients.indexOf(";"));
	}

	public void AddSender (String person)
	{
		recipients += person + ";";
	}

	public void AddTag (String tag)
	{
		if (tags.length() > 0)
			tags += ";";
		tags += tag;
	}

	public void RemoveTag (String tag)
	{
		tags.replace(tag, "");
		tags.replace(";;", ";");
	}

	public ArrayList<String> GetTagList ()
	{
		return new ArrayList<String>(Arrays.asList(tags.split(";")));
	}

	public boolean ContainsTag (String tag)
	{
		return tags.contains(tag);
	}

	public long GetID ()
	{
		return id;
	}

	public void SetID (long value)
	{
		id = value;
	}

	public long GetThreadID ()
	{
		return thread_id;
	}

	public void SetThreadID (long value)
	{
		thread_id = value;
	}

	public boolean IsSeen ()
	{
		return seen;
	}

	public void SetSeenStatus (int s)
	{
		seen = (s != 0);
	}

	/*
	METHODS
	 */

	@Override
	public boolean equals (Object o)
	{
		ShortMessage sms = (ShortMessage) o;
		return (sms.GetID() != -1 && sms.GetID() == id);
	}
}
