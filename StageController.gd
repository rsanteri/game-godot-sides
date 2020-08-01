extends Node2D

# 1 = down
# 0
var gravity_direction = 1
var grav = 0.5

var switch_state = 1


func change_gravity(dir):
	gravity_direction = dir;


func toggle_switch():
	switch_state = 1 if switch_state == 0 else 0
	
	var switches = self.get_node("SwitchPlatforms")
	
	if switches:
		for plat in switches.get_children():
			plat.switch(switch_state)


func _physics_process(delta):
	if (gravity_direction == 1 and gravity_direction > grav) or (gravity_direction == 0 and gravity_direction < grav):
		grav += -(delta*3) if grav > gravity_direction else (delta*3)
		
		for plat in self.get_node("Platforms").get_children():
			plat.get_node("PlatformRect").get_material().set_shader_param("gravity_dir", grav)

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("next_level"):
			
			get_tree().get_current_scene().next_level()
		if event.is_action_pressed("prev_level"):
			get_tree().get_current_scene().prev_level()

func _ready():
	toggle_switch()
