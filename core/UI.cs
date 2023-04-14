using Godot;
using System;

namespace Sunaba.Core
{
	public partial class UI : Control
	{
		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
			GetNode<Control>("MainMenu").Show();
			GetNode<Panel>("PauseMenu").Hide();
			
			GetNode<AcceptDialog>("AcceptDialog2").PopupCentered();
		}
        

		public void OnCreateButtonPressed()
		{
			GetNode<Window>("NewRoomDialog").PopupCentered();
		}


		public void OnSettingsButtonPressed()
		{
            GetNode<Window>("SettingsDialog").PopupCentered();
        }

        public void OnFileButtonPressed()
        {
            GetNode<FileDialog>("UserFileDialog").PopupCentered();
            //GetNode<Node>("NativeDialogManager").Call("show_native_file_dialog");
        }

		public void OnFileMenuPressed(int id)
		{
			if (id == 0)
			{
                GetNode<Window>("MapDialog").PopupCentered();
            }
			else if (id == 1)
            {
                GetNode<FileDialog>("UserFileDialog").PopupCentered();
            }
        }
		public void OnFileSelected(String path)
		{
			Main parent = GetParent<Main>();
			parent.path = path;
			GetNode<Window>("NewRoomDialog").GetNode<NewRoom>("NewRoom").GetNode<LineEdit>("MapPath").Text = path;
		}

		public void OnConnectButtonPressed()
		{
            Build build = GetNode<Build>("/root/Build");
			Settings settings = GetNode<Settings>("/root/Settings");

			if (settings.multiplayerEnabled == true)
			{
				GetNode<Window>("ConnectDialog").PopupCentered();
			}
			else
			{
				GetNode<AcceptDialog>("AcceptDialog1").PopupCentered();
			}
		}

		public void OnConnectDialogCloseRequested()
		{
			GetNode<Window>("ConnectDialog").Hide();
		}

		public void OnMapDialogCloseRequested()
		{
            GetNode<Window>("MapDialog").Hide();
        }

		public void Unpause()
		{
            var global = GetNode("/root/Global");
			GetNode<Panel>("PauseMenu").Hide();
			Input.MouseMode = Input.MouseModeEnum.Captured;
			global.Set("gamePaused", false);
        }

		public void OnMapSelected()
		{
			String map = GetNode<Window>("MapDialog").GetNode<MapPicker>("StandardMapPicker").GetNode<OptionButton>("OptionButton").Text + ".map";
			String mapPath = "res://maps/" + map;

			GetNode<Window>("MapDialog").Hide();
			OnFileSelected(mapPath);
		}

        public void OnNewRoomDialogCloseRequested()
		{
			GetNode<Window>("NewRoomDialog").Hide();
		}
		public void OnCustomizeButtonPressed()
		{
			GetNode<Window>("CharacterWindow").PopupCentered();
		}

		public void OnCharacterWindowCloseRequested()
		{
            GetNode<Window>("CharacterWindow").Hide();
        }

        // Called every frame. 'delta' is the elapsed time since the previous frame.
        public override void _Process(double delta)
		{
            var global = GetNode("/root/Global");
			var gameStarted = global.Get("gameStarted");
            var gamePaused = global.Get("gamePaused");
			


			if (gameStarted.AsBool() == true)
			{
                if (gamePaused.AsBool() == true)
                {
					GetNode<Panel>("PauseMenu").Show();
                }
				else
				{
                    GetNode<Panel>("PauseMenu").Hide();
                }
            }
        }
	}
}
