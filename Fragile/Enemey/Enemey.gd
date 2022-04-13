extends Entity

const NAVIGATION_TILE=0

export (int) var Speed=100
var velocity=Vector2()

onready var los=get_node("Line of sight")
onready var state_timer=get_node("State_timer")

var tilemap=null
var path:Array=[]
var level_navigation=null
var player=null
var player_spoted=false
var target=Vector2()


enum enemy_states{
	IDLE,WANDER,CHASE,ATTACK
}


func _ready():
	randomize()
	yield(get_tree(),"idle_frame")
	var tree=get_tree()
	if tree.has_group("Level_Navigation"):
		level_navigation=tree.get_nodes_in_group("Level_Navigation")[0]
	if tree.has_group("Player"):
		player=tree.get_nodes_in_group("Player")[0]
	if tree.has_group("Tilemap"):
		tilemap=tree.get_nodes_in_group("Tilemap")[0]
	current_state=enemy_states.IDLE


func _physics_process(delta):
	match_states()
	Move_towards(delta)

func match_states():
	match current_state:
		enemy_states.IDLE:
			idle()
		enemy_states.CHASE:
			chase()
		enemy_states.WANDER:
			wander()
		enemy_states.ATTACK:
			attack()

func determine_states():
	match current_state:
		"_":
			pass



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

func wander():
	if level_navigation:
		path=level_navigation.get_simple_path(global_position,target,false)
	if path.size()>0:
		velocity=global_position.direction_to(path[1])*Speed
		if global_position.distance_to(path[0])<16 or tilemap.get_cell(path[0].x,path[0].y)==1:
			path.remove(0)
		if len(path)==1:
			current_state=enemy_states.IDLE
func attack():
	pass


func _on_State_timer_timeout():
	if !player_spoted:
		var random_point_x=(global_position.x+int(rand_range(32*3,32*6)))*choose_random([1,-1])
		var random_point_y=(global_position.y+int(rand_range(32*3,32*6)))*choose_random([1,-1])
		target=Vector2(random_point_x,random_point_y).snapped(Vector2(32,32))
		current_state=choose_random([enemy_states.IDLE,enemy_states.WANDER])

func choose_random(arr:Array):
	randomize()
	arr.shuffle()
	return arr.pop_front()
