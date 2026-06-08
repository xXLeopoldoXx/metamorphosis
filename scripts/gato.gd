extends Node2D

# El gato camina de un lado a otro de la pradera (patrulla).
# Si ve a la oruga (cerca y sin esconder) la asusta -> eso lo controla pradera.gd.

@export var velocidad: float = 130.0
@export var limite_izquierdo: float = 900.0
@export var limite_derecho: float = 3400.0

var direccion: int = 1

func _process(delta: float) -> void:
	position.x += velocidad * direccion * delta

	if position.x >= limite_derecho:
		direccion = -1
	elif position.x <= limite_izquierdo:
		direccion = 1

	# Mirar hacia donde camina.
	scale.x = -abs(scale.x) if direccion < 0 else abs(scale.x)
