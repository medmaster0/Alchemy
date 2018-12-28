extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#Do the thing with the sprites and the color
	$Sprite.modulate = Color(randf(), randf(), randf())
	$Sprite2.modulate = Color(randf(), randf(), randf())
	$Sprite3.modulate = generate_gold()
	
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


#generate a shade of golden yellow (for the perfume gold topper thingy)
func generate_gold():
	
	var r = 0.7 + rand_range(0,0.3)
	#var g = rand_range(0,r)
	var g = rand_range(0.7,r)
	var b = 0
	
	var gold = Color(r,g,b)
	return(gold)