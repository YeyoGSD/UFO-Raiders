class_name UfoPart
extends Area2D

signal entered_drop_point
signal collected

func _on_area_entered(area:Area2D) -> void:
	if area is DropPoint:
		entered_drop_point.emit()
	if area is Player:
		collected.emit()
