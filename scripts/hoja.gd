extends Area2D

# Una hoja para comer. Al tocarla, avisa a la pradera y desaparece.

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Audio.efecto(Audio.SFX_RECOLECCION)
		var pradera := get_tree().current_scene
		if pradera and pradera.has_method("comer_hoja"):
			pradera.comer_hoja()
		queue_free()
