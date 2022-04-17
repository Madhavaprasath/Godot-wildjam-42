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


func _ready():
	$StunTime.connect("timeout",self,"_on_StunTime_timeout")
	pass


func get_hit(attack):
	if type == types[1]:
		get_tree().get_nodes_in_group("Player")[0].power_gauge += 1
	hp = hp - attack.damage
	current_state = states.STUN
	$StunTime.wait_time = attack.stun
	$StunTime.start();



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_StunTime_timeout():
	current_state = states.IDLE
