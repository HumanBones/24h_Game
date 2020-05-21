extends KinematicBody2D

onready var player = get_tree().get_nodes_in_group("Player")

export var speed = 20
export var hit_interval = 2
export var dmg = 10


var target = Vector2.ZERO
var velocity = Vector2.ZERO
var hit = false
var side
var hit_timer = 0

onready var animTree = $AnimationTree
onready var animState = animTree.get("parameters/playback")

var hit_done = false

func _ready():
	animState.travel("Walk")
	
	
func _physics_process(delta):
	target = player[0].position
	
	if hit_done:
		animState.travel("Walk")
		hit_done = false
	
	if player:
		velocity = position.direction_to(target) * speed
		
	if hit:
		velocity = Vector2.ZERO
		hit_player(delta)
		
	velocity = move_and_slide(velocity)

func hit_player(delta):
	hit_timer += delta
	
	if hit_timer >= hit_interval:
		#print("enemy_punch")
		
		if !hit_done:
			animState.travel("Hit")
			player[0].take_dmg(dmg)
			hit_timer = 0
			hit_done = true
