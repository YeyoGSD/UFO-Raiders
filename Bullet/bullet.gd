class_name Bullet
extends Area2D

const SPEED:int = 250
var direction:Vector2

func _physics_process(delta:float) -> void:
	global_position += SPEED * direction * delta
	if direction:
		rotation = direction.angle() + PI/2

func _on_area_entered(area:Area2D) -> void:
	if area is Enemy:
		queue_free()

func _on_visible_on_screen_notifier_screen_exited() -> void:
	queue_free()
