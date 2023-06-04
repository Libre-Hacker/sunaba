using Godot;
using System;
using Sunaba.Core;

namespace Sunaba.Entities.Api;

public partial class EntityBehaviour : Node
{
    public Console console;

    public override void _Ready()
    {
        console = GetNode<Console>("/root/PConsole");
        Awake();
    }

    public virtual void Awake()
    {
        
    }
}
