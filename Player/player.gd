class_name  Player
extends Area2D

signal hit

@export var id:int
@export var partner:Player

@onready var sprite:AnimatedSprite2D = $AnimatedSprite
@onready var sprite_size:Vector2 = 64 * sprite.get_scale() # no encontré como obtener el tamaño de un animatedSprite por código

const SPEED:int = 200

var direction:Vector2
var is_tied:bool = false

func _ready() -> void:
	sprite.play("{n}".format({"n":id}))
	#Probablemente hay una mejor manera de manejar distintas skins

func _physics_process(delta:float) -> void:
	direction = Input.get_vector(
		"move_left_{n}".format({"n":id}),
		"move_right_{n}".format({"n":id}),
		"move_up_{n}".format({"n":id}),
		"move_down_{n}".format({"n":id}))

	if direction:
		rotation = lerp_angle(rotation, direction.angle() + PI/2, 0.1)
		global_position += direction * SPEED * delta
		global_position = global_position.clamp(sprite_size/2, Global.LEVEL_LIMITS)
		if is_tied:
			global_position = circle_clamp(global_position, partner.global_position, 350) 
			# 350 es menos que max_separation de la pantalla dividida pero lo suficiente para moverse

func circle_clamp(vector:Vector2, clamp_origin:Vector2, clamp_length:float) -> Vector2:
	var offset:Vector2 = vector - clamp_origin
	return clamp_origin + offset.limit_length(clamp_length)

func glow() -> void:
	sprite.modulate = Color.NAVY_BLUE
	await get_tree().create_timer(3).timeout
	sprite.modulate = Color(1,1,1,1)

func _on_area_entered(area:Area2D) -> void:
	if area is Enemy:
		hit.emit()
