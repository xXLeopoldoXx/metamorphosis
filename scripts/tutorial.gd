extends Node2D

# Escena 02 - Tutorial. La oruga aprende a moverse izquierda / derecha.
# Cuando el jugador llega a la "Meta" (lado derecho) pasamos a la pradera (03).

func _on_meta_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://scenes/03_pradera.tscn")
