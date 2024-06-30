extends Control
@onready var transition:AnimationPlayer = $Transition

func _on_start_pressed() -> void:
	transition.play("fade_out")
	await transition.animation_finished
	get_tree().change_scene_to_packed(Global.main_scene)

func _on_exit_pressed() -> void:
	get_tree().quit()
