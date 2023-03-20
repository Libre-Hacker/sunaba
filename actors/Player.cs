using Godot;
using Godot.Collections;
using System;
using Sunaba.Runtime;
using Sunaba.Tools;

namespace Sunaba.Actors
{
	public partial class Player : CharacterBody3D
	{
		[Export]
		public int defaultSpeed = 5;
		[Export]
		public int sprintSpeed = 10;
		[Export]
		public int crouchMoveSpeed = 2;
		[Export]
		public int crouchSpeed = 20;
		[Export]
		public int acceleration = 60;
		[Export]
		public int friction = 50;
		[Export]
		public int airFricttion = 10;
		[Export]
		public int jumpImpulse = 20;
		[Export]
		public int gravity = -40;
		[Export]
		public double defaultWalkSoundTime = 0.35;
		[Export]
		public double sprintWalkSoundTime = 0.35;
		[Export]
		public float mouseSensitivity = 1;
		[Export]
		public int controllerSensitivity = 25;

		private Vector3 vel = Vector3.Zero;

		[Export]
		public Array<AudioStreamOggVorbis> footSounds;

		private Vector3 snapVector = Vector3.Zero;

		private int currentTool = 0;
		private String tool1;
		private String tool2;
		private String tool3;
		private String tool4;
		private String toolToSpawn;
		private String toolToDrop;

		private double defaultHeight = 1.497;
		private double crouchHeight = 0.8;
		private double headHeight = 1.111;
		private double headCrouchHeight = 0.866;
		private int speed = 5;
		private int health = 100;
		private RayCast3D reach;
		private RayCast3D aimcast;
		private int ammo = 25;
		private int maxAmmo = 25;
		private int damage = 100;
		private int spread = 25;
		private bool isReloading;
		private bool hasFired = false;
		private String toolType = "Semi";
		private Node3D muzzle;
		private bool canPlayWalkSound = true;
		private int timesJumped = 0;
		private int sway = 50;
		private int vSway = 45;
		private bool viewMode = false;

		private String playerModel = "custom";

		[Export]
		public Node3D head;
		[Export]
		public Camera3D fpCamera;
		[Export]
		public Camera3D tpCamera;
        [Export]
        public PlayerModel model;
        [Export]
		public Node3D headPos;
		[Export]
		public Node3D akari;
		[Export]
		public CollisionShape3D collisionShape;
		[Export]
		public AnimationPlayer animationPlayer;
		[Export]
		public AnimationPlayer gunAnimationPlayer;
		[Export]
		public Node3D handLoc;
		[Export]
		public Node3D hand;
		[Export]
		public RayCast3D fpReach;
		[Export]
		public RayCast3D tpReach;
        [Export]
        public RayCast3D fpSwordRange;
        [Export]
        public RayCast3D tpSwordRange;
        [Export]
		public RayCast3D fpAimCast;
		[Export]
		public RayCast3D tpAimCast;
		[Export]
		public Node3D fpRayContainer;
		[Export]
		public Node3D tpRayContainer;
		[Export]
		public Timer walkTimer;
		[Export]
		public Timer fireTimer;
		[Export]
		public Timer reloadTimer;
		[Export]
		public AudioStreamPlayer3D walkSound;
		[Export]
		public AudioStreamPlayer3D runSound;
		[Export]
		public AudioStreamPlayer3D reloadSound;
		[Export]
		public AudioStreamPlayer3D pickupSound;
		[Export]
		public AudioStreamPlayer3D jumpSound;

		// HUD Related Nodes
		[Export]
		public TextureRect crosshair;
		[Export]
		public Label reloadLabel;
		[Export]
		public Panel toolPanel;
		[Export]
		public Label toolLabel;
		[Export]
		public ProgressBar toolAmmoBar;
		[Export]
		public Label toolAmmoCounter;
		[Export]
		public Panel playerPanel;
		[Export]
		public Label playerName;
		[Export]
		public ProgressBar healthBar;
		[Export]
		public Label healthCounter;
		[Export]
		public TextureRect sprintingIcon;
		[Export]
		public Window sbMenuWindow;
		[Export]
		public SBMenu sbMenu;
		[Export]
		public Tree toolTree;

		private Global global;

