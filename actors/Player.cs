using Godot;
using Godot.Collections;
using System;
using Toonbox.Runtime;
using Toonbox.Tools;

namespace Toonbox.Actors
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
		public Node3D model;
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
		public Window sbMenuWindow;
		[Export]
		public Panel sbMenu;
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
					playerName.Text = Name.ToString();
				}
				crosshair.Show();
				playerPanel.Show();
				toolPanel.Show();
			}
			fpCamera.Current = IsMultiplayerAuthority();
			tpCamera.Current = false;
			model.Visible = !IsMultiplayerAuthority();
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
					//AddTool(toolToSpawn);
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
			foreach (RayCast3D ray in fpRayContainer.GetChildren())
			{
				Vector3 targetPosition = ray.TargetPosition;
				targetPosition.X = GD.RandRange(spread, -spread);
				targetPosition.Y = GD.RandRange(spread, -spread);
				ray.TargetPosition = targetPosition;
			}
			fireTimer.WaitTime = tool2Spawn.cooldownTime;
			damage = tool2Spawn.damage;
			toolType = tool2Spawn.toolType;
			tool2Spawn.Rotation = handLoc.Rotation;
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
			else if (fpCamera.Current == true)
			{
				model.Visible = !IsMultiplayerAuthority();
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
			else if (((Velocity.Length() == 0) || (vel.Length() == 0)) && Input.IsActionPressed("crouch"))
			{
				animationPlayer.Play("crouch_library/crouch_idle");
				Vector3 modelPosition = model.Position;
				modelPosition.Y = (float)0.175;
				model.Position = modelPosition;
				if (!isReloading && gunAnimationPlayer.CurrentAnimation == "fire") gunAnimationPlayer.Play("idle");
			}
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
			}
		}
		/*
		 
		 func _physics_process(delta):
	
	else:
		if max_speed == default_speed and is_on_floor():
			animation_player.play("Locomotion-Library/walk")
			model.position.y = 0
			$PlayerModel/Akari.position = Vector3.ZERO
			$PlayerModel/Akari.rotation = Vector3.ZERO
			#animation_player.rpc("play", "walk")
			if can_play_walk_sound:
				can_play_walk_sound = false
				$WalkSound.stream = foot_sounds.pick_random()
				$WalkSound.play()
				walk_timer.start()
			if !is_reloading and !gun_ap.current_animation == "fire":
				gun_ap.play("walk")
				#gun_ap.rpc("play", "walk")
		elif max_speed == crouch_move_speed and is_on_floor():
			animation_player.play("crouch_library/crouch_walk")
			model.position.y = 0.175
			#animation_player.rpc("play", "walk")
			if can_play_walk_sound:
				can_play_walk_sound = false
				$WalkSound.stream = foot_sounds.pick_random()
				$WalkSound.play()
				walk_timer.start()
			if !is_reloading and !gun_ap.current_animation == "fire":
				gun_ap.play("walk")
				#gun_ap.rpc("play", "walk")
		elif max_speed == sprint_speed and is_on_floor():
			animation_player.play("Locomotion-Library/run")
			model.position.y = 0
			$PlayerModel/Akari.position = Vector3.ZERO
			$PlayerModel/Akari.rotation = Vector3.ZERO
			#animation_player.rpc("play", "walk")
			if can_play_walk_sound:
				can_play_walk_sound = false
				$WalkSound.stream = foot_sounds.pick_random()
				$WalkSound.play()
				walk_timer.start()
			if !is_reloading and !gun_ap.current_animation == "fire":
				gun_ap.play("run")
				#gun_ap.rpc("play", "walk")
		elif !is_on_floor():
			animation_player.play("Locomotion-Library/jump")
			model.position.y = 0
			$PlayerModel/Akari.position = Vector3.ZERO
			$PlayerModel/Akari.rotation = Vector3.ZERO
			#animation_player.rpc("play", "jump")
			if !is_reloading and !gun_ap.current_animation == "fire":
				gun_ap.play("idle")
				#gun_ap.rpc("play", "idle")
	
	if is_multiplayer_authority() or !Global.isNetworkedGame:
		max_speed = default_speed
		walk_timer.wait_time = default_walk_sound_time
		var input_vector = get_input_vector()
		var direction = get_direction(input_vector)
		jump()
		vel = velocity
		
		$Hud/Panel/HealthBar.value = health
		$Hud/Panel.theme = ThemeManager.theme
		$Hud/ToolPanel.theme = ThemeManager.theme
		crosshair.theme = ThemeManager.theme
		sb_menu_window.theme = ThemeManager.theme
		tool_ammo_bar.get_node("Label").text = var_to_str(ammo) + " / " + var_to_str(max_ammo)
		tool_ammo_bar.value = ammo
		tool_ammo_bar.max_value = max_ammo
		
		$Hud/Panel/SprintingIcon.hide()
		
		if Input.is_action_pressed("sprint"): #and is_on_floor():
			max_speed = sprint_speed
			walk_timer.wait_time = sprint_walk_sound_time
			$Hud/Panel/SprintingIcon.show()
		
		if Input.is_action_pressed("crouch"):
			coll_shape.shape.height = crouch_height #-= crouch_speed * delta
			#head.position.y = head_crouch_height
			max_speed = crouch_move_speed
			walk_timer.wait_time = 0.8
			model.position.y = 0.175
		else:
			coll_shape.shape.height = default_height#crouch_speed * delta 
			#head.position.y = head_height
			model.position.y = 0
			$PlayerModel/Akari.position = Vector3.ZERO
			$PlayerModel/Akari.rotation = Vector3.ZERO
		
		#coll_shape.shape.height = clamp(coll_shape.shape.height, 0.8, 1.497)
		
		apply_movement(direction, delta)
		apply_gravity(delta)
		apply_friction(direction, delta)
		apply_controller_rotation()
		set_velocity(velocity)
		# TODOConverter40 looks that snap in Godot 4.0 is float, not vector like in Godot 3 - previous value `snap_vector`
		set_up_direction(Vector3.UP)
		set_floor_stop_on_slope_enabled(true)
		set_max_slides(4)
		set_floor_max_angle(.7853)
		move_and_slide()
		velocity = velocity
		vel = velocity
	
	if is_on_floor():
		times_jumped = 0
	
	hand.global_transform.origin = hand_loc.global_transform.origin
	hand.global_rotation = hand_loc.global_rotation
	#hand.rotation.y = lerp_angle(hand.rotation.y, rotation.y, SWAY * delta)
	#hand.rotation.x = lerp_angle(hand.rotation.x, head.rotation.x, VSWAY * delta)
	$ReloadSound.global_transform.origin = hand_loc.global_transform.origin
	$PickupSound.global_transform.origin = hand_loc.global_transform.origin
	
	if hand.get_child_count() > 0:
		if hand.get_child(0) != null:
			#if hand.get_child(0).get_name() == "Paintball Gun":
				#tool_to_drop = pb_gun.instantiate()
			#elif hand.get_child(0).get_name() == "Paintball Pistol":
				#tool_to_drop = pb_pistol.instantiate()
			tool_to_drop = hand.get_child(0).toolObjectPath
		else:
			tool_to_drop = null
	else:
		tool_to_drop = null
	
	if (!is_multiplayer_authority() and Global.isNetworkedGame) or Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		return
	
	if !Global.gamePaused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		crosshair.show()
	
	
	
	
	
	
	if reach.is_colliding():
		if "wp" in reach.get_collider().get_name() or "tl" in reach.get_collider().get_name():
			tool_to_spawn = reach.get_collider().toolPath
		else:
			tool_to_spawn = null
	else:
		tool_to_spawn = null
	
	
	
	if weapon_type == "Semi":
		if Input.is_action_just_pressed("action_button"):
			if hand.get_child_count() > 0:
				if hand.get_child(0) != null:
					if !has_fired:
							_fire()
		elif Input.is_action_just_released("action_button"):
			has_fired = false
	elif weapon_type == "Auto":
		if Input.is_action_pressed("action_button"):
			if hand.get_child_count() > 0:
				if hand.get_child(0) != null:
					if !has_fired:
							_fire()
	elif weapon_type == "Shotgun":
		if Input.is_action_just_pressed("action_button"):
			if hand.get_child_count() > 0:
				if hand.get_child(0) != null:
					if !has_fired:
							_fire_shotgun()
	elif weapon_type == "Spray":
		if Input.is_action_pressed("action_button"):
			if hand.get_child_count() > 0:
				if hand.get_child(0) != null:
					if !has_fired:
							_spray()
	
	if Global.gameMode == "Sandbox":
		if Input.is_action_just_pressed("menu2") and !sb_menu_window.visible:
			sb_menu_window.popup_centered()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.is_action_just_pressed("menu2"):
			hide_sb_menu()
		 
		 */

		private void HideSBMenu()
		{
			sbMenu.Hide();
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
						/*if (target is Player player)
						{
							player.health -= damage;
						}*/
						if (target is Player player)
						{
							int id = player.Name.ToString().ToInt();
							player.RpcId(id, "take_damage", damage);
						}
						else
						{

						}
					}
				}
			}
		}
		/*
		 func _fire():
	if !is_reloading and ammo != 0:
		ammo -= 1
		hand.get_child(0).get_node("WeaponSound").play()
		gun_ap.stop()
		gun_ap.play("fire")
		if aimcast.is_colliding():
			var target = aimcast.get_collider()
			if target.is_in_group("bot") and !hand.get_child(0).name == "SprayGun":
				print("hit bot")
				target.health -= damage
			elif target.is_in_group("player") and !hand.get_child(0).name == "SprayGun":
				#print("hit player")
				var id = target.name
				target.rpc_id(str_to_var(id), "take_damage", damage)
			else:
				var b_decal = hand.get_child(0).decalPath
				add_bullet_hole(b_decal, aimcast)
				rpc("add_bullet_hole", b_decal)
	has_fired = true
	if weapon_type == "Auto":
		$FireTimer.start()

func _fire_shotgun():
	if !is_reloading and ammo != 0:
		ammo -= 1
		hand.get_child(0).get_node("WeaponSound").play()
		gun_ap.stop()
		gun_ap.play("fire")
		for r in fp_ray_container.get_children():
			r.target_position.x = randi_range(spread, -spread)
			r.target_position.y = randi_range(spread, -spread)
		
			if r.is_colliding():
				var target = r.get_collider()
				if target.is_in_group("bot") and !hand.get_child(0).name == "SprayGun":
					print("hit bot")
					target.health -= damage
				elif target.is_in_group("player") and !hand.get_child(0).name == "SprayGun":
					#print("hit player")
					var id = target.name
					target.rpc_id(str_to_var(id), "take_damage", damage)
				else:
					var b_decal = hand.get_child(0).decalPath
					add_bullet_hole(b_decal, r)
					rpc("add_bullet_hole", b_decal)
	has_fired = true
	$FireTimer.start()

func _spray():
	if !is_reloading and ammo != 0:
		ammo -= 1
		hand.get_child(0).get_node("WeaponSound").play()
		if aimcast.is_colliding():
			var b_decal = hand.get_child(0).decalPath
			add_bullet_hole(b_decal, aimcast)
			rpc("add_bullet_hole", b_decal)
	has_fired = true
	if weapon_type == "auto":
		$FireTimer.start()
		 */

		public void OutOfBounds(Area3D area)
		{
			if (GlobalPosition.Y < -250)
			{
				//Insert TakeDamage(100); Here
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
