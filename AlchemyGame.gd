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
var instruments = [] #list of all instrument tiles on screen

var processes = [] #list of all process tiles on screen

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


func _ready():
	
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#Screen Dimension stuff
	var world_width = get_viewport().size.x
	var world_height = get_viewport().size.y
	var map_width = int($TileMap.world_to_map(Vector2(world_width,0)).x)
	var map_height = int($TileMap.world_to_map(Vector2(0,world_height)).y)
	
	var cell_size = $TileMap.cell_size #get the cell size for these next calculations
	
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
		
		#DEBUG
		#new_process.change_color(black_process_color)
		
			
			
			

	#DEBUG: SETP creature path...
	$Creature.path = MedAlgo.find_tile($Creature.position, 2, $TileMap, materials, map_width, map_height)
	#$Creature.path = MedAlgo.find_path($Creature.position, Vector2(10,10), $TileMap)
	
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

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