		public override void _EnterTree()
		{
			global = GetNode<Global>("/root/Global/");
			if (global.isNetworkedGame)
			{
				int playerId = Name.ToString().ToInt();
				SetMultiplayerAuthority(playerId);
			}
		}

		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
			if (IsMultiplayerAuthority() || !global.isNetworkedGame)
			{
				Input.MouseMode = Input.MouseModeEnum.Captured;
				reach = fpReach;
				aimcast = fpAimCast;
				if (Name.ToString() == Multiplayer.GetUniqueId().ToString())
				{
					playerName.Text = "Player " + Name.ToString();
				}
				crosshair.Show();
				playerPanel.Show();
				toolPanel.Show();

                Console console = GetNode<Console>("/root/Console");
                console.Register(Name, this);
            }
			fpCamera.Current = IsMultiplayerAuthority();
			tpCamera.Current = false;
			//GetParent<World>().GetNode<Area3D>("OutOfBounds").BodyEntered += OutOfBounds;
            
			reloadLabel.Hide();
			toolPanel.Hide();
			speed = defaultSpeed;
		}

		public override void _Input(InputEvent @event)
		{
			if (!IsMultiplayerAuthority() && global.isNetworkedGame) return;

			if (Input.IsActionJustPressed("pause"))
			{
				if (Input.MouseMode == Input.MouseModeEnum.Captured)
				{
					Input.MouseMode = Input.MouseModeEnum.Visible;
					crosshair.Hide();
					global.gamePaused = true;
				}
				else
				{
					Input.MouseMode = Input.MouseModeEnum.Captured;
					crosshair.Show();
					global.gamePaused = false;
				}
			}

			if (Input.IsActionJustPressed("view") && tpCamera.Current == true)
			{
				if (!viewMode)
				{
					viewMode = true;
				}
				else
				{
					viewMode = false;
					head.GlobalRotation = Vector3.Zero;
				}
			}

			if ((@event is InputEventMouseMotion motion) && (Input.MouseMode == Input.MouseModeEnum.Captured))
			{
				if (!viewMode)
				{
					Vector2 mouseAxis = motion.Relative;
					Vector3 newRotation = Rotation;
					newRotation.Y -= mouseAxis.X * mouseSensitivity * (float).001;
					Rotation = newRotation;
					Vector3 newHeadRotation = head.Rotation;
					newHeadRotation.X = Mathf.Clamp(newHeadRotation.X - mouseAxis.Y * mouseSensitivity * (float).001, (float)-1.5, (float)1.5);
					head.Rotation = newHeadRotation;
				}
				else
				{
					Vector2 mouseAxis = motion.Relative;
					Vector3 newHeadRotation = head.Rotation;
					newHeadRotation.Y -= mouseAxis.X * mouseSensitivity * (float).001;
					newHeadRotation.X = Mathf.Clamp(newHeadRotation.X - mouseAxis.Y * mouseSensitivity * (float).001, (float)-1.5, (float)1.5);
					head.Rotation = newHeadRotation;
				}
			}

			if (Input.IsActionJustPressed("camera_toggle"))
			{
				if (fpCamera.Current == true)
				{
					fpCamera.Current = false;
					tpCamera.Current = true;
					reach = tpReach;
					aimcast = tpAimCast;
				}
				else if (tpCamera.Current == true)
				{
					fpCamera.Current = true;
					tpCamera.Current = false;
					reach = fpReach;
					aimcast = fpAimCast;
				}
			}

			if (Input.IsActionJustPressed("interact"))
			{
				if (toolToSpawn == null)
				{
					AddTool(toolToSpawn);
					toolToSpawn = null;
					GodotObject collider = reach.GetCollider();
					if (collider != null)
					{
						if (collider is Node3D node3D)
						{
							node3D.QueueFree();
						}
					}
				}
			}

			if (Input.IsActionJustPressed("hands"))
			{
				if (hand.GetChildCount() > 0)
				{
					if (head.GetChild(0) != null)
					{
						head.GetChild(0).QueueFree();
						if (IsMultiplayerAuthority() || !global.isNetworkedGame)
						{
							toolPanel.Hide();
						}
						pickupSound.Play();
						ammo = 1;
						maxAmmo = 1;
						damage = 0;
						toolType = "";
						currentTool = 0;
					}
				}
			}
			else if (Input.IsActionJustPressed("tool1") && tool1 != null)
			{
				Equip(tool1);
				currentTool = 1;
			}
			else if (Input.IsActionJustPressed("tool2") && tool2 != null)
			{
				Equip(tool2);
				currentTool = 2;
			}
			else if (Input.IsActionJustPressed("tool3") && tool3 != null)
			{
				Equip(tool3);
				currentTool = 3;
			}
			else if (Input.IsActionJustPressed("tool4") && tool4 != null)
			{
				Equip(tool4);
				currentTool = 4;
			}

			if ((Input.IsActionJustPressed("reload") && ammo < maxAmmo) || ammo == 0)
			{
				if (isReloading) return;
				isReloading = true;
				reloadSound.Play();
				reloadTimer.Start();
				reloadLabel.Show();
				gunAnimationPlayer.Play("reload");
			}
		}

