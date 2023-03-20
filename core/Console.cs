using Godot;
using System;

public partial class Console : Node
{
    public Node console;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        console = GetNode("/root/Console");
    }

    public void Print(String msg)
    {
        console.Call("notify", msg);
        GD.Print(msg);
    }

    public void Register(String name, Node node)
    {
        console.Call("register_env", name, node);
    }
}