extends Entity


export (int) var Speed=100
var velocity=Vector2()

onready var los=get_node("Line of sight")
onready var check_surrounding=get_node("Check_Surrounding")
onready var state_timer=get_node("State timer")

var path:Array=[]
var level_navigation=null
var player=null
var player_spoted=false

enum enemy_states{
	IDLE,WANDER,CHASE,ATTACK
}


func _ready():
	current_state=enemy_states.IDLE
	yield(get_tree(),"idle_frame")
	var tree=get_tree()
	if tree.has_group("Level_Navigation"):
		level_navigation=tree.get_nodes_in_group("Level_Navigation")[0]
	if tree.has_group("Player"):
		player=tree.get_nodes_in_group("Player")[0]
	


func _physics_process(delta):
	match_states()
	Move_towards(delta)

func match_states():
	match current_state:
		enemy_states.IDLE:
			idle()
		enemy_states.CHASE:
			chase()

func determine_states():
	match current_state:
		enemy_states.IDLE:
			if player_spoted:
				return enemy_states.CHASE
			elif !player_spoted && velocity!=Vector2():
				return enemy_states.WANDER 
	return null
func navigate():
	if path.size()>0:
		velocity=global_position.direction_to(path[1])*Speed
		
		if global_position==path[0]:
			path.pop_front()


func check_player_in_detection():
	var collider=los.get_collider()
	if collider and collider.is_in_group("Player"):
		player_spoted=true
		return true
	return false



func generate_path():
	if level_navigation!=null and player!=null:
		path=level_navigation.get_simple_path(global_position,player.global_position,false)

func Move_towards(delta):
	velocity=move_and_slide(velocity)


"""States Functions"""

func idle():
	velocity=Vector2()


func chase():
	if player and level_navigation:
		los.look_at(player.global_position)
		check_player_in_detection()
		if player_spoted:
			generate_path()
			navigate()