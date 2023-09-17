extends Node

@export var mob_scene: PackedScene

@export var default_wait_time = 0.5

var mob_spawned

func _ready():
	$UserInterface/Retry.hide()
	$MobSpawnTimer.wait_time = default_wait_time
	mob_spawned = 0


func _on_mob_spawn_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $SpawnPath/SpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	add_child(mob)
	
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
	mob_spawned += 1
	if mob_spawned % 5 == 0:
		print('mob spawn got faster')
		$MobSpawnTimer.wait_time = max($MobSpawnTimer.wait_time - 0.05, 0.05)


func _on_player_hit():
	$MobSpawnTimer.stop()
	$UserInterface/Retry.show()


func _unhandled_input(event):
	if (event.is_action_pressed('ui_accept') or event.is_action_pressed('jump')) and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()
