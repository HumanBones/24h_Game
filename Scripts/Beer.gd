extends KinematicBody2D


onready var player = get_tree().get_nodes_in_group("Player")

export var speed = 30

var target = Vector2.ZERO
var velocity = Vector2.ZERO
var hit = false
var side = "beer"

func _ready():
	pass
	
func _physics_process(delta):
	target = player[0].position
	
	if player:
		velocity = position.direction_to(target) * speed
	if hit:
		velocity = Vector2.ZERO
		
	velocity = move_and_slide(velocity)
