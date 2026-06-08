// Mece plantas/follaje de forma realista: la PUNTA se balancea con el viento y
// la BASE queda plantada en el suelo (a diferencia del viento_bg, que deformaba
// toda la imagen como si fuera agua). Se aplica a Sprite2D de plantas.

shader_type canvas_item;

uniform float amplitud : hint_range(0.0, 0.3) = 0.10;
uniform float velocidad : hint_range(0.0, 5.0) = 1.4;
uniform float fase = 0.0;

void vertex() {
	// UV.y = 0 arriba (punta), 1 abajo (base). El factor es 1 en la punta y 0 en la base.
	float punta = 1.0 - UV.y;
	float balanceo = sin(TIME * velocidad + fase) * amplitud * punta;
	VERTEX.x += balanceo * 150.0;
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
}
