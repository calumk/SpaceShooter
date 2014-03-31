
extends Node2D

var bullet = preload("res://bullet.xml")
var laserCount = 0

var rock = preload("res://rock.xml")
var rockCount = 0

var score = 0
var rockArray = []
var laserArray = []
var gameover = true

var lasttime = OS.get_unix_time()


var pressed = false
func _ready():
	# Initalization here
	get_node("instruction").set_opacity(0)
	set_process(true)
	

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
			restart()
	if gameover == true:
		get_node("score").set_text("Game Over")
		get_node("instruction").set_opacity(1)
	else:
		var shipPos = get_node("ship").get_pos()
		
		
		if Input.is_action_pressed("Space"):
			if pressed == false:
				fire()
				pressed = true
		else:
			pressed = false
			
		if Input.is_action_pressed("ui_left"):
			shipPos.x = shipPos.x - 200 * delta
			
		if Input.is_action_pressed("ui_right"):
			shipPos.x = shipPos.x + 200 * delta
			
		get_node("ship").set_pos(shipPos)
		
		
		
		
		var laserid = 0
		for laser in laserArray:
			var laserPos = get_node(laser).get_pos()
			laserPos.y = laserPos.y - 400 * delta
			get_node(laser).set_pos(laserPos)
			if laserPos.y < 0:
				remove_and_delete_child(get_node(laser))
				laserArray.remove(laserid)
			laserid = laserid+1
				
				
				
		if OS.get_unix_time() - lasttime >= 1:
			newRock()
			lasttime = OS.get_unix_time()
			
		var rockid = 0
		for rock in rockArray:
			var rockRot = get_node(rock).get_rot()
			var rockPos = get_node(rock).get_pos()
			rockPos.y = rockPos.y + 300 * delta
			get_node(rock).set_pos(rockPos)
			get_node(rock).set_rot(rockRot + 1*delta)
			if rockPos.y > 568:
				remove_and_delete_child(get_node(rock))
				rockArray.remove(rockid)
			
			var laserid = 0
			for laser in laserArray:
				var laserPos = get_node(laser).get_pos()
				if rockPos.y > laserPos.y:
					if (rockPos.x - 20) < (laserPos.x):
						if (rockPos.x + 20) > (laserPos.x):
							
							score = score + 1
							get_node("score").set_text(str(score))
							remove_and_delete_child(get_node(rock))
							remove_and_delete_child(get_node(laser))
							rockArray.remove(rockid)
							laserArray.remove(laserid)
				laserid = laserid + 1
			rockid = rockid + 1
			
			if rockPos.y > 485:
				var shipPos = get_node("ship").get_pos()
				if rockPos.x + 20 > shipPos.x - 40:
					if rockPos.x - 20 < shipPos.x + 40:
						gameover = true
	
	
var lastlaser = OS.get_unix_time()
func fire():
	var bullet_instance = bullet.instance()
	bullet_instance.set_name("laser"+str(laserCount))
	add_child(bullet_instance)
	var laserPos = get_node("ship").get_pos()
	laserPos.y = laserPos.y - 50
	get_node("laser"+str(laserCount)).set_pos(laserPos)
	laserArray.push_back("laser"+str(laserCount))
	laserCount = laserCount + 1
	lastlaser = OS.get_unix_time()
		
		
func newRock():
	var rock_instance = rock.instance()
	rock_instance.set_name("rock"+str(rockCount))
	add_child(rock_instance)
	var rockPos = get_node("rock"+str(rockCount)).get_pos()
	rockPos.x = rand_range(0, 320)
	rockPos.y = -5
	get_node("rock"+str(rockCount)).set_pos(rockPos)
	rockArray.push_back("rock"+str(rockCount))
	rockCount = rockCount + 1
	print(rockArray)

func restart():
	get_node("splash").set_opacity(0)
	for rock in rockArray:
		remove_and_delete_child(get_node(rock))
	for laser in laserArray:
		remove_and_delete_child(get_node(laser))
	rockArray.clear()
	laserArray.clear()
	score = 0
	get_node("score").set_text(str(score))
	var shipPos = get_node("ship").get_pos()
	shipPos.x = 160
	get_node("ship").set_pos(shipPos)
	get_node("instruction").set_opacity(0)
	gameover = false
	
	