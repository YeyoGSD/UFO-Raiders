class_name Bullet
extends Area2D

const VELOCITY:Vector2 = Vector2(0,-250)

func _physics_process(delta:float) -> void:
	global_position += VELOCITY * delta

func _on_area_entered(area:Area2D) -> void:
	if area is Enemy:
		queue_free()

func _on_visible_on_screen_notifier_screen_exited() -> void:
	queue_free()
