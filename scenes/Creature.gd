extends Node2D

onready var map = get_parent().find_node("TileMap")

#Movement stuff
var step_tick = 0.5 #time period for each step
var step_timer = 0 #will help keep track of when we stepped
var path = [] #A set of steps to follow in pathfinding (usually set outside)

#ALCHEMY SPECIFIC STUFF 
#export (PackedScene) var MaterialSymbol #has to create it's own material for picking up
#export (PackedScene) var InstrumentSymbol #has to create it's own material for picking up
var carried_item = null #keeps track of an item the creature is holding
var need_material = true #flag to keep track of creature's behavior, tastks
var need_to_take_material = true # " "
var need_instrument = true # " " 
var need_to_take_instrument = true # " " 
var need_to_start_cooking = true # " "

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#Add color
	$Sprite.modulate = Color(randf(), randf(), randf())
	
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	step_timer = step_timer + delta
	if step_timer > step_tick:
		path_step()
		#update timer
		step_timer = step_timer - step_tick
	
	
	
	pass

#A function that takes a step in the stored path
#Returns true if done with path
#Returns false if not
###GOTTA MAKE SURE THIS MAP VARIABLE GETS SET OUTSIDE TOO....
func path_step():
	
	if path.size() == 0:
		return(true) #Do nothing since there are no more steps left
	
	#Take the first Vector2 in the list
	var next_coords = path.pop_front()
	
	#Move the Creature there (remember to convert to world coords from map)
	position = map.map_to_world(next_coords)
	
	return(false)
	
#	#MAKE SURE TO CARRY ITEMS
#	if carried_item != null:
#		print("carrying item")
#		carried_item.position.y = position.y - carried_item.get_node("Sprite").texture.get_size().y
#		carried_item.position.x = position.x
#		carried_item.draw()
	


#######ALCHEMY FUNCTIONS.... MAYBE GEN PURPOSE????

#Function to pick up an item (put an item above the scene's head)
#the item is a node2d with a sprite as it's first child
#since the function checks the sprite's size
#And moves it up flush with the creature
#The item is already an added child (don't add again)
func pick_up_item(item_node2d):
	
	#put item in correct position
	#item_node2d.position.y = position.y - item_node2d.get_node("Sprite").texture.get_size().y
	#item_node2d.position.x = position.x
	#item_node2d.position.x = 0
	#item_node2d.position.y = 0
	#item_node2d.position.y = - item_node2d.get_node("Sprite").texture.get_size().y
	carried_item = item_node2d.duplicate()
	add_child(carried_item)
	carried_item.position = Vector2(0,-carried_item.get_node("Sprite").texture.get_size().y  )
	carried_item.change_symbol(item_node2d.tile_index)
	#carried_item.update()
	print(carried_item)

