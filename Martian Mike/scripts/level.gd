extends Node2D

@export var next_level: PackedScene = null
@export var level_time = 5
@export var is_final_level = false

@onready var exit = $exit
@onready var start_position = $start/Marker2D
@onready var death_zone = $death_plane
@onready var hud = $ui_layer/hud
@onready var ui_layer = $ui_layer

var player = null
var timer_node = null
var time_left
var win = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.global_position = start_position.global_position
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		trap.touched_player.connect(_on_saw_trap_touched_player)
	exit.body_entered.connect(on_exit_body_entered)
	death_zone.body_entered.connect(_on_death_plane_body_entered)
	
	time_left = level_time
	hud.set_time_label(time_left)
	timer_node = Timer.new()
	timer_node.name = "level_timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()

func _on_level_timer_timeout():
	if win == false:
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left < 0:
			reset_player()
			time_left = level_time
			hud.set_time_label(time_left)

func _process(delta):
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	elif Input.is_action_pressed("quit"):
		get_tree().quit()


func _on_death_plane_body_entered(body):
	AudioPlayer.play_sfx("hurt")
	body.global_position = start_position.global_position
	body.velocity = Vector2.ZERO

func _on_saw_trap_touched_player():
	reset_player()

func reset_player():
	AudioPlayer.play_sfx("hurt")
	player.global_position = start_position.global_position
	player.velocity = Vector2.ZERO

func on_exit_body_entered(body):
	if body is Player:
		win = true
		if is_final_level or next_level != null:
			player.active = false
			exit.animate()
			await get_tree().create_timer(1.5).timeout
			if is_final_level:
				ui_layer.show_win_screen(true)
			else:
				get_tree().change_scene_to_packed(next_level)
