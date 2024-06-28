class_name EnemyPath
extends Path2D

@onready var path_follow:PathFollow2D = $PathFollow
@onready var line:Line2D = $Line
@onready var enemy:Area2D = $PathFollow/Enemy
@onready var enemy_spawn_timer:Timer = $EnemySpawnTimer
@onready var animation_player:AnimationPlayer = $AnimationPlayer

var speed:int = 0

func _ready():
	animation_player.play("line_blink")

func _process(delta:float) -> void:
	path_follow.progress += speed * delta
	if path_follow.get_progress_ratio() == 1:
		queue_free()

func set_for_player_position(player_position:Vector2) -> void:
	var y_coords:Array = [-100,2100] # Un poco más que la altura del mapa
	var slope:float = randf_range(1,4) * [-1,1].pick_random()
	for y:int in y_coords:
		var point:Vector2 = Vector2(point_slope_equation(y, player_position, slope),y)
		curve.add_point(point)
		line.add_point(point)
	enemy_spawn_timer.start()

func point_slope_equation(y:int, point:Vector2, m:float=1) -> float:
	return (y - point.y)/m + point.x

func _on_enemy_spawn_timer_timeout():
	speed = 1500
	animation_player.stop()
