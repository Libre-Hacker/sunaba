using Sunaba.Entities.Api;

namespace Sunaba.Scripts;

public partial class John : NPC
{
    public override void Awake()
    {
        console.Print("Hi, my name is " + this.GetType().Name);
    }
}