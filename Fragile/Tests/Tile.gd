extends TileMap

var non_navigation_tile=tile_set.get_tiles_ids() 

func _ready():
	print(get_cell(0,0))
