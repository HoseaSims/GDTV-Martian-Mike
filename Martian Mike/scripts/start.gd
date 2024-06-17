extends StaticBody2D

@onready var start_pos = $Marker2D

func _ready():
	get_spawn_pos()

func get_spawn_pos():
	return start_pos.global_position
