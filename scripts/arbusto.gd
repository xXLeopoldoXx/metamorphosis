extends Area2D

# Arbusto: zona donde la oruga se puede esconder del gato.

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var pradera := get_tree().current_scene
		if pradera and pradera.has_method("entrar_escondite"):
			pradera.entrar_escondite(body)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		var pradera := get_tree().current_scene
		if pradera and pradera.has_method("salir_escondite"):
			pradera.salir_escondite(body)
