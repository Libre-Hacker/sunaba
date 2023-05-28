using Godot;
using System;
using Sunaba.Core;

namespace Sunaba.Runtime;

public partial class App : Node
{
	private Theme theme;
	private Control mainWindow;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		String[] args = OS.GetCmdlineArgs();
		
		ChangeTheme(GD.Load<Theme>("res://themes/Default.tres"));
		mainWindow = GetNode<Control>("MainWindow");
		mainWindow.Theme = theme;

		if (args.IsEmpty())
		{
			RunPlayer(mainWindow);
		}
		else
		{
			foreach (String arg in args)
			{
				if (arg.Contains("--settings"))
				{
					RunSettings(mainWindow);
				}
				else
				{
					RunPlayer(mainWindow);
				}
			}
		}
		
	}
	
	public void ChangeTheme(Theme _theme)
	{
		theme = _theme;
		var themeManager = GetNode<ThemeManager>("/root/ThemeManager");
		themeManager.theme = _theme;
	}
	
	void RunPlayer(Node node)
	{
		PackedScene packedScene = GD.Load<PackedScene>("res://Runtime/Player.tscn");
		Control control = packedScene.Instantiate<Control>();
		node.AddChild(control);
	}

	void RunLauncher(Node node)
	{
		PackedScene packedScene = GD.Load<PackedScene>("res://Runtime/Launcher.tscn");
		Launcher launcher = packedScene.Instantiate<Launcher>();
		node.AddChild(launcher);
	}
	
	void RunSettings(Node node)
	{
		PackedScene packedScene = GD.Load<PackedScene>("res://Runtime/Settings.tscn");
		Control control = packedScene.Instantiate<Control>();
		node.AddChild(control);
	}
}
