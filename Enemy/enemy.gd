class_name Enemy
extends Area2D

const VELOCITY:Vector2 = Vector2(0, 100)

func _physics_process(delta:float) -> void:
	global_position += VELOCITY * delta

func _on_area_entered(area:Area2D) -> void:
	if area != DropPoint:
		queue_free()

func _on_visible_on_screen_notifier_screen_exited() -> void:
	queue_free()
