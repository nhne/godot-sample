extends Node

@export var mob_scene: PackedScene


func _on_mob_spawn_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $SpawnPath/SpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	add_child(mob)
	
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())


func _on_player_hit():
	$MobSpawnTimer.stop()
