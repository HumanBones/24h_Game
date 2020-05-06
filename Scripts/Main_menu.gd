extends Control

onready var settings = $"/root/Settings"
onready var sound_button = $Sound_button
onready var info_button = $Info_button
onready var audio = $Menu_audio
onready var controls = $Controls

onready var animTree = $AnimationTree
onready var animState = animTree.get("parameters/playback")

func _physics_process(delta):
	if settings.music_muted:
		audio.stream_paused = true
	else:
		audio.stream_paused = false

	#if controls.visible && !anim_played:
		#animP.play("Controls")
	#else:
		#animP.play("normal_cont")
		

func _on_TextureButton_pressed():
	get_tree().change_scene("res://Sceens/World.tscn")


func _on_Sound_button_pressed():
	if settings.music_muted:
		settings.music_muted = false
	else:
		settings.music_muted = true


func _on_Info_button_pressed():
	if !controls.visible:
		controls.visible = true
		animState.travel("Controls")
	else:
		controls.visible = false
		animState.travel("normal_cont")
