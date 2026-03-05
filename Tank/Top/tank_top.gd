extends Node3D

@export var camera_path: NodePath
@export var turn_speed := 12.0
@export var fire_point : Marker3D
@export var anim : AnimationPlayer

var cam: Camera3D 

func _process(delta: float) -> void:
	if cam == null:
		cam = get_viewport().get_camera_3d()
		return

	var mouse := get_viewport().get_mouse_position()
	var ray_origin := cam.project_ray_origin(mouse)
	var ray_dir := cam.project_ray_normal(mouse)

	var plane := Plane(Vector3.UP, global_position.y)
	var hit = plane.intersects_ray(ray_origin, ray_dir)
	if hit == null:
		return

	var to : Vector3 = hit - global_position
	to.y = 0
	if to.length_squared() < 0.001:
		return

	var target_yaw := atan2(to.x, to.z)
	rotation.y = lerp_angle(rotation.y, target_yaw, clamp(turn_speed * delta, 0, 1))
	rotation.x = 0
	rotation.z = 0
	
	if Input.is_action_just_pressed("fire_primary"):
		anim.stop()
		anim.play("fire")
		_shoot.rpc_id(1, fire_point.global_transform)

@rpc("any_peer", "call_local")
func _shoot(fire_point_transform):
	var bullet = load("res://Bullet/bullet.tscn").instantiate() as Bullet
	get_tree().current_scene.get_node("Projectiles").add_child(bullet, true)
	bullet.global_transform = fire_point_transform
	bullet.fire(fire_point_transform.basis.z)
