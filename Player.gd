extends KinematicBody2D

onready var Stage = self.get_parent()
onready var Collider = $Collider
onready var ObjectCollider = $ObjectCollider
onready var Sound = $Sound


var run_speed = 350
var jump_speed = -500
var gravity = 1500

var velocity = Vector2()

enum Action {
	gravity,
	goal,
	switch,
	exit
}

var action_available = null
var gravity_direction = 0

var collider_timer = 0
var to_be_restarted = false

func handle_area_enter(body):
	if body.is_in_group("Damage"):
		to_be_restarted = true
	elif body.is_in_group("Grave"):
		action_available = Action.gravity
	elif body.is_in_group("Goal"):
		action_available = Action.goal
	elif body.is_in_group("Switch"):
		action_available = Action.switch
	elif body.is_in_group("Exit"):
		action_available = Action.exit

func handle_area_exited(body):
	if body.is_in_group("Grave") and action_available == Action.gravity:
		action_available = null
	elif body.is_in_group("Goal") and action_available == Action.goal:
		action_available = null
	elif body.is_in_group("Switch") and action_available == Action.switch:
		action_available = null
	elif body.is_in_group("Exit") and action_available == Action.exit:
		action_available = null
	

func is_grounded():
	return (gravity_direction == 0 and is_on_floor()) or (gravity_direction == 1 and is_on_ceiling())

func get_input():
	var action = Input.is_action_just_pressed('action')
	
	if action_available == Action.gravity and action:
		# Invert physics
		jump_speed = -jump_speed
		gravity = -gravity
		gravity_direction = 1 if gravity_direction == 0 else 0
		# Make player move to other side and disable collider for moment
		velocity.y = -350 if gravity_direction == 0 else 350
		Collider.disabled = true
		collider_timer = 0.15
		Stage.change_gravity(0 if gravity_direction == 1 else 1)
		Sound.stream = load('res://assets/switch.wav')
		Sound.play()
		return
	elif action_available == Action.goal and action and is_grounded():
		get_tree().get_current_scene().next_level()
		return
	elif action_available == Action.switch and action:
		Stage.toggle_switch()
		Sound.stream = load('res://assets/bump.wav')
		Sound.play()
		return
	elif action_available == Action.exit and action:
		get_tree().quit()
		return
	
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_select')
	var penetrate = (gravity_direction == 0 and Input.is_action_pressed('ui_down')) or (gravity_direction == 1 and Input.is_action_pressed('ui_up'))

	if is_grounded() and jump:
		velocity.y = jump_speed
		Sound.stream = load('res://assets/jump2.wav')
		Sound.play()
	elif is_grounded() and penetrate:
		Collider.disabled = true
		collider_timer = 0.15
		# position.y = position.y + (15 if gravity_direction == 0 else -15)
	
	if right:
			velocity.x += run_speed
	if left:
			velocity.x -= run_speed


func is_in_screen():
	return position.x > 0 and position.x < 1280 and position.y > 0 and position.y < 720

func _physics_process(delta):
	velocity.y += gravity * delta
	get_input()
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if collider_timer < 0:
		collider_timer = 0
		Collider.disabled = false
	elif collider_timer > 0:
		collider_timer -= delta
	
	if !is_in_screen() or to_be_restarted:
		get_tree().get_current_scene().restart()


func _ready():
	ObjectCollider.connect("area_entered", self, "handle_area_enter")
	ObjectCollider.connect("area_exited", self, "handle_area_exited")
