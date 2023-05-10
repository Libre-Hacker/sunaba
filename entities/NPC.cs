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
			
			if (properties.ContainsKey("angle"))
			{
				String angleString = "-" + properties.GetValueOrDefault("angle").ToString();
				float angle = angleString.ToFloat();
				Print(angle.ToString());

				
				Vector3 rotation = GlobalRotation;
				rotation.Y = angle;
				GlobalRotation = rotation;
				Print(GlobalRotation.Y.ToString());
			}
			
			if (properties.ContainsKey("script"))
			{
				npcScript = properties.GetValueOrDefault("script").ToString();

				if (npcScript == null) return;

				String scriptPath = "res://Scripts/" + npcScript;

				if (!FileAccess.FileExists(scriptPath))
				{
					scriptPath = "user://Scripts/" + npcScript;
					if (!FileAccess.FileExists(scriptPath))
					{
						console.Print("Error: Script not found");
						return;
					}
				}

				if (npcScript.Contains(".lua"))
				{
					FileAccess luaScript = FileAccess.Open(scriptPath, FileAccess.ModeFlags.Read);
					Print(scriptPath);
					Print(luaScript.GetAsText());
					script.Globals["print"] = (Print);
					script.Globals["setYPosition"] = (SetYPosition);
					script.DoString(luaScript.GetAsText());
					script.Call(script.Globals["start"]);
				}

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

		void SetYPosition(double yPos)
		{
			Vector3 rotation = GlobalRotation;
			rotation.Y = (float)yPos;
			GlobalRotation = rotation;
		}

		void Print(String _string)
		{
			console.Print(_string);
		}
	}
}
