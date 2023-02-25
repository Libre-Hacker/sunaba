using Godot;
using System;

public partial class toolObject : RigidBody3D
{
	[Export]
	public String weaponPath = "";

	public bool dropped = false;

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (dropped == true)
		{
			ApplyImpulse(-Transform.Basis.Z * 10, Transform.Basis.Z);
			dropped = false;
		}
	}


}
