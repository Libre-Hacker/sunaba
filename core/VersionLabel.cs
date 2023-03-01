using Godot;
using System;

namespace OpenSBX.Runtime
{
	public partial class VersionLabel : Label
	{
		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
			Text = "v0.4.0dev";
		}
	}
}

/*

*/