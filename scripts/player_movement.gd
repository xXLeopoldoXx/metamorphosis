extends CharacterBody2D

# Movimiento de la oruga. Valores grandes porque el mundo está escalado ~5-7x
# (si no, se siente "bajo el agua"). Con aceleración/fricción para que arranque
# y frene con peso, y la animación va sincronizada a la velocidad real.

const SPEED: float = 1250.0       # velocidad máxima horizontal
const ACCEL: float = 7000.0       # qué tan rápido alcanza la velocidad
const FRICTION: float = 9000.0    # qué tan rápido se detiene
const GRAVITY: float = 3200.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var pasos: AudioStreamPlayer = get_node_or_null("Pasos")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	var direccion := Input.get_axis("ui_left", "ui_right")
	if direccion != 0.0:
		velocity.x = move_toward(velocity.x, direccion * SPEED, ACCEL * delta)
		sprite.flip_h = direccion < 0.0
	else:
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)

	_animar()
	move_and_slide()

func _animar() -> void:
	var v := absf(velocity.x)
	if v > 25.0:
		if sprite.animation != "caminar":
			sprite.play("caminar")
		# La animación va más rápida cuanto más rápido se mueve (no "patina").
		sprite.speed_scale = clampf(v / 700.0, 0.6, 2.2)
		if pasos and not pasos.playing:
			pasos.play()
	else:
		sprite.speed_scale = 1.0
		if sprite.animation != "idle":
			sprite.play("idle")
		if pasos and pasos.playing:
			pasos.stop()
