class_name Rope
extends Node2D

@export var rope_length:float = 100 # length of rope
@export var rope_points:float = 25 # simulated points of the rope
@export var constrain:float = 1 # distance between points
@export var gravity:Vector2 = Vector2(0,9.5)
@export var dampening:float = 0.9 # damping of the verlocity
@export var pin_start:bool = true # pin start point
@export var pin_end:bool = true # pin end point
@export var player1 : Area2D
@export var player2 : Area2D
@export var ufo_part : Area2D

@onready var line_2d : Line2D = $Line2D

var pos: PackedVector2Array
var pos_prev: PackedVector2Array
var point_count: int

func _ready()->void:
	point_count = get_point_count(rope_points)
	resize_arrays()
	init_position()

func set_start(p:Vector2)->void:
	pos[0] = p
	pos_prev[0] = p

func set_last(p:Vector2)->void:
	pos[point_count-1] = p
	pos_prev[point_count-1] = p
	
func set_ufo_part(ufo_part : Area2D) -> void:
	self.ufo_part = ufo_part
	show()

func drop_ufo_part():
	self.ufo_part = null
	hide()

func get_point_count(distance: float)->int:
	return int(ceil(distance / constrain))

func resize_arrays():
	pos.resize(point_count)
	pos_prev.resize(point_count)
	
func _process(delta)->void:
	update_points(delta)
	update_constrain()
	set_start(player1.global_position)
	set_last(player2.global_position)
	if ufo_part != null:
		ufo_part.global_position = pos[pos.size()/2]
	
	#update_constrain()	#Repeat to get tighter rope
	#update_constrain()
	
	# Send positions to Line2D for drawing
	line_2d.points = pos
	
func init_position()->void:
	for i in range(point_count):
		pos[i] = position + Vector2(constrain *i, 0)
		pos_prev[i] = position + Vector2(constrain *i, 0)
	position = Vector2.ZERO

func update_points(delta)->void:
	for i in range (point_count):
		# not first and last || first if not pinned || last if not pinned
		if (i!=0 && i!=point_count-1) || (i==0 && !pin_start) || (i==point_count-1 && !pin_end):
			var velocity = (pos[i] -pos_prev[i]) * dampening
			pos_prev[i] = pos[i]
			pos[i] += velocity + (gravity * delta)

func update_constrain()->void:
	for i in range(point_count):
		if i == point_count-1:
			return
		var distance = pos[i].distance_to(pos[i+1])
		var difference = constrain - distance
		var percent = difference / distance
		var vec2 = pos[i+1] - pos[i]
		
		# if first point
		if i == 0:
			if pin_start:
				pos[i+1] += vec2 * percent
			else:
				pos[i] -= vec2 * (percent/2)
				pos[i+1] += vec2 * (percent/2)
		# if last point, skip because no more points after it
		elif i == point_count-1:
			pass
		# all the rest
		else:
			if i+1 == point_count-1 && pin_end:
				pos[i] -= vec2 * percent
			else:
				pos[i] -= vec2 * (percent/2)
				pos[i+1] += vec2 * (percent/2)
