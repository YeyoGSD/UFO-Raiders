class_name  Player
extends Area2D

signal shot(bullet_spawn_position:Vector2)

@export var id:int

@onready var bullet_spawn:Marker2D = $BulletSpawn
@onready var sprite:Sprite2D = $Sprite
@onready var sprite_size:Vector2 = sprite.texture.get_size() * sprite.get_scale()

const SPEED:int = 200
var direction:Vector2

func _physics_process(delta:float) -> void:
	direction = Input.get_vector(
		"move_left_{n}".format({"n":id}),
		"move_right_{n}".format({"n":id}),
		"move_up_{n}".format({"n":id}),
		"move_down_{n}".format({"n":id}))
	global_position += direction * SPEED * delta
	global_position = global_position.clamp(sprite_size/2, Global.viewport_size - sprite_size/2)

func _unhandled_key_input(event:InputEvent) -> void:
	if event.is_action_pressed("shoot_{n}".format({"n":id})):
		shot.emit(bullet_spawn.global_position)
