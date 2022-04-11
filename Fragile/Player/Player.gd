extends Entity

export (int) var movement_speed


var modes=["Normal","Beast"]
var current_mode=modes[0]

var velocity=Vector2()

onready var animation_player=get_node("AnimationPlayer")



func _ready():
	current_state=states.IDLE
	pass

func _physics_process(delta):
	_apply_movement(delta)
	var state=match_fsm(current_state)
	if state!=null:
		current_state=state
		print(state,velocity)
		animate_state(current_mode,current_state)

func match_fsm(state):
	match state:
		states.IDLE:
			if velocity!=Vector2():
				return states.MOVEMENT
		states.MOVEMENT:
			if velocity==Vector2():
				return states.IDLE
		states.ATTACK:                """Setted them for now in idle will work on it tomorrow
			return states.IDLE           on the attack and dash after some consultation """
		states.DASH:
			return states.IDLE
	return null

func _apply_movement(delta):
	var input_vector=Vector2()
	input_vector.x=int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	input_vector.y=int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
	if not (input_vector.x!=0 and input_vector.y!=0):
		velocity=lerp(velocity,input_vector*movement_speed,pow(delta,0.001))
	velocity=move_and_slide(velocity)

func _unhandled_input(event):
	if event.is_action_pressed("Space"):
		transform_into_beast()

func animate_state(current_mode,current_state):
	pass

func transform_into_beast():
	pass
