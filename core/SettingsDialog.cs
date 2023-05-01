using Godot;
using System;

namespace Sunaba.Core
{
	public partial class SettingsDialog : Window
	{
		[Export]
		public UI ui;

		private OptionButton themeDropdown;

        // Called when the node enters the scene tree for the first time.
        public override void _Ready()
		{
			themeDropdown = 
				GetNode<Control>("Control")
				.GetNode<TabBar>("TabBar")
				.GetNode<TabContainer>("TabContainer")
				.GetNode<Control>("UI")
				.GetNode<VBoxContainer>("VBoxContainer")
				.GetNode<Label>("Label2")
				.GetNode<OptionButton>("ThemingOptionButton");


            DirAccess dir = DirAccess.Open("res://themes");

            dir.ListDirBegin();

            while (true)
            {
                String file = dir.GetNext();
                if (string.IsNullOrEmpty(file))
                {
                    break;
                }
                else if ((!file.EndsWith(".import")) && (file.EndsWith(".tres")) && (file != "Default.tres"))
                {
                    var themeName = file.GetBaseName();
                   themeDropdown.AddItem(themeName);
                }
                else if ((file.EndsWith(".tres.remap")) && (file != "Default.tres.remap"))
                {
                    var themeName = file.GetBaseName();
                    themeDropdown.AddItem(themeName);
                }
            }

            dir.ListDirEnd();
			ChangeTheme(GD.Load<Theme>("res://themes/Default.tres"));
        }

        public override void _Input(InputEvent @event)
        {
            if (Input.IsKeyPressed(Key.F11))
			{
				int fullscreen = ProjectSettings.GetSetting("display/window/size/mode").AsInt32();

				if (fullscreen != 4)
				{
					ProjectSettings.SetSetting("display/window/size/mode", 4);
				}
				else
				{
                    ProjectSettings.SetSetting("display/window/size/mode", 0);
                }
			}
        }

		public void ChangeTheme(Theme theme)
		{
			Theme = theme;
			var themeManager = GetNode<ThemeManager>("/root/ThemeManager");
			if (ui != null)
			{
				ui.Theme = theme;
			}
			themeManager.theme = theme;
		}

		public void OnModelSelected(int index)
		{
			Global global = GetNode<Global>("/root/Global");
			if (index == 0)
			{
				global.playerModel = "custom";
			}
			else if (index == 1)
            {
                global.playerModel = "male";
            }
            else if (index == 2)
            {
                global.playerModel = "female";
            }
        }

		public void OnThemeSelected(int index)
		{
			var themeManager = GetNode<ThemeManager>("/root/ThemeManager");
			themeManager.themeName = themeDropdown.GetItemText(index);
			String themePath = "res://themes/" + themeDropdown.GetItemText(index) + ".tres";
			Godot.Theme theme = GD.Load<Theme>(themePath);
			ChangeTheme(theme);
		}


		public void OnCloseRequested()
		{
			Hide();
		}
    }
}
