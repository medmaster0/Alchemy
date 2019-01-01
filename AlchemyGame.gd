extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (PackedScene) var MaterialSymbol
export (PackedScene) var InstrumentSymbol
export (PackedScene) var SeasonsSymbol
export (PackedScene) var ProcessSymbol

#........................
#These item and material arrays need to be 2D in the form:
# materials[ ypos*map_width + xpos][ stacked_tile_index?? ]
#BUT, if we don't stack them, whatever no stacky bitch
#,.......................

#These array of the form:
# materials[ ypos*map_width + xpos ]
var materials = [] #list of all material tiles on screen. 

# instruments[ ypos*map_width + xpos ]
var instruments = [] #list of all instrument tiles on screen

#Recipe stuff
var processes = [] #list of all process tiles on screen
var recipe_materials = [] #a list of materials required by recipe
var current_instruction_number = 0 #keeps track of which step of the recipe we're on...

#Workshop stuff
var workshop_materials = [] #materials that are dropped off at the workshop area
var workshop_instruments = [] #instruments that are dropped off at the workshop area

#NED TO DERIVE SOME COLORS FOR THE ELEMNTS
var fire_color = Color(0.87,0.1,0.227)
var water_color = Color(0.227,0.1,0.87)
#--- different scheme pattern
var earth_color = Color(0.66,0.87,0.1)
var air_color = Color(1,1,1)

#NEED TO DERIVE COLORS FOR THE 4 ELEMENTAL PROCESSES:
#yellowing, reddening, blackening, whitening
var red_process_color = Color(0.87,0.227,0.1)
var yellow_process_color = Color(0.94,0.79,0.1)
var white_process_color = Color(0.79,0.79,0.79)
var black_process_color = Color(0.3,0.3,0.3)

#STANDARD SCENE GLOBALS
var world_width #the size of the map (in pixels)
var world_height #the size of the map (in pixels)
var map_width #the size of the map (in cells/tiles)
var map_height #the size of the map (in cells/tiles)
var cell_size #the amount of pixels in a cell/tile

func _ready():
	
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#Screen Dimension stuff
	world_width = get_viewport().size.x
	world_height = get_viewport().size.y
	map_width = int($TileMap.world_to_map(Vector2(world_width,0)).x)
	map_height = int($TileMap.world_to_map(Vector2(0,world_height)).y)
	
	cell_size = $TileMap.cell_size #get the cell size for these next calculations
	
	#Initialize item position arrays...
	for i in range(map_height*map_width):
		materials.append(null)
		instruments.append(null)
	
	
	#Create a grid of materials
	for i in range(14): #spanning x dir
		for j in range(21): #spanning y dir
			var temp_position = $TileMap.map_to_world( Vector2(4+i, 8+j) )
			
			#Create a new material there
			var new_material = MaterialSymbol.instance()
			new_material.position = temp_position
			add_child(new_material)
			
			#materials.append(new_material)
			#Put in proper position of item array
			materials[ (8+j)*map_width + (4+i)] = new_material
			
			#DEBUG: change the color
			#new_material.change_color(earth_color)
			#new_material.change_symbol(4)
	
	#Create a grid of instruments
	for i in range(14): #spanning x dir
		for j in range(7): #spanning y dir
			var temp_position = $TileMap.map_to_world( Vector2(24+i, 8+j) )
			
			#Create a new material there
			var new_instrument = InstrumentSymbol.instance()
			new_instrument.position = temp_position
			add_child(new_instrument)
			
			#instruments.append(new_instrument)
			#Put in proper position of item array
			instruments[(8+j)*map_width + (24+i)] =  new_instrument


	#RECIPES
	#Create a column of instructions
	for j in range(5): #spanning y dir
		var temp_position = $TileMap.map_to_world(Vector2(45, 8+(j*2)))
		
		#Create a process symbol there
		var new_process = ProcessSymbol.instance()
		new_process.position = temp_position
		add_child(new_process)
		processes.append(new_process)
		
		#also create a random recipe material next to it there...
		temp_position = temp_position + Vector2(1*cell_size.x,0)
		#Create a new material there
		var new_material = MaterialSymbol.instance()
		new_material.position = temp_position
		add_child(new_material)
		recipe_materials.append(new_material)
		
		#Crreate a label for the colon...? NAHHHXXXXT TO IT
		temp_position = temp_position + Vector2(1*cell_size.x,0)
		var new_colon_label = Label.new()
		new_colon_label.margin_left = temp_position.x + cell_size.x/2.0
		new_colon_label.margin_top = temp_position.y - cell_size.y/2.0
		new_colon_label.text = ":"
		new_colon_label.modulate = Color(0,0,0)
		add_child(new_colon_label)
		
		#DEBUG
		#new_process.change_color(black_process_color)
		
			
			
			

	#DEBUG: 
	print($SeasonSymbol.tile_index)
	#$Creature.path = MedAlgo.find_tile($Creature.position, recipe_materials[0].tile_index, $TileMap, materials, map_width, map_height)
	
	#DEBUG test picking up
