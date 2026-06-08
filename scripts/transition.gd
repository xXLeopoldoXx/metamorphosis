extends Node

# Singleton de transiciones + Game Over.
#
#   Transition.change_scene("res://scenes/03_pradera.tscn")  -> fundido y carga
#   Transition.game_over()                                   -> "Te atraparon" + reintentar

const DURACION: float = 0.55

var _layer: CanvasLayer
var _rect: ColorRect
var _go: Control          # panel de game over
var _cambiando: bool = false

func _ready() -> void:
	# Funciona aunque el árbol esté en pausa (para el Game Over).
	process_mode = Node.PROCESS_MODE_ALWAYS

	_layer = CanvasLayer.new()
	_layer.layer = 100
	add_child(_layer)

	_rect = ColorRect.new()
	_rect.color = Color(0, 0, 0, 0)
	_rect.anchor_right = 1.0
	_rect.anchor_bottom = 1.0
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_layer.add_child(_rect)

	_construir_game_over()

# ---------------------------------------------------------------- Cambio de escena
func change_scene(ruta: String) -> void:
	if _cambiando:
		return
	_cambiando = true

	var tw_out := create_tween()
	tw_out.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw_out.tween_property(_rect, "color:a", 1.0, DURACION)
	await tw_out.finished

	var err := get_tree().change_scene_to_file(ruta)
	if err != OK:
		push_error("Transition: no se pudo cargar %s (error %d)" % [ruta, err])

	await get_tree().process_frame

	var tw_in := create_tween()
	tw_in.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw_in.tween_property(_rect, "color:a", 0.0, DURACION)
	await tw_in.finished

	_cambiando = false

# ---------------------------------------------------------------- Game Over
func game_over() -> void:
	if _cambiando:
		return
	_cambiando = true
	# Instantáneo (sin tween) porque el árbol queda en pausa y un await podría colgarse.
	_rect.color.a = 0.8
	_go.visible = true
	get_tree().paused = true

func _reintentar() -> void:
	_go.visible = false
	_rect.color.a = 0.0
	get_tree().paused = false
	_cambiando = false
	get_tree().reload_current_scene()

func _construir_game_over() -> void:
	_go = Control.new()
	_go.anchor_right = 1.0
	_go.anchor_bottom = 1.0
	_go.visible = false
	_layer.add_child(_go)

	var vbox := VBoxContainer.new()
	vbox.anchor_left = 0.5
	vbox.anchor_right = 0.5
	vbox.anchor_top = 0.5
	vbox.anchor_bottom = 0.5
	vbox.offset_left = -300.0
	vbox.offset_right = 300.0
	vbox.offset_top = -120.0
	vbox.offset_bottom = 120.0
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 30)
	_go.add_child(vbox)

	var titulo := Label.new()
	titulo.text = "¡Te atrapó el gato!"
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.add_theme_font_size_override("font_size", 56)
	titulo.add_theme_color_override("font_color", Color(1, 0.85, 0.85))
	vbox.add_child(titulo)

	var boton := Button.new()
	boton.text = "Reintentar"
	boton.custom_minimum_size = Vector2(260, 70)
	boton.add_theme_font_size_override("font_size", 32)
	boton.pressed.connect(_reintentar)
	vbox.add_child(boton)
