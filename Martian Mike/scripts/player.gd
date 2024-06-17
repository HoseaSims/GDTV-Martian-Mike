extends CharacterBody2D
class_name Player

@export var speed = 200
@export var jump_force = 150
@export var gravity = 500

@onready var animated_sprite = $AnimatedSprite2D
@onready var start_position = get_tree

var active = true

func _physics_process(delta):
	if is_on_floor() == false:
		velocity.y  += gravity * delta
		if velocity.y > 500:
			velocity.y = 500
	var direction = 0
	if active == true:
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			AudioPlayer.play_sfx("jump")
			velocity.y = -jump_force

		direction = Input.get_axis("move_left", "move_right")
		if direction == -1:
			animated_sprite.flip_h = true
		elif direction == 1:
			animated_sprite.flip_h = false
		
		velocity.x = direction * speed
	
	move_and_slide()
	update_animations(direction)

func update_animations(direction):
	if is_on_floor() == true and direction == 0:
		animated_sprite.play("idle")
	elif direction != 0:
		animated_sprite.play("run")
	if velocity.y <= 0 and is_on_floor() == false:
		animated_sprite.play("jump")
	elif velocity.y > 0 and is_on_floor() == false:
		animated_sprite.play("fall")

func died():
	global_position