		private void Equip(String t)
		{
			PackedScene toolToLoad = GD.Load<PackedScene>(t);
			Tool tool2Spawn = toolToLoad.Instantiate<Tool>();
			if (hand.GetChildCount() > 0)
			{
				if (head.GetChild(0) != null) head.GetChild(0).QueueFree();
			}
			toolLabel.Text = tool2Spawn.Name;
			hand.AddChild(tool2Spawn);
			ammo = tool2Spawn.maxAmmo;
			maxAmmo = tool2Spawn.maxAmmo;
			speed = tool2Spawn.spread;
			GD.Randomize();
			fireTimer.WaitTime = tool2Spawn.cooldownTime;
			damage = tool2Spawn.damage;
			toolType = tool2Spawn.toolType;
			tool2Spawn.Rotation = handLoc.Rotation;
			if (tool2Spawn.showCounter == true)
			{
				toolAmmoBar.Show();
			}
			else if (tool2Spawn.showCounter == false)
			{
				toolAmmoBar.Hide();
			}
			if (IsMultiplayerAuthority() || !global.isNetworkedGame) toolPanel.Show();
			pickupSound.Play();
		}

		// Called every frame. 'delta' is the elapsed time since the previous frame.
		public override void _Process(double delta)
		{
			if (IsMultiplayerAuthority() || !global.isNetworkedGame)
			{
				if (Input.MouseMode == Input.MouseModeEnum.Captured)
				{
					crosshair.Show();
				}
				else
				{
					crosshair.Hide();
				}
			}
			if (tpCamera.Current == true)
			{
				model.Visible = true;
			}
			else if (fpCamera.Current == true && IsMultiplayerAuthority())
			{
				model.Visible = false;
            }
		}

