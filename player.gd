extends CharacterBody3D

signal hit

const SPEED = 8.0

# vertical impulse on jump
@export var jump_impulse = 10

# vertical impulse applied to cahracter upon bounce
@export var bounce_impulse = 6

# simulation for graviy
@export var gravity_simulation_coeff = 3

# rotate speed for character
@export var rotate_speed = PI * 3


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var pivot_direction = Vector3.FORWARD

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta * gravity_simulation_coeff

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_impulse

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		# $Pivot.rotation.y < direction.angle_to(Vector3.UP)
		var simliarity = direction.dot(pivot_direction)
		if simliarity < 0.99:
			if direction.cross(pivot_direction).y > 0:
				rotate_speed *= -1
			pivot_direction = pivot_direction.rotated(Vector3.UP, rotate_speed * delta)
		else:
			pivot_direction = direction
		$Pivot.look_at(position + pivot_direction, Vector3.UP)
		$AnimationPlayer.speed_scale = 4
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		$AnimationPlayer.speed_scale = 1

	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		
		if collision.get_collider() == null:
			continue
		
		if collision.get_collider().is_in_group('mob'):
			var mob = collision.get_collider()
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				velocity.y = bounce_impulse


func _on_mob_detector_body_entered(body):
	die()
	
	
func die():
	hit.emit()
	queue_free()
