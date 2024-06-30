extends Node

@onready var menu_scene:PackedScene = preload("res://Menu/menu.tscn")
@onready var main_scene:PackedScene = preload("res://Main/main.tscn")
@onready var game_over_scene:PackedScene = preload("res://GameOver/game_over.tscn")
@onready var enemy_path_scene:PackedScene = preload("res://EnemyPath/enemy_path.tscn")
@onready var viewport_size:Vector2 = get_viewport().get_visible_rect().size

const LEVEL_LIMITS:Vector2 = Vector2(3000,2000)
var game_state:String = "stop"
var level:int = 0
var lives:int = 3
var score:int = 0
