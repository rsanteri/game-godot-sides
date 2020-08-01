extends Node2D

onready var Col = $Color
onready var Collider = $StaticBody2D/Collider

export var platform_type = 0

var target_opacity = 1
var opacity = 0.2


func switch(active_type: int):
	target_opacity = 1 if active_type == platform_type else 0
	Collider.disabled = active_type != platform_type


func _process(delta):
	if opacity != target_opacity:
		opacity += delta if opacity < target_opacity else -delta
		Col.color.a = opacity
		
		if target_opacity == 1 and opacity >= 1:
			opacity = 1
		elif target_opacity == 0 and opacity <= 0.2:
			opacity = 0.2

func _ready():
	if platform_type == 1:
		Col.color = Color(0.75, 0.63, 0.85, opacity)
