extends Node2D

# Escena 03 - Pradera. La oruga come hojas y se esconde del gato entre los arbustos.
# Cuando se come todas las hojas se abre la salida hacia la crisálida (04).

@export var hojas_totales: int = 5

var hojas_comidas: int = 0
var escondites: int = 0          # en cuántos arbustos está metida la oruga ahora
var inicio: Vector2 = Vector2.ZERO

@onready var player: CharacterBody2D = $Player
@onready var gato: Node2D = $Gato
@onready var contador: Label = $UI/Contador
@onready var pista: Label = $UI/Pista

func _ready() -> void:
	inicio = player.position
	_actualizar_contador()

func _process(_delta: float) -> void:
	# El gato atrapa a la oruga si está cerca (en horizontal) y NO está escondida.
	var distancia_x: float = abs(player.global_position.x - gato.global_position.x)
	if escondites <= 0 and distancia_x < 220.0:
		_atrapada()

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

func _atrapada() -> void:
	# Susto: la oruga vuelve al inicio.
	player.position = inicio
	player.velocity = Vector2.ZERO

func _on_meta_body_entered(body: Node2D) -> void:
	if body.name == "Player" and hojas_comidas >= hojas_totales:
		get_tree().change_scene_to_file("res://scenes/04_crisalida.tscn")

func _actualizar_contador() -> void:
	if contador:
		contador.text = "Hojas: %d / %d" % [hojas_comidas, hojas_totales]