		public override void _PhysicsProcess(double delta)
		{
			if (!viewMode)
			{
				head.GlobalPosition = headPos.GlobalPosition;
				Vector3 headRotation = head.GlobalRotation;
				headRotation.Y = headPos.GlobalRotation.Y;
				headRotation.Z = headPos.GlobalRotation.Z;
			}

			if (((Velocity.Length() == 0) || (vel.Length() == 0)) && !Input.IsActionPressed("crouch"))
			{
				animationPlayer.Play("Locomotion-Library/idle1");
				Vector3 modelPosition = model.Position;
				modelPosition.Y = 0;
				model.Position = modelPosition;
				akari.Position = Vector3.Zero;
				akari.Rotation = Vector3.Zero;
				if (!isReloading && gunAnimationPlayer.CurrentAnimation == "fire") gunAnimationPlayer.Play("idle");
			}
			/*else if (((Velocity.Length() == 0) || (vel.Length() == 0)) && Input.IsActionPressed("crouch"))
			{
				animationPlayer.Play("crouch_library/crouch_idle");
				Vector3 modelPosition = model.Position;
				modelPosition.Y = (float)0.175;
				model.Position = modelPosition;
				if (!isReloading && gunAnimationPlayer.CurrentAnimation == "fire") gunAnimationPlayer.Play("idle");
			}*/
			else
			{
				if (speed == defaultSpeed && IsOnFloor())
				{
					animationPlayer.Play("Locomotion-Library/walk");
					Vector3 modelPosition = model.Position;
					modelPosition.Y = 0;
					model.Position = modelPosition;
					akari.Position = Vector3.Zero;
					akari.Rotation = Vector3.Zero;
					if (canPlayWalkSound)
					{
						walkSound.Stream = footSounds.PickRandom();
						walkSound.Play();
						walkTimer.Start();
						canPlayWalkSound = false;
					}
					if (!isReloading && gunAnimationPlayer.CurrentAnimation == "fire") gunAnimationPlayer.Play("idle");
				}
				/*else if (speed == crouchMoveSpeed && IsOnFloor())
                {
                    animationPlayer.Play("crouch_library/crouch_walk");
                    Vector3 modelPosition = model.Position;
                    modelPosition.Y = (float)0.175;
                    model.Position = modelPosition;
                    akari.Position = Vector3.Zero;
                    akari.Rotation = Vector3.Zero;
                    if (canPlayWalkSound)
                    {
                        walkSound.Stream = footSounds.PickRandom();
                        walkSound.Play();
                        walkTimer.Start();
                        canPlayWalkSound = false;
                    }
                    if (!isReloading && gunAnimationPlayer.CurrentAnimation == "fire") gunAnimationPlayer.Play("idle");
                }*/
				else if (speed == sprintSpeed && IsOnFloor())
                {
                    animationPlayer.Play("Locomotion-Library/run");
                    Vector3 modelPosition = model.Position;
                    modelPosition.Y = 0;
                    model.Position = modelPosition;
                    akari.Position = Vector3.Zero;
                    akari.Rotation = Vector3.Zero;
                    if (canPlayWalkSound)
                    {
                        walkSound.Stream = footSounds.PickRandom();
                        walkSound.Play();
                        walkTimer.Start();
                        canPlayWalkSound = false;
                    }
                    if (!isReloading && gunAnimationPlayer.CurrentAnimation == "fire") gunAnimationPlayer.Play("idle_2");
                }
				else if (!IsOnFloor())
				{
					animationPlayer.Play("Locomotion-Library/jump");
                    Vector3 modelPosition = model.Position;
                    modelPosition.Y = 0;
                    model.Position = modelPosition;
                    akari.Position = Vector3.Zero;
                    akari.Rotation = Vector3.Zero;
                    if (!isReloading && gunAnimationPlayer.CurrentAnimation == "fire") gunAnimationPlayer.Play("idle");
                }
            }

			if (IsMultiplayerAuthority() || !global.isNetworkedGame)
			{
				speed = defaultSpeed;
				walkTimer.WaitTime = defaultWalkSoundTime;
				Vector3 InputVector = GetInputVector();
				Vector3 Direction = GetDirection(InputVector);
				Jump();
				vel = Velocity;

				healthBar.Value = health;

				ThemeManager themeManager = GetNode<ThemeManager>("/root/ThemeManager");
				playerPanel.Theme = themeManager.theme;
				toolPanel.Theme = themeManager.theme;
				crosshair.Theme = themeManager.theme;
				sbMenuWindow.Theme = themeManager.theme;
				toolAmmoCounter.Text = ammo.ToString() + "/" + maxAmmo.ToString();
				toolAmmoBar.Value = ammo;
				toolAmmoBar.MaxValue = maxAmmo;

				sprintingIcon.Hide();
                
				/*
				if (Input.IsActionPressed("sprint"))
				{
					speed = sprintSpeed;
					walkTimer.WaitTime = sprintWalkSoundTime;
					sprintingIcon.Show();
				}

				if (Input.IsActionPressed("crouch"))
				{
					Shape3D shape3D = collisionShape.Shape;
					if (shape3D is CapsuleShape3D capsule)
					{
						capsule.Height = (float)crouchHeight;
					}

					speed = crouchMoveSpeed;
					walkTimer.WaitTime = (float)0.8;
                    Vector3 modelPosition = model.Position;
                    modelPosition.Y = (float)0.175;
                    model.Position = modelPosition;
                }
				else
                {*/
				Shape3D shape3D = collisionShape.Shape;
				if (shape3D is CapsuleShape3D capsule)
				{
					capsule.Height = (float)defaultHeight;
				}
				Vector3 modelPosition = model.Position;
				modelPosition.Y = 0;
				model.Position = modelPosition;
                //}
				

				ApplyMovement(Direction, delta);
				ApplyGravity(delta);
				ApplyFriction(Direction, delta);
				//ApplyControllerRotation();

				UpDirection = Vector3.Up;
				FloorStopOnSlope = true;
                MaxSlides = 4;
				FloorMaxAngle = (float).7853;
				MoveAndSlide();
				vel = Velocity;
            }

			if (IsOnFloor())
			{
				timesJumped = 0;
			}

			hand.GlobalPosition = handLoc.GlobalPosition;
			hand.GlobalRotation = handLoc.GlobalRotation;
			reloadSound.GlobalPosition = handLoc.GlobalPosition;
			pickupSound.GlobalPosition = handLoc.GlobalPosition;

			if ((!IsMultiplayerAuthority() && global.isNetworkedGame) || Input.MouseMode == Input.MouseModeEnum.Visible) return;
			
			if (!global.gamePaused)
			{
				Input.MouseMode = Input.MouseModeEnum.Captured;
				crosshair.Show();
			}

			/*if (reach.IsColliding())
			{
				if (reach.GetCollider() is ToolObject toolObject)
				{
					String name = toolObject.Name.ToString();
					toolToSpawn = toolObject.toolPath;
				}
				else
				{
					toolToSpawn = null;
				}
			}
			else
			{
                toolToSpawn = null;
            }*/

			if (toolType == "Semi")
			{
				if (Input.IsActionJustPressed("action_button"))
				{
					if (hand.GetChildCount() > 0)
					{
						if (hand.GetChild(0) != null)
						{
							if (!hasFired)
							{
								Fire();
							}
						}
					}
				}
				else if (Input.IsActionJustReleased("action_button"))
				{
					hasFired = false;
				}
			}
			else if (toolType == "Auto")
            {
                if (Input.IsActionPressed("action_button"))
                {
                    if (hand.GetChildCount() > 0)
                    {
                        if (hand.GetChild(0) != null)
                        {
                            if (!hasFired)
                            {
                                Fire();
                            }
                        }
                    }
                }
            }
            else if (toolType == "Shotgun")
            {
                if (Input.IsActionJustPressed("action_button"))
                {
                    if (hand.GetChildCount() > 0)
                    {
                        if (hand.GetChild(0) != null)
                        {
                            if (!hasFired)
                            {
								FireShotgun();
                            }
                        }
                    }
                }
                else if (Input.IsActionJustReleased("action_button"))
                {
                    hasFired = false;
                }
            }
			else if (toolType == "Spray")
            {
                if (Input.IsActionPressed("action_button"))
                {
                    if (hand.GetChildCount() > 0)
                    {
                        if (hand.GetChild(0) != null)
                        {
                            if (!hasFired)
                            {
                                Spray();
                            }
                        }
                    }
                }
            }
			else if (toolType == "Melee")
            {
                if (Input.IsActionJustPressed("action_button"))
                {
                    if (hand.GetChildCount() > 0)
                    {
                        if (hand.GetChild(0) != null)
                        {
                            if (!hasFired)
                            {
                                Swing();
                            }
                        }
                    }
                }
                else if (Input.IsActionJustReleased("action_button"))
                {
                    hasFired = false;
                }
            }

            if (global.gameMode == "Sandbox")
			{
				if (Input.IsActionJustReleased("menu2") && !sbMenuWindow.Visible)
				{
					sbMenuWindow.PopupCentered();
					Input.MouseMode = Input.MouseModeEnum.Visible;
				}
				else if (Input.IsActionJustReleased("menu2") && sbMenuWindow.Visible)
				{
					HideSBMenu();
				}

            }
        }
		private void HideSBMenu()
		{
			sbMenuWindow.Hide();
			Input.MouseMode = Input.MouseModeEnum.Captured;
		}

