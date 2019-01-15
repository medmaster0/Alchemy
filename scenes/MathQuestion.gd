extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var buttonPrimCol #keeps track of button prim color
var buttonSecoCol #keeps track of button seco color

var question_data #A dictionary to hold things about the question (num1, num2, operator, answer

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	question_data = generate_question()
	$QuestionLabel.text = question_data["num1"] + question_data["operator"] + question_data["num2"]
	$AnswerLabel.text = question_data["answer"]
	
	var buttonPrimCol = Color(rand_range(0,0.75), rand_range(0,0.75), rand_range(0,0.75))
	buttonSecoCol = MedAlgo.contrastColor(buttonPrimCol)
	#Color the buttons... keys
	for child in $Prim.get_children():
		child.modulate = buttonPrimCol
	for child in $Seco.get_children():
		child.modulate = buttonSecoCol
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#Sets up a new question...
func display_new_question():
	
	question_data = generate_question()
	$QuestionLabel.text = question_data["num1"] + question_data["operator"] + question_data["num2"]
	$AnswerLabel.text = question_data["answer"]

#Generates a simple math problem/question and answer
#REturns a dict of the form
# math_question = {"num1", "num2", "operator", "answer"}... all strings
func generate_question():
	var type = randi()%4 #0123 -> +-x/
	var question #the dictionary to be returned
	match(type):
		0:
			#ADDITION
			var operator = "+" #the STRING
			#Just two random numbers and add them up...
			var num1 = randi()%100
			var num2 = randi()%100
			var answer = num1 + num2
			question = { 
				"num1" : str(num1),
				"num2" : str(num2),
				"operator" : operator,
				"answer" : str(answer)
			}
			
		1:
			#SUBTRACTION
			var operator = "-" #the STRING
			#Just two random numbers and subtract highest?
			var num1 = randi()%100
			var num2 = randi()%100
			var high = max(num1,num2)
			var low = min(num1,num2)
			var answer = high - low
			question = { 
				"num1" : str(high),
				"num2" : str(low),
				"operator" : operator,
				"answer" : str(answer)
			}
			
		2:
			#MULTIPLICATION
			var operator = "x" #the STRING
			#Just two random numers and multiply...
			var num1 = randi()%13
			var num2 = randi()%13
			var answer = num1 * num2
			question = { 
				"num1" : str(num1),
				"num2" : str(num2),
				"operator" : operator,
				"answer" : str(answer)
			}
			
		3:
			#DIVISION
			var operator = "÷" #the STRING
			#Just two random numers, multiply one...
			var num1 = randi()%12 + 1 #number 1 through 12 (don't use 0 here...)
			var num2 = randi()%12 + 1 #number 1 through 12 (don't use 0 here...)
			var product = num1 * num2 #becomes the dividend...
			######Now rearrange for division question...
			### product = num1 * num2 -> num2 = product / num1
			var answer = num2 #product divided by num1
			question = { 
				"num1" : str(product),
				"num2" : str(num1),
				"operator" : operator,
				"answer" : str(answer)
			}
			
	
	return(question)


func _on_Button_pressed():
	input_digit(1)
	pass # replace with function body


func _on_Button2_pressed():
	input_digit(2)
	pass # replace with function body


func _on_Button3_pressed():
	input_digit(3)
	pass # replace with function body


func _on_Button4_pressed():
	input_digit(4)
	pass # replace with function body


func _on_Button5_pressed():
	input_digit(5)
	pass # replace with function body


func _on_Button6_pressed():
	input_digit(6)
	pass # replace with function body


func _on_Button7_pressed():
	input_digit(7)
	pass # replace with function body


func _on_Button8_pressed():
	input_digit(8)
	pass # replace with function body


func _on_Button9_pressed():
	input_digit(9)
	pass # replace with function body

#The Clear button
func _on_Button10_pressed():
	$AnswerLabel.text = ""
	pass # replace with function body

#The Back button
func _on_Button11_pressed():
	$AnswerLabel.text = $AnswerLabel.text.substr(0,$AnswerLabel.text.length() - 1)
	pass # replace with function body

#The Go button to check the answer
func _on_Button12_pressed():
	
	#Perform the check
	if( $AnswerLabel.text == question_data.answer):
		print("yay")
		
		#Generate a new question...
		display_new_question()
	
	pass # replace with function body

#general function to add digit to the string display
func input_digit(digit):
	$AnswerLabel.text = $AnswerLabel.text + str(digit)
	