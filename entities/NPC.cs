using Godot;
using System;
using MoonSharp.Interpreter;
using Script = MoonSharp.Interpreter.Script;

namespace Sunaba.Entities
{
    public partial class NPC : CharacterBody3D
    {
        Console console;

        [Export]
        public String npcScript = "";

        Script script = new Script();

        public override void _Ready()
        {
            console = GetNode<Console>("/root/PConsole");

            String scriptPath = "res://Scripts/" + npcScript + ".lua";

            script.DoFile(scriptPath);
            script.Call(script.Globals["start"]);
        }

        public override void _Process(double delta)
        {
            script.Call(script.Globals["update"]);
        }

        public override void _PhysicsProcess(double delta)
        {
            script.Call(script.Globals["physicsUpdate"]);
        }
    }
}
