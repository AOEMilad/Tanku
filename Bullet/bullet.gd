class_name Bullet
extends RigidBody3D

@export var bullet_speed: float = 30
var direction: Vector3 = Vector3.ZERO
var hasBounced: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(_delta: float) -> void:
	if linear_velocity.length() > 0.001:
		linear_velocity = linear_velocity.normalized() * bullet_speed

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Walls"):
		if hasBounced:
			queue_free()
		hasBounced = true
	
	if body is Node:
		pass


func fire(dir: Vector3) -> void:
	direction = dir.normalized()
	sleeping = false # Make sure physics uses your shove immediately
	apply_central_impulse(direction * bullet_speed)
