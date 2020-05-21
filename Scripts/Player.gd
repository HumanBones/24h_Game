extends KinematicBody2D


export var max_hp = 100

export var beer_interval = 1
export var beer_deplet = 10
export var beer_refill = 15

export var pee_refill = 5
export var max_pee = 100

onready var gui = get_tree().get_nodes_in_group("Gui")
onready var ray = $Player_ray
onready var area = $Player_collision/Player_area
onready var audio = $AudioStreamPlayer
onready var hit_audio = preload("res://SFX/16.ogg")

onready var animTree = $AnimationTree
onready var animState = animTree.get("parameters/playback")

var hp = max_hp
var beer_count = 0
var kills_count = 0


var pee = 0
var can_pee = false
var can_stop_pee = false

var pee_timer = 0
var pee_cooldown = 0.2

var pee_expode_t = 0
var pee_explode_int = 5


var max_beer = 100
var beer = max_beer
var beer_timer = 0


var state


enum {
	start,
	normal,
	peeing,
	dead
}



func _ready():
	
	var view_port = get_viewport_rect().size
	self.position = view_port/2
	gui[0].max_hp_update(max_hp)
	gui[0].max_pee_update(pee)
	gui[0].max_beer_update(max_beer)
	state = normal



func _physics_process(delta):

	pee = clamp(pee,0,max_pee)
	beer = clamp(beer,0,max_beer)
	hp = clamp(hp,0,max_hp)
	#print(pee_expode_t)
	
	if hp <= 0 :
		state = dead
	
	if pee >= max_pee/2:
		can_pee = true
		
	if pee >= max_pee:
		pee_explode(delta)
	else:
		pee_expode_t = 0
	
		
	if Input.is_action_pressed("ui_cancel"):
		pass
		#audio.set_stream(hit_audio)
		#if !audio.is_playing():
			#audio.play()
		
	if Input.is_action_pressed("ui_restart"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("ui_accept") && can_pee && state != dead:
		state = peeing
		
	pee += delta * 4
	update_gui_pee(pee)
			
	beer_timer += delta
			
	if beer_timer >= beer_interval:
		depleting_beer()
		if beer <= 0 :
			print("beer_dmg")
			take_dmg(beer_deplet)
	
	
	match state:
		
		normal:
			get_input()
			
		
		peeing:
			pee_timer += delta
			if pee_timer >= pee_cooldown:
				if Input.is_action_pressed("ui_accept"):
					state = normal
					can_pee = false
					pee_timer = 0
					
			pee -= delta * 40
			update_gui_pee(pee)
			#button cooldown <--
			if pee <= 0 :
				state = normal
				can_pee = false
			
		dead:
			self.visible = false
			gui[0].display_dead()
		
	
	var bodies = area.get_overlapping_bodies()
	for bodie in bodies:
		if bodie.name != "Player":
			bodie.hit = true

func pee_explode(delta):
	pee_expode_t += delta
	
	if pee_expode_t >= pee_explode_int:
		state = dead


func kill_enemy(side):
	var collid = ray.get_collider()
	if collid && collid.side == side:
		kills_count += 1
		update_ui_text(kills_count,beer_count)
		collid.queue_free()
	

func drink_beer(side):
	var collid = ray.get_collider()
	print(side)
	if collid && collid.side == side:
		refilling_beer()
		beer_count += 1
		update_ui_text(kills_count,beer_count)
		collid.queue_free()


func update_ui_text(amount1,amount2):
	gui[0].update_labels(amount1,amount2)

func take_dmg(amount):
	print("got_hit")
	if !state == dead:
		animState.travel("Got_hit")
		hp -= amount
		update_gui_hp(hp)
		

func update_gui_hp(hp):
	gui[0].current_hp_update(hp)
	
func update_gui_pee(amount):
	gui[0].current_pee_update(amount)
	
func update_gui_beer(amount):
	gui[0].current_beer_update(amount)


func depleting_beer():
	beer -= beer_deplet
	update_gui_beer(beer)
	beer_timer = 0

func refilling_beer():
	beer += beer_refill
	update_gui_beer(beer)
	refilling_pee()

func refilling_pee():
	pee += pee_refill
	update_gui_pee(pee)

func get_input():
	
	if Input.is_action_just_pressed("ui_left"):
		if ray.rotation_degrees == 90:
			animState.travel("Hit_left")
		ray.rotation_degrees = 90
		#print("left")
	if Input.is_action_just_pressed("ui_up"):
		if ray.rotation_degrees == 180:
			animState.travel("Hit_up")
		print("up")
		ray.rotation_degrees = 180
	if Input.is_action_just_pressed("ui_right"):
		if ray.rotation_degrees == 270:
			animState.travel("Hit_right")
		print("right")
		ray.rotation_degrees = 270
	if Input.is_action_just_pressed("ui_down"):
		if ray.rotation_degrees == 0:
			animState.travel("Take_beer")
			#drink_beer("beer")
		ray.rotation_degrees = 0
		print("down")
