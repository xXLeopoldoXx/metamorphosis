extends Node2D

# Gato acechador. Vive escondido entre los arbustos y CADA CIERTO TIEMPO
# asoma la cara. Mientras "vigila", muestra un cono de visión rojo: si la oruga
# está dentro de su rango horizontal y NO escondida en un arbusto -> te ve y pierdes.
#
# Emite "jugador_visto" para que la pradera dispare el Game Over.

signal jugador_visto

@export var t_oculto: float = 2.2     # segundos escondido
@export var t_asomar: float = 0.5     # animación de asomarse
@export var t_vigilar: float = 1.6    # segundos mirando (PELIGRO)
@export var desfase: float = 0.0      # retraso inicial (para desincronizar varios gatos)
@export var rango: float = 450.0      # alcance horizontal de su visión (mundo)

enum Estado { OCULTO, ASOMANDO, VIGILANDO }

var _estado: int = Estado.OCULTO
var _t: float = 0.0

@onready var cara: AnimatedSprite2D = $Cara
@onready var cono: Polygon2D = $Cono

func _ready() -> void:
	_entrar_oculto()
	_t += desfase

func _process(delta: float) -> void:
	if _estado == Estado.VIGILANDO:
		_vigilar_jugador()

	_t -= delta
	if _t > 0.0:
		return

	match _estado:
		Estado.OCULTO:
			_entrar_asomando()
		Estado.ASOMANDO:
			_entrar_vigilando()
		Estado.VIGILANDO:
			_entrar_oculto()

func _vigilar_jugador() -> void:
	var escena := get_tree().current_scene
	if escena == null:
		return
	var p := escena.get_node_or_null("Player") as Node2D
	if p == null:
		return
	if abs(p.global_position.x - global_position.x) < rango:
		var oculto: bool = escena.has_method("esta_escondido") and escena.esta_escondido()
		if not oculto:
			emit_signal("jugador_visto")

func _entrar_oculto() -> void:
	_estado = Estado.OCULTO
	_t = t_oculto
	cara.visible = false
	cono.visible = false

func _entrar_asomando() -> void:
	_estado = Estado.ASOMANDO
	_t = t_asomar
	cara.visible = true
	cara.frame = 0
	cara.play("asomar")
	cono.visible = false

func _entrar_vigilando() -> void:
	_estado = Estado.VIGILANDO
	_t = t_vigilar
	cono.visible = true
