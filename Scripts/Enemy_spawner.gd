extends Node2D

onready var world = get_tree().get_nodes_in_group("World")
onready var area = $Enemy_spawn_area
onready var area_col = $Enemy_spawn_area/Enemy_area_col

var enemy_scene = preload("res://Sceens/Enemy.tscn")


var spawn_interaval = 0

var spawn_timer = 0
var side
var ray_rotation = 0
var enemy_line = 0
var enemy_spawn_cap = 4


func _ready():
	area_col.shape.length = 96
	area_col.rotation_degrees = ray_rotation


func _physics_process(delta):
	
	var enemy_coll = area.get_overlapping_bodies()
	enemy_line = enemy_coll.size()
	if side == "W":
		enemy_spawn_cap = 3
	
	
	randomize()
	spawn_interaval = rand_range(3,10)
	
	spawn_timer += delta
	
	if spawn_timer >= spawn_interaval:
		if enemy_line <= enemy_spawn_cap:
			spawn_enemy()
			spawn_timer = 0

func spawn_enemy():
	#print("enemy spawn")
	var enemy = enemy_scene.instance()
	enemy.position = position
	enemy.side = side
	world[0].add_child(enemy)
