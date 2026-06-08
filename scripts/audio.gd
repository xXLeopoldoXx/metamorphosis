extends Node

# Gestor de audio global (autoload "Audio").
#
#   Audio.reproducir_musica(Audio.AMB_ORUGA)   # música de fondo (loop, continúa entre escenas)
#   Audio.efecto(Audio.SFX_RECOLECCION)        # efecto puntual

const AMB_ORUGA: AudioStream = preload("res://assets/musicas_sonidos/amb_oruga.mp3")
const AMB_CRISALIDA: AudioStream = preload("res://assets/musicas_sonidos/amb_crisalida.mp3")
const AMB_MARIPOSA: AudioStream = preload("res://assets/musicas_sonidos/amb_mariposa.mp3")
const MENU: AudioStream = preload("res://assets/musicas_sonidos/menu.mp3")
const FINAL: AudioStream = preload("res://assets/musicas_sonidos/final.mp3")
const SFX_RECOLECCION: AudioStream = preload("res://assets/musicas_sonidos/sfx_recoleccion.mp3")
const SFX_TRANSFORMACION: AudioStream = preload("res://assets/musicas_sonidos/sfx_transformacion.mp3")

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

	# Las ambientales se repiten en bucle; los efectos no.
	for s in [AMB_ORUGA, AMB_CRISALIDA, AMB_MARIPOSA, MENU]:
		if s is AudioStreamMP3:
			s.loop = true
	for s in [FINAL, SFX_RECOLECCION, SFX_TRANSFORMACION]:
		if s is AudioStreamMP3:
			s.loop = false

func reproducir_musica(stream: AudioStream, vol_db: float = -8.0) -> void:
	# Si ya suena esa misma música, no la reinicia (continúa entre escenas).
	if _musica.stream == stream and _musica.playing:
		return
	_musica.stream = stream
	_musica.volume_db = vol_db
	_musica.play()

func detener_musica() -> void:
	_musica.stop()

func efecto(stream: AudioStream, vol_db: float = -2.0) -> void:
	_sfx.stream = stream
	_sfx.volume_db = vol_db
	_sfx.play()
