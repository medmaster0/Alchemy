extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var tile_index #the index of which child/tile is visible

#NEED TO DERIVE COLORS FOR THE 4 ELEMENTAL PROCESSES:
#yellowing, reddening, blackening, whitening
var red_process_color = Color(0.87,0.227,0.1)
var yellow_process_color = Color(0.94,0.79,0.1)
var white_process_color = Color(0.79,0.79,0.79)
var black_process_color = Color(0.3,0.3,0.3)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	tile_index = randi()%get_children().size()
	#get_child(tile_index).visible = true
	change_symbol(tile_index)
	
	#need to color black
	change_color(Color(0,0,0))
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func change_symbol(new_tile_index):
	
	#Turn off old one...
	var temp_color = get_child(tile_index).modulate #save the color
	get_child(tile_index).visible = false
	
	#Cahgen to new one
	tile_index = new_tile_index
	get_child(tile_index).visible = true
	get_child(tile_index).modulate = temp_color
	


#function to change the color of the proper tile
func change_color(color):
	get_child(tile_index).modulate = color
	

#function to change the symbol color according to a process code
#Process Codes found in ProcessSymbol scene and script:
# 0 - blackening
# 1 - whitening
# 2 - yellowing
# 3 - reddening
func change_process_color(process_code):
	match(process_code):
		0:
			change_color(black_process_color)
		1:
			change_color(white_process_color)
		2:
			change_color(yellow_process_color)
		3:
			change_color(red_process_color)