		private Vector3 GetInputVector()
		{
			Vector3 InputVector = Vector3.Zero;
			InputVector.X = Input.GetActionStrength("move_right") - Input.GetActionStrength("move_left");
			InputVector.Z = Input.GetActionStrength("move_backward") - Input.GetActionStrength("move_forward");
			if (InputVector.Length() > 1)
			{
				return InputVector;
			}
			else
			{
				return InputVector;
			}
		}

		private Vector3 GetDirection(Vector3 InputVector)
		{
			Vector3 direction = Vector3.Zero;
			direction = (InputVector.X * Transform.Basis.X) + (InputVector.Z * Transform.Basis.Z);
			return direction;
		}

		private void ApplyMovement(Vector3 direction, double delta)
		{
			if (direction != Vector3.Zero)
			{
				Vector3 velocity = Velocity;
				velocity.X = velocity.MoveToward(direction * speed, acceleration * (float)delta).X;
				velocity.Z = velocity.MoveToward(direction * speed, acceleration * (float)delta).Z;
				Velocity = velocity;
			}
		}

		private void ApplyFriction(Vector3 direction, double delta)
		{
			if (direction == Vector3.Zero)
			{
				Vector3 velocity = Velocity;
				if (IsOnFloor()) velocity = velocity.MoveToward(Vector3.Zero, friction * (float)delta);
				else
				{
					velocity.X = velocity.MoveToward(direction * speed, airFricttion * (float)delta).X;
					velocity.Z = velocity.MoveToward(direction * speed, airFricttion * (float)delta).Z;
				}
				Velocity = velocity;
			}
		}

