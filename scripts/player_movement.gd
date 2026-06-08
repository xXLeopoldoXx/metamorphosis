extends CharacterBody2D

const SPEED = 300.0
const GRAVITY = 980.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
		if animated_sprite:
			animated_sprite.play("walk")
			animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if animated_sprite:
			animated_sprite.pause()

	move_and_slide()
