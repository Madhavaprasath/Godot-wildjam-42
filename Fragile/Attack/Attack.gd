class_name Attack
extends KinematicBody2D

var attacker_types =["player","enemy"]
var attacker = attacker_types[0]
var damage: int = 0
var stun = 0
var destroy_things : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	physics_update(delta)

func physics_update(delta):
	pass

func _hit(body) :
	if (body.type == attacker):
		print("hit")
		body.get_hit(self)
		_on_hit()
	pass

func _on_hit():
	queue_free()
	
func _on_Area2D_body_entered(body):
	body = body as Entity
	if body == null :
		return
	_hit(body)
