extends Node2D

onready var scene = $Scene
onready var Effects = $Effects


var levels = [
	"Menu",
	"lvl_ez",
	"lvl_up_down",
	"Level1",
	"lvl_Jump",
	"lvl_jump2",
	"lvl_jump3",
	"lvl_danger1",
	"lvl_danger2",
	"lvl_danger3",
	"lvl_danger4",
	"lvl_danger5",
	"lvl_danger6",
	"lvl_switch",
	"lvl_switch2",
	"lvl_switch3",
	"lvl_switch4",
	"lvl_switch5",
	"lvl_victory"
]


var current_index = 0


func prev_level():
	if current_index > 0:
		current_index -= 1
		change_level()


func next_level():
	if len(levels) - 1 >= current_index + 1:
		current_index += 1
		change_level()
		Effects.stream = load('res://assets/win.wav')
		Effects.play()


func restart():
	change_level()


func change_level():
	for child in scene.get_children():
		child.queue_free()
		
	scene.add_child(load("res://levels/" + levels[current_index] + ".tscn").instance())
