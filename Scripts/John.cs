using Sunaba.Entities.Api;

namespace Sunaba.Scripts;

public partial class John : NpcBehaviour
{
    public override void Awake()
    {
        console.Print("Hi, my name is " + this.GetType().Name);
    }
}