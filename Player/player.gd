class_name  Player
extends Area2D

signal shot(bullet_spawn_position:Vector2, player_rotation:float)

@export var id:int
@export var partner:Player

@onready var bullet_spawn:Marker2D = $BulletSpawn
@onready var sprite:Sprite2D = $Sprite
@onready var sprite_size:Vector2 = sprite.texture.get_size() * sprite.get_scale()

const SPEED:int = 200

var direction:Vector2
var is_tied:bool = false

func _physics_process(delta:float) -> void:
	direction = Input.get_vector(
		"move_left_{n}".format({"n":id}),
		"move_right_{n}".format({"n":id}),
		"move_up_{n}".format({"n":id}),
		"move_down_{n}".format({"n":id}))
		
	if direction:
		rotation = lerp_angle(rotation, direction.angle() + PI/2, 0.2)
		global_position += direction * SPEED * delta
		global_position = global_position.clamp(sprite_size/2, Global.LEVEL_LIMITS)
		if is_tied:
			global_position = circle_clamp(global_position, partner.global_position, 350) # 350 es menos que max_separation de la pantalla dividida pero lo suficiente para moverse


func circle_clamp(vector:Vector2, clamp_origin:Vector2, clamp_length:float) -> Vector2:
	var offset:Vector2 = vector - clamp_origin
	return clamp_origin + offset.limit_length(clamp_length)

func _unhandled_key_input(event:InputEvent) -> void:
	if event.is_action_pressed("shoot_{n}".format({"n":id})):
		shot.emit(bullet_spawn.global_position, rotation)
