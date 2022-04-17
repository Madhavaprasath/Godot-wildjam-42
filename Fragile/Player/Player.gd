extends Entity

export (int) var movement_speed


export (String) var myBeastAttack
var modes=["Normal","Beast"]
var current_mode=modes[0]
export (int) var dashdist = 250
export (int) var dashspeed = 1000
var dashtime
var velocity=Vector2()
var direction
var dash_velocity = Vector2()
var power_gauge = 10
var canDash = true
var shooting = false
onready var animation_player=get_node("AnimationPlayer")



func _ready():
	current_state=states.IDLE
	type = types[0]
	pass

func _physics_process(delta):
	if current_state == states.STUN:
		return
	if current_state == states.DASH:
		_process_dash(delta)
	else  :
		_apply_movement(delta)
		look_at(get_viewport().get_mouse_position())
	if current_state != states.DASH &&current_state != states.STUN:
		if velocity != Vector2():
			current_state = states.MOVEMENT
		else :
			current_state = states.IDLE

		#print(current_state,velocity)

		animate_state(current_mode,current_state)

func match_fsm(state):
	match state:
		states.IDLE:
			if velocity!=Vector2():
				return states.MOVEMENT
		states.MOVEMENT:
			if velocity==Vector2():
				return states.IDLE
		states.ATTACK:
			return states.IDLE
		states.DASH:
			return states.IDLE
	return null

func _apply_movement(delta):
	var input_vector=Vector2()
	input_vector.x=int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	input_vector.y=int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
	direction = input_vector
	if not (input_vector.x!=0 and input_vector.y!=0):
		velocity=lerp(velocity,input_vector*movement_speed,pow(delta,0.001))
	velocity=move_and_slide(input_vector*movement_speed)

func _unhandled_input(event):
	if event.is_action_pressed("Space") && power_gauge >= 10:
		transform_into_beast()
	if event.is_action_pressed("Shift"):
		initiate_dash()
	if event is InputEventMouseButton and event.get_button_index() == 1 and event.is_pressed() && shooting == false:
		shooting = true
		_attack()
		$ShootTimer.start()

func initiate_dash():
	print (current_state)
	if current_state != states.DASH && current_state != states.IDLE :
		current_state = states.DASH
		dashtime = 0
		dash_velocity = Vector2()
		collision_mask = 0b10


func animate_state(current_mode,current_state):
	pass

func _attack() :
	var atk
	var offset = Vector2()
	if current_mode == modes[0]:
		atk = load(myAttack).instance()
	else :
		atk = load(myBeastAttack).instance()
		offset = (get_viewport().get_mouse_position() - get_position()).normalized()
	get_parent().add_child(atk)
	atk.init(0,1,1,self,offset*100)

func transform_into_beast():
	print("beast on")
	
	$ShootTimer.wait_time =0.25
	$BeastTime.start()
	current_mode = modes[1]
	pass

"""Make dash physics calculations here.
WARNING once the DASH is over, go back to IDLE space """
func _process_dash(delta):
	dashtime = dashtime + delta
	print(dashtime)
	dash_velocity = lerp(dash_velocity,direction*dashspeed,pow(delta,0.001))
	dash_velocity = move_and_slide(dash_velocity)
	if (dashtime*dashspeed > dashdist) :
		current_state = states.IDLE
		collision_mask = 0b111
	pass


func _on_BeastTime_timeout():
	current_mode = modes[0]
	$ShootTimer.wait_time =0.25
	power_gauge = 0
	pass # Replace with function body.


func _on_ShootTimer_timeout():
	
	if Input.is_mouse_button_pressed(1) && current_state != states.STUN && current_state != states.DASH:
		shooting = true
		_attack()
		$ShootTimer.start()
	else :
		shooting = false
	pass # Replace with function body.