		private void ApplyGravity(double delta)
		{
			Vector3 velocity = Velocity;
			velocity.Y += gravity * (float)delta;
			velocity.Y = Mathf.Clamp(velocity.Y, gravity, jumpImpulse);
			Velocity = velocity;
		}

		private void UpdateSnapVector()
		{
			if (!IsOnFloor())
			{
				snapVector = GetFloorNormal();
			}
			else
			{
				snapVector = Vector3.Down;
			}
		}

		private void Jump()
		{
			if ((Input.IsActionJustPressed("jump") && IsOnFloor()) || (Input.IsActionJustPressed("jump") && timesJumped == 1))
			{
				jumpSound.Play();
				snapVector = Vector3.Zero;
				Vector3 velocity = Velocity;
				velocity.Y = jumpImpulse;
				Velocity = velocity;
				timesJumped += 1;
			}
			if (Input.IsActionJustPressed("jump") && Velocity.Y > jumpImpulse / 2.0)
			{
				Vector3 velocity = Velocity;
				velocity.Y = jumpImpulse / (float)2.0;
				Velocity = velocity;
			}
		}
		/*
		private void ApplyControllerRotation()
		{
			Vector2 axisVector = Vector2.Zero;
            axisVector.X = Input.GetActionStrength("look_right") - Input.GetActionStrength("look_left");
            axisVector.Y = Input.GetActionStrength("look_down") - Input.GetActionStrength("look_up");

			if (InputEvent is InputEventJoypadMotion)
			{
				Vector3 rotation = Rotation;
				rotation.Y -= axisVector.X * controllerSensitivity * (float).001;
				head.Rotation
			}
        }*/

		/*
		func apply_controller_rotation():
			var axis_vector = Vector2.ZERO
			axis_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
			axis_vector.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	
			if InputEventJoypadMotion:
				rotation.y -= axis_vector.x * controller_sensitivity * .001
				head.rotation.x = clamp(head.rotation.x - axis_vector.y * controller_sensitivity * .001, -1.5, 1.5)
		 */

		private void Die()
		{
			GetParent<World>().PrepForRespawn();
			if (Name.ToString().ToInt() == 1 || !global.isNetworkedGame)
			{
				//Drop()
			}
			else
			{
				//Drop()
			}

			GD.Print("dead");
			QueueFree();
		}

		private void Fire()
		{
			if (!isReloading && ammo != 0)
			{
				ammo -= 1;
				hand.GetChild(0).GetNode<AudioStreamPlayer>("WeaponSound").Play();
				gunAnimationPlayer.Stop();
				gunAnimationPlayer.Play("fire");
				if (aimcast.IsColliding())
				{
					var target = aimcast.GetCollider();
					if (target != null)
					{
						if (target is Player player)
						{
							int id = player.Name.ToString().ToInt();
							player.RpcId(id, "take_damage", damage);
						}
						else
						{
							String decalPath = hand.GetChild<Tool>(0).decalPath;
							AddBulletHole(decalPath, aimcast);
						}
					}
				}
				hasFired = true;
				if (toolType == "Auto")
				{
					fireTimer.Start();
				}
			}
		}

