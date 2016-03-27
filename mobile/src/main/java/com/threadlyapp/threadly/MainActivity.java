package com.threadlyapp.threadly;

import android.os.Bundle;
import android.os.StrictMode;
import android.support.design.widget.Snackbar;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageButton;
import android.widget.Toast;

import com.ogaclejapan.smarttablayout.SmartTabLayout;
import com.ogaclejapan.smarttablayout.utils.v4.FragmentPagerItems;
import com.ogaclejapan.smarttablayout.utils.v4.FragmentPagerItemAdapter;
import com.threadlyapp.threadly.helpers.TextProcessor;

public class MainActivity extends AppCompatActivity
{

	@Override
	protected void onCreate (Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		//Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
		//setSupportActionBar(toolbar);
		ImageButton fab = (ImageButton) findViewById(R.id.fab);
		fab.setOnClickListener(new View.OnClickListener()
		{
			@Override
			public void onClick (View view)
			{
				Snackbar.make(view, "Arrey! LOL abhi kuch nahi hota.", Snackbar.LENGTH_LONG)
						.setAction("Action", null).show();
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

		Toast.makeText(this, TextProcessor.CivilizeText("how r u?"), Toast.LENGTH_LONG).show();
	}
}