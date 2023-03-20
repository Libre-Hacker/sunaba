using Godot;
using Sunaba.Runtime;
using System;
using MoonSharp.Interpreter;

public partial class Console : Node
{
	//public Node console;

	[Export]
	public Window window;
	[Export]
	public RichTextLabel output;
    [Export]
    public LineEdit lineEdit;

    public MoonSharp.Interpreter.Script script = new MoonSharp.Interpreter.Script();
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
        //console = GetNode("/root/Console");
        window.Hide();
        //script.Globals["Mul"] = (Func<int, int, int>)Mul;
        script.Globals["print"] = new Action<String>(Print);

        script.DoString("print('Hi')");
        script.DoString("print('')");
    }

    public override void _Process(double delta)
    {
        if (Input.IsActionJustPressed("console"))
        {
            if (window.Visible)
            {
                window.Hide();
            }
            else
            {
                window.PopupCentered();
            }
        }
        ThemeManager themeManager = GetNode<ThemeManager>("/root/ThemeManager/");
        window.Theme = themeManager.theme;
    }

    public void Print(String msg)
	{
        //if (console != null)
        //{
        //console.Call("notify", msg);
        //}
        output.AddText(msg);
        output.Newline();
        GD.Print(msg);
    }

	public void Register(String name, Node node)
	{
        /*if (console != null)
		{
			console.Call("register_env", name, node);
		}*/

        //script.Globals["obj"] = new MyClass();
        script.Globals[name] = node;

    }

    public void OnWindowCloseRequested()
    {
        window.Hide();
    }

    public void OnTextSubmitted(String msg)
    {
        script.DoString(msg);
        lineEdit.Clear();
    }
}
