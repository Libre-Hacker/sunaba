using Godot;
using System;

namespace Toonbox.Runtime
{
	public partial class UI : Control
	{
		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
			GetNode<Control>("MainMenu").Show();
			GetNode<Panel>("PauseMenu").Hide();
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
            GetNode<Window>("MapDialog").PopupCentered();
        }

		public void OnFileMenuPressed(int id)
		{
			if (id == 0)
			{
                GetNode<Window>("MapDialog").PopupCentered();
            }
			else if (id == 1)
            {
                GetNode<Window>("UserFileDialog").PopupCentered();
            }
        }
		public void OnFileSelected(String path)
		{
			var parent = GetParent<Node>();
			parent.Set("path", path);
			GetNode<Window>("NewRoomDialog").GetNode<NewRoom>("NewRoom").GetNode<LineEdit>("MapPath").Text = path;
		}

		public void OnConnectButtonPressed()
		{
			GetNode<Window>("ConnectDialog").PopupCentered();
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
			String map = GetNode<Window>("MapDialog").GetNode<Panel>("StandardMapPicker").GetNode<OptionButton>("OptionButton").Text + ".map";
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
