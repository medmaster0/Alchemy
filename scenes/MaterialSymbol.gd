extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var tile_index #the index of which child/tile is visible

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	tile_index = randi()%get_children().size()
	get_child(tile_index).visible = true
	
	#need to color black
	change_color(Color(0,0,0))
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func change_symbol(new_tile_index):
	
	#Turn off old one...
	get_child(tile_index).visible = false
	
	#Cahgen to new one
	tile_index = new_tile_index
	get_child(tile_index).visible = true
	


#function to change the color of the proper tile
func change_color(color):
	get_child(tile_index).modulate = color