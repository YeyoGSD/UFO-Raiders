class_name Enemy
extends Area2D

const SPEED:int = 100

var direction:Vector2 = Vector2.ZERO
var target:Player

func _physics_process(delta:float) -> void:
	if target != null:
		direction = position.direction_to(target.position)
	global_position += SPEED * delta * direction

func _on_area_entered(area:Area2D) -> void:
	if area != DropPoint:
		queue_free()

func _on_visible_on_screen_notifier_screen_exited() -> void:
	queue_free()
