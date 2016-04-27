package com.threadlyapp.threadly;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.StrictMode;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageButton;
import android.widget.Toast;

import com.ogaclejapan.smarttablayout.SmartTabLayout;
import com.ogaclejapan.smarttablayout.utils.v4.FragmentPagerItems;
import com.ogaclejapan.smarttablayout.utils.v4.FragmentPagerItemAdapter;
import com.threadlyapp.threadly.data.InboxManager;
import com.threadlyapp.threadly.helpers.TextProcessor;

public class MainActivity extends AppCompatActivity
{

	@Override
	protected void onCreate (Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		ImageButton fab = (ImageButton) findViewById(R.id.fab);
		fab.setOnClickListener(new View.OnClickListener()
		{
			@Override
			public void onClick (View view)
			{
				Intent composeSmsActivityIntent = new Intent(MainActivity.this, ComposeSmsActivity.class);
				MainActivity.this.startActivity(composeSmsActivityIntent);
			}
		});
		FragmentPagerItemAdapter adapter = new FragmentPagerItemAdapter(
				getSupportFragmentManager(), FragmentPagerItems.with(this)
				.add(R.string.titleA, AllMessagesFragment.class)
				.add(R.string.titleB, SocialMessagesFragment.class)
				.add(R.string.titleC, WorkMessagesFragment.class)
				.add(R.string.titleD, PromotionsMessagesFragment.class)
				.add(R.string.titleE, MiscMessagesFragment.class)
				.add(R.string.titleF, MarkedMessagesFragment.class)
				.create());

		ViewPager viewPager = (ViewPager) findViewById(R.id.viewpager);
		viewPager.setAdapter(adapter);
		SmartTabLayout viewPagerTab = (SmartTabLayout) findViewById(R.id.viewpagertab);
		viewPagerTab.setViewPager(viewPager);

		StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
		StrictMode.setThreadPolicy(policy);

		if (hasPermissionReadSMS())
			InboxManager.Start(this);
	}

	private int READ_REQUEST = 1;

	private boolean hasPermissionReadSMS ()
	{
		if (Build.VERSION.SDK_INT >= 23)
		{
			if (checkSelfPermission(Manifest.permission.READ_SMS) == PackageManager.PERMISSION_GRANTED)
				return true;
			else
			{
				ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.READ_SMS}, READ_REQUEST);
				return false;
			}
		}
		else
			return true;
	}

	@Override
	public void onRequestPermissionsResult (int requestCode, String[] permissions, int[] grantResults)
	{
		super.onRequestPermissionsResult(requestCode, permissions, grantResults);
		if (requestCode == READ_REQUEST)
		{
			if (grantResults[0] == PackageManager.PERMISSION_GRANTED)
				InboxManager.Start(this);
			else
				Toast.makeText(this, "Can not use the app without permission.", Toast.LENGTH_LONG).show();
		}
	}
}