        private void FireShotgun()
        {
            if (!isReloading && ammo != 0)
            {
                ammo -= 1;
                hand.GetChild(0).GetNode<AudioStreamPlayer>("WeaponSound").Play();
                gunAnimationPlayer.Stop();
                gunAnimationPlayer.Play("fire");
                if (aimcast.IsColliding())
                {
                    foreach(RayCast3D ray in fpRayContainer.GetChildren())
					{
                        Vector3 targetPosition = ray.TargetPosition;
                        targetPosition.X = GD.RandRange(spread, -spread);
                        targetPosition.Y = GD.RandRange(spread, -spread);
                        ray.TargetPosition = targetPosition;
                        var target = ray.GetCollider();
                        if (target != null)
                        {
                            if (target is Player player)
                            {
                                int id = player.Name.ToString().ToInt();
                                player.RpcId(id, "take_damage", damage);
                            }
                            else
                            {
                                String decalPath = hand.GetChild<Tool>(0).decalPath;
                                AddBulletHole(decalPath, aimcast);
                            }
                        }
                    }
                }
                hasFired = true;
                if (toolType == "Auto")
                {
                    fireTimer.Start();
                }
            }
        }

		private void Spray()
		{
			if (!isReloading && ammo == 0)
			{
                ammo -= 1;
                hand.GetChild(0).GetNode<AudioStreamPlayer>("WeaponSound").Play();
                if (aimcast.IsColliding())
                {
                    String decalPath = hand.GetChild<Tool>(0).decalPath;
                    AddBulletHole(decalPath, aimcast);
                }
            }
            hasFired = true;
            if (toolType == "Auto")
            {
                fireTimer.Start();
            }
        }

        private void Swing()
        {
            if (!isReloading && ammo != 0)
            {
                ammo -= 1;
                hand.GetChild(0).GetNode<AudioStreamPlayer>("WeaponSound").Play();
                gunAnimationPlayer.Stop();
                gunAnimationPlayer.Play("swing");
                if (fpSwordRange.IsColliding())
                {
                    var target = fpSwordRange.GetCollider();
                    if (target != null)
                    {
                        if (target is Player player)
                        {
                            int id = player.Name.ToString().ToInt();
                            player.RpcId(id, "take_damage", damage);
                        }
                        else
                        {
                            String decalPath = hand.GetChild<Tool>(0).decalPath;
                            AddBulletHole(decalPath, fpSwordRange);
                        }
                    }
                }
                hasFired = true;
                if (toolType == "Auto")
                {
                    fireTimer.Start();
                }
            }
        }

        public void OutOfBounds(Area3D area)
		{
			if (GlobalPosition.Y < -250)
			{
				TakeDamage(100);
			}
		}

		private void TakeDamage(int dmg)
		{
			health -= dmg;
			healthBar.Value = health;
			healthCounter.Text = health.ToString();
			if (health == 0)
			{
				Die();
			}
		}

		[Rpc(MultiplayerApi.RpcMode.AnyPeer)]
		public void AddBulletHole(String bDecPath, RayCast3D rayCast)
		{
			var target = aimcast.GetCollider();
			if (target != null)
			{
				if (target is Node3D node3D)
				{
					PackedScene bDecal = GD.Load<PackedScene>(bDecPath);
					Decal decal = bDecal.Instantiate<Decal>();
					node3D.AddChild(decal);
					Vector3 decTf = decal.GlobalPosition;
					decTf = rayCast.GetCollisionPoint();
				}
			}
		}

		public void OnReloadTimerTimeout()
		{
			reloadTimer.Stop();
			ammo = maxAmmo;
			reloadLabel.Hide();
			isReloading = false;
		}

		public void OnFireTimerTimeout()
		{
			hasFired = false;
		}
		public void OnWalkTimerTimeout()
		{
			canPlayWalkSound = true;
		}

		public void OnToolTreeItemActivated()
		{
			String toolName = toolTree.GetSelected().GetText(0);
			String tool = "res://tools/" + toolName + ".tscn";
			HideSBMenu();
			AddTool(tool);
        }

		private void AddTool(String toolName)
		{
			if (tool1 == null)
			{
				tool1 = toolName;
				Equip(tool1);
				currentTool = 1;
			}
			else if (tool2 == null)
			{
				tool2 = toolName;
				Equip(tool2);
                currentTool = 2;
            }
			else if (tool3 == null)
			{
				tool3 = toolName;
				Equip(tool3);
				currentTool = 3;
			}
			else if (tool4 == null)
			{
				tool4 = toolName;
				Equip(tool4);
				currentTool = 4;
			}
			else
			{
				return;
			}
		}
	}
}