#	var pick_item = MaterialSymbol.instance()
#	add_child(pick_item)
#	$Creature.pick_up_item(pick_item)
	
	#DEBUG
#	for i in range(materials.size()):
#		print(materials[i])
#		var t = Timer.new()
#		t.set_wait_time(.3)
#		t.set_one_shot(true)
#		self.add_child(t)
#		t.start()
#		yield(t, "timeout")
	
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	#Constantly checking what state the creature is in
	if $Creature.path.size() == 0:
		
		#Check if need to go to material
		if $Creature.need_material == true:
			$Creature.path = MedAlgo.find_tile($Creature.position, recipe_materials[0].tile_index, $TileMap, materials, map_width, map_height)
			#check if the search was successful
			if $Creature.path.size()!=0:
				$Creature.need_material = false
			return
			
		
		#Check if need to pick up and take material
		if $Creature.need_to_take_material == true:
			
			#Pick up the material
			var temp_coords = $TileMap.world_to_map($Creature.position) #figure out which map coords were at
			$Creature.pick_up_item( materials[temp_coords.y*map_width + temp_coords.x] )#pick up the item that is at this creature's location
			materials[temp_coords.y*map_width + temp_coords.x].queue_free() #free from this tree
			materials[temp_coords.y*map_width + temp_coords.x] = null #remove from listings
			
			#Find a path to the drop off location,,,
			temp_coords = processes[current_instruction_number].position #identify the location to go to
			temp_coords = temp_coords + $TileMap.map_to_world(Vector2(4,0)) #4 to the right of it
			$Creature.path = MedAlgo.find_path($Creature.position, temp_coords, $TileMap)
			#Check if the search was succsefful
			if $Creature.path.size()!=0:
				$Creature.need_to_take_material = false
			return
			
		#Check if need to go to instrument (and drop off material)
		if $Creature.need_instrument == true:
			#DROPPING CARRIED ITEM
			#make new item based on the carried item, then delete creature's
			var map_material = MaterialSymbol.instance()
			add_child(map_material)
			map_material.change_symbol($Creature.carried_item.tile_index)
			map_material.position = $Creature.position
			#(delete the old one)
			$Creature.carried_item.queue_free()
			$Creature.carried_item = null
			
			#Find path to random instrument
			var instrument_type = randi()%8
			$Creature.path = MedAlgo.find_tile($Creature.position, instrument_type, $TileMap, instruments, map_width, map_height)
			#check if the search was successful
			if $Creature.path.size()!=0:
				#Set flag so this doesn't happen again...
				$Creature.need_instrument = false
			return
			
			#$Creature.need_instrument = false
		
		#Check if need to pick up instrument and take it
		if $Creature.need_to_take_instrument == true:
			#Pick up the instrument
			var temp_coords = $TileMap.world_to_map($Creature.position) #figure out which map coords were at
			$Creature.pick_up_item( instruments[temp_coords.y*map_width + temp_coords.x] )#pick up the item that is at this creature's location
			instruments[temp_coords.y*map_width + temp_coords.x].queue_free() #free from this tree
			instruments[temp_coords.y*map_width + temp_coords.x] = null #remove from listing
			
			#Find a path to the drop off location,,,
			temp_coords = processes[current_instruction_number].position #identify the location to go to
			temp_coords = temp_coords + $TileMap.map_to_world(Vector2(5,0)) #4 to the right of it
			$Creature.path = MedAlgo.find_path($Creature.position, temp_coords, $TileMap)
			#Check if the search was succsefful
			if $Creature.path.size()!=0:
				#Set flag so this doesn't happen again...
				$Creature.need_to_take_instrument = false
			return
			
		
		#Check if need to drop off instrument and start cooking
		if $Creature.need_to_start_cooking ==  true:
			#DROPPING CARRIED ITEM
			#make new item based on the carried item, then delete creature's
			var map_instrument = InstrumentSymbol.instance()
			add_child(map_instrument)
			map_instrument.change_symbol($Creature.carried_item.tile_index)
			map_instrument.position = $Creature.position
			#(delete the old one)
			$Creature.carried_item.queue_free()
			$Creature.carried_item = null
			
			#Put Creaturre in position
			$Creature.position = $Creature.position + Vector2(cell_size.x,0)
			
			
			#Set flag so this doesn't happen again...
			$Creature.need_to_start_cooking = false
			
			
		
		#print("happens - (Shouldn'tn't)")
		

	pass
