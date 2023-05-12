using Godot;
using System;

namespace Sunaba.Core
{
	public partial class BackgroundMusic : AudioStreamPlayer
	{
		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
			Finished += () => { Play(); };
		}
	}
}
