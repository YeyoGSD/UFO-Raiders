class_name UfoPart
extends Area2D

@onready var sprite:AnimatedSprite2D = $Sprite

signal entered_drop_point
signal collected

func _ready() -> void:
	sprite.frame = randi() % 10

func _on_area_entered(area:Area2D) -> void:
	if area is DropPoint:
		entered_drop_point.emit()
	if area is Player:
		collected.emit()
