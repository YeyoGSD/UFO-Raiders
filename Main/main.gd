extends Node2D

@onready var bullet_scene:PackedScene = preload("res://Bullet/bullet.tscn")
@onready var enemy_scene:PackedScene = preload("res://Enemy/enemy.tscn")
@onready var spawn_point:PathFollow2D = $EnemySpawner/SpawnPoint
@onready var rope:Rope = $Rope
@onready var ufo_part:UfoPart = $UfoPart
@onready var player1:Player = $Player1
@onready var player2:Player = $Player2

func _on_enemy_spawn_timer_timeout() -> void:
	var new_enemy:Enemy = enemy_scene.instantiate()
	spawn_point.progress_ratio = randf()
	new_enemy.position = spawn_point.position
	new_enemy.target = get_closest_player(new_enemy.position)
	add_child(new_enemy)

func get_closest_player(reference_position:Vector2) -> Player:
	var player1_distance:float = reference_position.distance_squared_to(player1.position)
	var player2_distance:float = reference_position.distance_squared_to(player2.position)
	if player1_distance < player2_distance:
		return player1
	else:
		return player2

func _on_player_shot(bullet_spawn_position:Vector2) -> void:
	var new_bullet:Bullet = bullet_scene.instantiate()
	new_bullet.position = bullet_spawn_position
	add_child(new_bullet)

func _on_ufo_part_entered_drop_point() -> void:
	rope.drop_ufo_part()

func _on_ufo_part_collected() -> void:
	if rope.ufo_part == null:
		rope.set_ufo_part(ufo_part)
