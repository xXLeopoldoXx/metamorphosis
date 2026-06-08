extends Node2D

# Escena 02 - Tutorial. La oruga aprende a moverse izquierda / derecha.
# La camara vive dentro del Player (sigue automatico) y aqui le fijamos los
# limites para que nunca muestre fuera del fondo (sin partes grises/negras).

# Bordes del fondo en coordenadas de mundo. Si cambias el scale del Sprite "Fondo",
# actualiza tambien estos valores.
const BG_LEFT: int = 0
const BG_RIGHT: int = 4884    # 640 * 7.6296864 ≈ 4884 (ancho del bg estirado)
const BG_TOP: int = 0
const BG_BOTTOM: int = 2400   # 480 * 5

func _ready() -> void:
	Audio.reproducir_musica(Audio.AMB_ORUGA)

	var cam: Camera2D = $Player/Camera2D
	if cam:
		cam.limit_left = BG_LEFT
		cam.limit_right = BG_RIGHT
		cam.limit_top = BG_TOP
		cam.limit_bottom = BG_BOTTOM

func _on_meta_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Transition.change_scene("res://scenes/03_pradera.tscn")
