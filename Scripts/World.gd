extends Node2D

onready var audio = $AudioStreamPlayer
onready var settings = $"/root/Settings"

var spawner_scene = preload("res://Sceens/Enemy_spawner.tscn")
var beer_spawner_scene = preload("res://Sceens/Beer_spawner.tscn")


func _ready():
	if !settings.music_muted:
		if !audio.is_playing():
			audio.play()
		else:
			audio.stop()
			
	var view_port = get_viewport_rect().size
	var spawn_position = [Vector2(0,view_port.y/2),Vector2(view_port.x, view_port.y/2),Vector2(view_port.x/2,-50)]
	var sides = ["A","D","W"]
	var ray_rotation = [-90,90,0]
	for i in range(3):
		print(spawn_position[i])
	
		var spawner = spawner_scene.instance()
		spawner.position = spawn_position[i]
		spawner.side = sides[i]
		spawner.ray_rotation = ray_rotation[i]
		add_child(spawner)
	
	var beer_spawner = beer_spawner_scene.instance()
	beer_spawner.position = Vector2(view_port.x/2,view_port.y)
	add_child(beer_spawner)
