extends Control

onready var settings = $"/root/Settings"
onready var world = get_tree().get_nodes_in_group("World")

onready var health_bar = $CanvasLayer/Health
onready var hp_player = $CanvasLayer/Health/AnimationPlayer

onready var beer_bar = $CanvasLayer/Beer
onready var beer_player = $CanvasLayer/Beer/AnimationPlayer

onready var pee_player = $CanvasLayer/Pee/AnimationPlayer
onready var pee_bar = $CanvasLayer/Pee

onready var beer_lab = $CanvasLayer/Beer_label
onready var kills_lab = $CanvasLayer/Kills_label

onready var dead_text = $CanvasLayer/Dead
onready var dead_animP = $CanvasLayer/Dead/AnimationPlayer
onready var again_button = $CanvasLayer/Play_again

onready var audio_player = $AudioStreamPlayer

func _physics_process(delta):
	
	if health_bar.value <= health_bar.max_value/4:
		hp_player.play("Hp_low")
	
	else:
		hp_player.play("Idle")
	
	if beer_bar.value <= beer_bar.max_value/3:
		beer_player.play("Beer_low")
		
	else:
		beer_player.play("Idle")
	
	if pee_bar.value >= pee_bar.max_value*0.8:
		pee_player.play("Pee_full")
		
	else:
		pee_player.play("Idle")
		

func display_dead():
	
	dead_text.visible = true
	again_button.visible = true
	dead_animP.play("dead")
	if !settings.music_muted:
		world[0].audio.stop()
		if !audio_player.is_playing():
			audio_player.play()
		

func update_labels(amount1,amount2):
	kills_lab.text = str(amount1)
	beer_lab.text = str(amount2)


func max_hp_update(amount):
	health_bar.value = amount

func current_hp_update(amount):
	health_bar.value = amount


func max_beer_update(amount):
	beer_bar.value = amount
	
func current_beer_update(amount):
	beer_bar.value = amount


func max_pee_update(amount):
	pee_bar.value = amount
	
func current_pee_update(amount):
	pee_bar.value = amount


func _on_Play_again_pressed():
	get_tree().reload_current_scene()
