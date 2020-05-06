extends Node2D



var spawn_interaval = 0
var spawn_timer = 0
var beer_line = 0

var beer_scene = preload("res://Sceens/Beer.tscn")
onready var world = get_tree().get_nodes_in_group("World")
onready var area = $Beer_spawn_area


func _ready():
	pass

func _physics_process(delta):
	
	var beer_coll = area.get_overlapping_bodies()
	beer_line = beer_coll.size()
	
	randomize()
	spawn_interaval = rand_range(1,5)
	
	
	spawn_timer += delta
	
	if spawn_timer >= spawn_interaval:
		if beer_line <= 2:
			spawn_beer()
			spawn_timer = 0

func spawn_beer():
	#print("beer_spawn")
	var beer = beer_scene.instance()
	beer.position = self.position
	world[0].add_child(beer)
