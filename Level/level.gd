extends Node2D

signal updated_lives

@onready var rope:Rope = $Rope
@onready var ufo_part:UfoPart = $UfoPart
@onready var player1:Player = $Player1
@onready var player2:Player = $Player2
@onready var enemy_spawn_timer:Timer = $EnemySpawnTimer
@onready var guide:Line2D = $Guide
@onready var hint_timer:Timer = $HintTimer

func _ready() -> void:
	Global.lives = 3
	Global.level = 0
	Global.score = 0

func _process(_delta:float) -> void:
	guide.remove_point(1)
	guide.add_point(ufo_part.global_position)

func _on_ufo_part_entered_drop_point() -> void:
	hint_timer.start()
	guide.hide()
	Global.score = 10 * Global.level * Global.lives
	Global.level += 1
	if Global.lives < 3:
		Global.lives += 1
		updated_lives.emit()
	rope.drop_ufo_part()
	player1.is_tied = false
	player2.is_tied = false
	ufo_part.global_position = Vector2(randi() % 2900 + 100, randi() % 1900 + 100)

func _on_ufo_part_collected() -> void:
	if rope.ufo_part == null:
		var players_distance:float = player1.global_position.distance_to(player2.global_position)
		if players_distance < 400: #400 es el valor de max_separation para la pantalla dividida
			rope.set_ufo_part(ufo_part)
			player1.is_tied = true
			player2.is_tied = true
			if Global.level < 4:
				enemy_spawn_timer.wait_time -= 0.5
			hint_timer.stop()
			guide.show()

func _on_enemy_spawn_timer_timeout() -> void:
	var players:Array = [player1, player2]
	for player:Player in players:
		var path:EnemyPath = Global.enemy_path_scene.instantiate()
		path.curve = Curve2D.new()
		add_child(path)
		path.set_for_player_position(player.global_position)

func _on_hint_timer_timeout() -> void:
	var player1_distance:float = player1.global_position.distance_squared_to(ufo_part.global_position)
	var player2_distance:float = player2.global_position.distance_squared_to(ufo_part.global_position)
	var closest_player:Player = player1 if player1_distance < player2_distance else player2
	closest_player.glow()

func _on_player_hit() -> void:
	Global.lives -= 1
	updated_lives.emit()
