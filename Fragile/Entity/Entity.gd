class_name Entity
extends KinematicBody2D
enum states{
	IDLE,MOVEMENT,ATTACK,DASH,STUN
}
var current_state=states.IDLE
var stun_duration = 0
var types = ["player","enemy"]
var type = types[0]
var myAttack
export (int) var hp = 1

func _process(delta):
	if hp <= 0:
		queue_free()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_hit(attack ):
	hp = hp - attack.damage
	current_state = states.STUN
	stun_duration = attack.stun

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
