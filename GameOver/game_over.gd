extends Control

@onready var game_over:Label = $PanelContainer/MarginContainer/VBoxContainer/GameOver
@onready var score:Label = $PanelContainer/MarginContainer/VBoxContainer/Score
@onready var transition:AnimationPlayer = $Transition

func _ready() -> void:
	game_over.text = "Has morido en el nivel " + str(Global.level)
	score.text = "Tus puntos: " + str(Global.score)

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		transition.play("fade_out")
		await transition.animation_finished
		get_tree().change_scene_to_packed(Global.menu_scene)
