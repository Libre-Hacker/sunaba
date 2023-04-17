using Godot;
using MoonSharp.Interpreter;
using System;

/*
 *
 * CONGRATULATIONS
 *
 *	(｀・ω・´)
 *
 *	You found the main entrypoint code for this codebase.
 * 
 */

namespace Sunaba.Core
{
	public partial class Main : Node
	{
		public String path;

		public String address = "localhost";

		NetworkManager networkManager;
		World world;
		RichTextLabel chatbox;
		Console console;

		private Global global;
		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
			networkManager = GetNode<NetworkManager>("NetworkManager");
			world = GetNode<World>("World");
			chatbox = GetNode<Control>("UI").GetNode<RichTextLabel>("Chatbox");

			if (OS.GetName() == "Android")
			{
				ProjectSettings.SetSetting("display/window/stretch/scale", 2);
			}
			ThemeManager themeMan = GetNode<ThemeManager>("/root/ThemeManager/");
			GetNode<Control>("UI").Theme = themeMan.theme;
			global = GetNode<Global>("/root/Global/");
			global.gameStarted = false;
			global.gamePaused = false;
			console = GetNode<Console>("/root/PConsole");
			console.Register("Sunaba", this);
			Build build = GetNode<Build>("/root/Build");

			GD.Print("");
			console.Print("Sunaba");
			console.Print("Version " + build.versionNumber);
			console.Print("Compiled on " + build.buildDate);
			console.Print("");
			
			if (!OS.HasFeature("editor"))
			{
				String[] args = OS.GetCmdlineArgs();
				String arg1 = args[0];
				if (arg1.Contains(".map"))
				{
					Play(arg1);
				}
			}
		}

		public void CreateRoom()
		{
			if (path != null)
			{
				networkManager.CreateRoom();
				GetNode<UI>("UI").GetNode<Window>("NewRoomDialog").Hide();
				GetNode<UI>("UI").GetNode<Control>("MainMenu").Hide();

			}
		}

		public void LogToChat(String msg)
		{
			Chat("Room", msg);
		}

		public void Chat(String name, String msg)
		{
			String chatmsg = name + " : " + msg;
			console.Print(chatmsg);
			chatbox.AddText(chatmsg);
			chatbox.Newline();
		}

		public void ImportMap()
		{
			if (path == null)
			{
				LogToChat("No Map File Selected.");
			}
			else
			{
				LogToChat("Importing world from File - " + path);
				world.LoadMapPath(path);
				world.LoadMap(path);
			}
		}

		public void Quit()
		{
			GetTree().Quit();
		}

		public override void _Input(InputEvent @event)
		{
			if ((Input.IsKeyPressed(Key.Ctrl)) && (Input.IsKeyPressed(Key.R)))
			{
				Reload();
			}
			
			if (Input.IsKeyPressed(Key.Ctrl) && Input.IsKeyPressed(Key.Alt) && Input.IsKeyPressed(Key.C))
			{
				UI ui = GetNode<UI>("UI");

				if (ui.Visible)
				{
					ui.Hide();
					global.showUI = false;
				}
				else
				{
					ui.Show();
					global.showUI = true;
				}
			}

			if (Input.IsKeyPressed(Key.F11))
			{
				if (DisplayServer.WindowGetMode() != DisplayServer.WindowMode.Fullscreen)
				{
					DisplayServer.WindowSetMode(DisplayServer.WindowMode.Fullscreen);
				}
				else
				{
					DisplayServer.WindowSetMode(DisplayServer.WindowMode.Windowed);
				}

				
			}
		}

		public void Reload()
		{
			Global global = GetNode<Global>("/root/Global/");
			global.gameStarted = false;
			global.gamePaused = false;
			global.player = null;

			GetTree().ChangeSceneToFile("res://core/Reload.tscn");
		}

		public void Connect()
		{
			networkManager.JoinRoom(address);
			GetNode<UI>("UI").GetNode<Window>("NewRoomDialog").Hide();
			GetNode<UI>("UI").GetNode<Control>("MainMenu").Hide();
		}

		public void OnAddressChanged(String newText)
		{
			if (newText != null)
			{
				address = newText;
			}
		}

		public void Play (String map = null)
		{
			if (!string.IsNullOrEmpty(map))
			{
				path = map;
				CreateRoom();
			}
		}

		public void CheckDir(String dirname)
		{
			DirAccess dir = DirAccess.Open("res://" + dirname);
			dir.ListDirBegin();

			while (true)
			{
				String file = dir.GetNext();
				if (string.IsNullOrEmpty(file))
				{
					break;
				}
				else
				{
					console.Print(file);
				}
			}

			dir.ListDirEnd();
		} 
	}
}

/*

func set_map_file():
	$UI/FileDialog.popup_centered()

func check_dir(dirname : String):
	var dir = DirAccess.open("res://" + dirname)
	
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		else :
			print(file)
			
	dir.list_dir_end()

*/
