using Godot;

namespace Sunaba.Runtime;

public partial class Widget : Panel
{
    public int width = 640;
    public int height = 480;

    public override void _EnterTree()
    {
        AnchorLeft = 0.0f;
        AnchorRight = 0.0f;
        AnchorTop = 0.0f;
        AnchorBottom = 0.0f;

        OffsetLeft = 0;
        OffsetRight = 0;
        OffsetTop = 0;
        OffsetBottom = 0;
        
        Visible = true;
    }
}