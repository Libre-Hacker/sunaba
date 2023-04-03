using Godot;
using Godot.Collections;
using System;
using System.Collections.Generic;
using MoonSharp.Interpreter;
using Script = MoonSharp.Interpreter.Script;

namespace Sunaba.Entities
{
	public partial class NPC : CharacterBody3D
	{
		Console console;

		[Export]
		public Dictionary properties;

		//[Export]
		private String npcScript = "";

		Script script = new Script();

		Timer timer;
		
		bool canExecute = false;

		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
			timer = new Timer();
			timer.WaitTime = 0.5;
			timer.OneShot = true;
			AddChild(timer);
			timer.Timeout += Start;
			timer.Start();
		}

		public void Start()
		{
			console = GetNode<Console>("/root/PConsole");

			timer.QueueFree();

			if (properties.ContainsKey("script"))
			{
				npcScript = properties.GetValueOrDefault("script").ToString();

				if (npcScript == null) return;

				
				//String scriptPath = "res://Scripts/" + npcScript + ".lua";

				script.Globals["print"] = (Print);
				script.DoString(npcScript);
				script.Call(script.Globals["start"]);
				canExecute = true;
			}
		}

		public override void _Process(double delta)
		{
			if (canExecute == false) return;
			
				script.Call(script.Globals["update"]);
		}

		public override void _PhysicsProcess(double delta)
		{
			if (canExecute == false) return;
			
			script.Call(script.Globals["physicsUpdate"]);
		}

		void Print(String _string)
		{
			console.Print(_string);
		}
	}
}
