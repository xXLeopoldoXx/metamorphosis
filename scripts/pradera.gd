extends Node2D

# Escena 03 - Pradera. La oruga come hojas y se esconde de los gatos que asoman
# entre los arbustos. Si un gato la ve (en su cono y sin esconder) -> Game Over.
# Cuando se come todas las hojas se abre la salida hacia la crisálida (04).

# Bordes del fondo en coordenadas de mundo (mismo scale que el Sprite del fondo).
const BG_LEFT: int = 0
const BG_RIGHT: int = 4884
const BG_TOP: int = 0
const BG_BOTTOM: int = 2400

@export var hojas_totales: int = 5

var hojas_comidas: int = 0
var escondites: int = 0          # en cuántos arbustos está metida la oruga ahora
var inicio: Vector2 = Vector2.ZERO

@onready var player: CharacterBody2D = $Player
@onready var contador: Label = $UI/Contador
@onready var pista: Label = $UI/Pista

func _ready() -> void:
	Audio.reproducir_musica(Audio.AMB_ORUGA)
	inicio = player.position
	_actualizar_contador()

	# Límites de la cámara (vive dentro del Player) para no ver fuera del fondo.
	var cam: Camera2D = $Player/Camera2D
	if cam:
		cam.limit_left = BG_LEFT
		cam.limit_right = BG_RIGHT
		cam.limit_top = BG_TOP
		cam.limit_bottom = BG_BOTTOM

func comer_hoja() -> void:
	hojas_comidas += 1
	_actualizar_contador()
	if hojas_comidas >= hojas_totales:
		pista.text = "Listo! Ve hacia la luz  ->"

func entrar_escondite(_cuerpo: Node) -> void:
	escondites += 1
	player.modulate = Color(1, 1, 1, 0.45)

func salir_escondite(_cuerpo: Node) -> void:
	escondites = max(escondites - 1, 0)
	if escondites == 0:
		player.modulate = Color(1, 1, 1, 1)

func esta_escondido() -> bool:
	return escondites > 0

# Lo llaman los gatos (señal "jugador_visto") cuando te ven al descubierto.
func _on_gato_visto() -> void:
	Transition.game_over()

func _on_meta_body_entered(body: Node2D) -> void:
	if body.name == "Player" and hojas_comidas >= hojas_totales:
		Transition.change_scene("res://scenes/04_crisalida.tscn")

func _actualizar_contador() -> void:
	if contador:
		contador.text = "Hojas: %d / %d" % [hojas_comidas, hojas_totales]
