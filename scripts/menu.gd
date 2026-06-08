extends Control

# Menú principal (escena 00). Botones: Jugar / Ajustes / Salir.
# Jugar -> escena 01 (intro). Ajustes: volumen música, efectos y pantalla completa.

@onready var centro_menu: Control = %CentroMenu
@onready var centro_ajustes: Control = %CentroAjustes
@onready var slider_musica: HSlider = %SliderMusica
@onready var slider_efectos: HSlider = %SliderEfectos
@onready var check_pantalla: CheckButton = %CheckPantalla

func _ready() -> void:
	Audio.reproducir_musica(Audio.MENU)
	centro_ajustes.visible = false
	centro_menu.visible = true

	# Cargar valores actuales en los controles.
	slider_musica.value = Audio.vol_musica
	slider_efectos.value = Audio.vol_efectos
	check_pantalla.button_pressed = Audio.pantalla_completa

func _on_jugar_pressed() -> void:
	Audio.fade_out_musica(Transition.DURACION)
	Transition.change_scene("res://scenes/01_intro.tscn")

func _on_ajustes_pressed() -> void:
	centro_menu.visible = false
	centro_ajustes.visible = true

func _on_volver_pressed() -> void:
	centro_ajustes.visible = false
	centro_menu.visible = true

func _on_salir_pressed() -> void:
	get_tree().quit()

func _on_slider_musica_value_changed(valor: float) -> void:
	Audio.set_vol_musica(valor)

func _on_slider_efectos_value_changed(valor: float) -> void:
	Audio.set_vol_efectos(valor)

func _on_slider_efectos_drag_ended(_cambio: bool) -> void:
	# Pequeño sonido de prueba al soltar el control de efectos.
	Audio.efecto(Audio.SFX_RECOLECCION)

func _on_check_pantalla_toggled(activado: bool) -> void:
	Audio.set_pantalla_completa(activado)
