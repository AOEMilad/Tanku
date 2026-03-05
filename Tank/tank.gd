class_name Tank
extends CharacterBody3D

@export var collider: CollisionShape3D
@export var move_speed: float = 5.0            # units / second                          (originally 6)
@export var turn_speed: float = 3.0            # radians / second (how fast you swivel)  (originally 8)
@export var align_threshold_deg: float = 45.0  # start moving when within this angle     (originally 10.0)
@export var damp_when_idle: float = 12.0       # how fast you stop when no input         (originally 12.0)

@export var input_direction: Vector2 = Vector2.ZERO

func _ready():
	add_to_group("Players")

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	# 1) Gather WASD as a 2D vector
	var input_vec := Vector2(
		Input.get_action_strength("move_left") - Input.get_action_strength("move_right"),
		Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	)

	if input_vec.length() > 0.01:
		input_vec = input_vec.normalized()

		# 2) Convert to a 3D move direction on the XZ plane
		var move_dir := Vector3(input_vec.x, 0.0, input_vec.y)

		# 3) Desired yaw so our forward (-Z) points along move_dir
		var desired_yaw := atan2(move_dir.x, -move_dir.z)

		# 4) Smoothly rotate toward the desired yaw (limited by turn_speed)
		var delta_yaw := wrapf(desired_yaw - collider.rotation.y, -PI, PI)
		var max_step := turn_speed * delta
		collider.rotation.y += clamp(delta_yaw, -max_step, max_step)

		# 5) Only move once we're mostly aligned (gives that Wii Tanks "swivel then go")
		var aligned: bool = abs(delta_yaw) <= deg_to_rad(align_threshold_deg)
		if aligned:
			var fwd := -collider.global_transform.basis.z
			velocity.x = fwd.x * move_speed
			velocity.z = fwd.z * move_speed
		else:
			# Slight creep while turning? Comment out to lock in place.
			velocity.x = move_toward(velocity.x, 0.0, damp_when_idle * delta)
			velocity.z = move_toward(velocity.z, 0.0, damp_when_idle * delta)
	else:
		# No input → stop smoothly
		velocity.x = move_toward(velocity.x, 0.0, damp_when_idle * delta)
		velocity.z = move_toward(velocity.z, 0.0, damp_when_idle * delta)

	velocity.y = 0.0
	move_and_slide()
