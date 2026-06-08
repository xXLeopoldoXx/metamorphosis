extends Node2D

func _ready():
	$VideoStreamPlayer.finished.connect(_on_video_finished)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_go_to_tutorial()

func _on_video_finished():
	_go_to_tutorial()

func _go_to_tutorial():
	get_tree().change_scene_to_file("res://scenes/02_tutorial.tscn")
