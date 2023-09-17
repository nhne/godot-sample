extends CharacterBody3D


# Minimum speed of the mob in meters per second.
@export var min_speed = 10
# Maximum speed of the mob in meters per second.
@export var max_speed = 18

signal squashed

var is_squashed = false

func initialize(start_position, player_position):
	var player_without_y = player_position
	player_without_y.y = 0
	look_at_from_position(start_position, player_without_y, Vector3.UP)
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	var random_speed = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)


func _physics_process(_delta):
	move_and_slide()


func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()


func squash():
	if is_squashed:
		return
	is_squashed = true
	squashed.emit()
	queue_free()
