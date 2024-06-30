class_name Enemy
extends Area2D

signal crashed

@onready var sprite:AnimatedSprite2D = $Sprite
@onready var audio_stream_player:AudioStreamPlayer = $AudioStreamPlayer

func _on_area_entered(area:Area2D) -> void:
	if area is Player:
		sprite.play("explosion")
		audio_stream_player.play()
		await sprite.animation_finished
		crashed.emit()
		queue_free()
