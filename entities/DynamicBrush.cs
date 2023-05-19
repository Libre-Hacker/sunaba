using Godot;
using System;

public partial class DynamicBrush : Node3D
{
	Timer timer;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		timer = new Timer();
		timer.WaitTime = 0.5;
		timer.OneShot = true;
		AddChild(timer);
		timer.Timeout += Awake;
		timer.Start();
	}

	void Awake()
	{
		PrintTree();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
