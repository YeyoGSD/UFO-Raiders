extends Node2D

@onready var enemy_path_scene:PackedScene = preload("res://EnemyPath/enemy_path.tscn")
@onready var rope:Rope = $Rope
@onready var ufo_part:UfoPart = $UfoPart
@onready var player1:Player = $Player1
@onready var player2:Player = $Player2

func get_closest_player(reference_position:Vector2) -> Player:
	var player1_distance:float = reference_position.distance_squared_to(player1.position)
	var player2_distance:float = reference_position.distance_squared_to(player2.position)
	if player1_distance < player2_distance:
		return player1
	else:
		return player2

func _on_ufo_part_entered_drop_point() -> void:
	rope.drop_ufo_part()
	player1.is_tied = false
	player2.is_tied = false

func _on_ufo_part_collected() -> void:
	var players_distance:float = player1.global_position.distance_to(player2.global_position)
	if rope.ufo_part == null and players_distance < 400: #400 es el valor de max_separation para la pantalla dividida
		rope.set_ufo_part(ufo_part)
		player1.is_tied = true
		player2.is_tied = true
		
func _on_enemy_spawn_timer_timeout() -> void:
	var players:Array = [player1, player2]
	for player:Player in players:
		var path:EnemyPath = enemy_path_scene.instantiate()
		path.curve = Curve2D.new()
		add_child(path)
		path.set_for_player_position(player.global_position)
