using System.Collections.Generic;
using Godot;
using Godot.Collections;
using System;

public partial class MusicPlayer : Node
{
	[Export]
	public Dictionary properties;

	[Export]
	public AudioStreamPlayer audioStreamPlayer;

	Timer timer;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		timer = new Timer();
		timer.WaitTime = 0.5;
		timer.OneShot = true;
		AddChild(timer);
		timer.Timeout += PlayMusic;
		timer.Start();
	}

	void PlayMusic()
	{
		timer.QueueFree();
		if (properties.ContainsKey("music"))
		{
			String musicName = properties.GetValueOrDefault("music").ToString();
			String musicPath = "res//music/" + musicName + ".ogg";
			AudioStream musicStream = GD.Load<AudioStream>(musicPath);
			audioStreamPlayer.Stream = musicStream;
			audioStreamPlayer.Play();
		}
	}
}
