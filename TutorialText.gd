extends Node2D

onready var sprite = $sprite
onready var collision = $collision

var animating = false
var val = 0

func triggered_enter(body):
	if body.name == "Player":
		animating = true
		collision.queue_free()

func _ready():
	collision.connect("body_entered", self, "triggered_enter")

func _process(delta):
	
	if animating:
		val += delta
		
		if val >= 1:
			val = 1
			animating = false
		
		sprite.modulate.a = val
