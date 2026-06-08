extends Node

# Gestor de audio + ajustes (autoload "Audio").
#
#   Audio.reproducir_musica(Audio.AMB_ORUGA)   # música de fondo (loop, continúa entre escenas)
#   Audio.efecto(Audio.SFX_RECOLECCION)        # efecto puntual
#   Audio.set_vol_musica(0.5)                   # 0..1  (lo usa el menú de ajustes)
#   Audio.set_vol_efectos(0.5)
#   Audio.set_pantalla_completa(true)
#
# Los ajustes se guardan en user://ajustes.cfg y se cargan al iniciar.

const AMB_ORUGA: AudioStream = preload("res://assets/musicas_sonidos/amb_oruga.mp3")
const AMB_CRISALIDA: AudioStream = preload("res://assets/musicas_sonidos/amb_crisalida.mp3")
const AMB_MARIPOSA: AudioStream = preload("res://assets/musicas_sonidos/amb_mariposa.mp3")
const MENU: AudioStream = preload("res://assets/musicas_sonidos/menu.mp3")
const FINAL: AudioStream = preload("res://assets/musicas_sonidos/final.mp3")
const SFX_RECOLECCION: AudioStream = preload("res://assets/musicas_sonidos/sfx_recoleccion.mp3")
const SFX_TRANSFORMACION: AudioStream = preload("res://assets/musicas_sonidos/sfx_transformacion.mp3")

const ARCHIVO_AJUSTES := "user://ajustes.cfg"

var vol_musica: float = 0.8
var vol_efectos: float = 0.9
var pantalla_completa: bool = false

var _musica: AudioStreamPlayer
var _sfx: AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	_musica = AudioStreamPlayer.new()
	_musica.bus = "Master"
	add_child(_musica)

	_sfx = AudioStreamPlayer.new()
	_sfx.bus = "Master"
	add_child(_sfx)

	for s in [AMB_ORUGA, AMB_CRISALIDA, AMB_MARIPOSA, MENU]:
		if s is AudioStreamMP3:
			s.loop = true
	for s in [FINAL, SFX_RECOLECCION, SFX_TRANSFORMACION]:
		if s is AudioStreamMP3:
			s.loop = false

	_cargar_ajustes()
	_aplicar_volumen_musica()
	_aplicar_pantalla()

# ----------------------------------------------------------------- Música / SFX
func reproducir_musica(stream: AudioStream, _vol_db_ignorado: float = 0.0) -> void:
	if _musica.stream == stream and _musica.playing:
		return
	_musica.stream = stream
	_aplicar_volumen_musica()
	_musica.play()

func detener_musica() -> void:
	_musica.stop()

func efecto(stream: AudioStream) -> void:
	_sfx.stream = stream
	_sfx.volume_db = linear_to_db(maxf(vol_efectos, 0.0001))
	_sfx.play()

# ----------------------------------------------------------------- Ajustes
func set_vol_musica(v: float) -> void:
	vol_musica = clampf(v, 0.0, 1.0)
	_aplicar_volumen_musica()
	_guardar_ajustes()

func set_vol_efectos(v: float) -> void:
	vol_efectos = clampf(v, 0.0, 1.0)
	_guardar_ajustes()

func set_pantalla_completa(activado: bool) -> void:
	pantalla_completa = activado
	_aplicar_pantalla()
	_guardar_ajustes()

func _aplicar_volumen_musica() -> void:
	_musica.volume_db = linear_to_db(maxf(vol_musica, 0.0001))

func _aplicar_pantalla() -> void:
	var modo := DisplayServer.WINDOW_MODE_FULLSCREEN if pantalla_completa else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(modo)

func _cargar_ajustes() -> void:
	var c := ConfigFile.new()
	if c.load(ARCHIVO_AJUSTES) == OK:
		vol_musica = c.get_value("audio", "musica", vol_musica)
		vol_efectos = c.get_value("audio", "efectos", vol_efectos)
		pantalla_completa = c.get_value("video", "pantalla_completa", pantalla_completa)

func _guardar_ajustes() -> void:
	var c := ConfigFile.new()
	c.set_value("audio", "musica", vol_musica)
	c.set_value("audio", "efectos", vol_efectos)
	c.set_value("video", "pantalla_completa", pantalla_completa)
	c.save(ARCHIVO_AJUSTES)
