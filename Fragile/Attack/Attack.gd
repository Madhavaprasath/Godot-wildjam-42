class_name Attack
extends KinematicBody2D

var attacker_types =["player","enemy"]
var attacker = attacker_types[1]
var damage: int = 0
var stun = 0.5
var destroy_things : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(t_attacker,t_damage,t_stun, t_spawnNode, t_offset = Vector2()):
	attacker = attacker_types[t_attacker]
	damage = t_damage
	stun = t_stun
	set_position(t_spawnNode.get_position() + t_offset)
	set_rotation(t_spawnNode.get_rotation())
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	physics_update(delta)

func physics_update(delta):
	pass

func _hit(body) :
	if (body as Entity == null) :
		_on_hit()
		return
	if (body.type != attacker):
		body.get_hit(self)
		_on_hit()
	pass

func _on_hit():
	queue_free()
	
func _on_Area2D_body_entered(body):
	_hit(body)
