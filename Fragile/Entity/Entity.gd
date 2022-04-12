class_name Entity
extends KinematicBody2D

enum states{
	IDLE,MOVEMENT,ATTACK,DASH,STUN
}
var current_state=states.IDLE
var types = ["player","enemy"]
var type = types[1]
export (String) var myAttack
export (int) var hp = 1



func _process(delta):
	if hp <= 0:
		queue_free()
# Called when the node enters the scene tree for the first time.
func _ready():
	$StunTime.connect("timeout",self,"_on_StunTime_timeout")
	pass


func get_hit(attack):
	hp = hp - attack.damage
	current_state = states.STUN
	$StunTime.wait_time = attack.stun
	$StunTime.start();
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_StunTime_timeout():
	current_state = states.IDLE
