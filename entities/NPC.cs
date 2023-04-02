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

        public override void _Ready()
        {
            console = GetNode<Console>("/root/PConsole");

            npcScript = properties.GetValueOrDefault("script").ToString();

            if (npcScript == null) return;

            //String scriptPath = "res://Scripts/" + npcScript + ".lua";

            
            script.Globals["print"] = (Print);
            script.DoString(npcScript);
            script.Call(script.Globals["start"]);
        }

        public override void _Process(double delta)
        {
            if (npcScript == null) return;
            script.Call(script.Globals["update"]);
        }

        public override void _PhysicsProcess(double delta)
        {
            if (npcScript == null) return;
            script.Call(script.Globals["physicsUpdate"]);
        }

        void Print(String _string)
        {
            console.Print(_string);
        }
    }
}
