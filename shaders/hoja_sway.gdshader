// Hace que la hoja se mueva suave de un lado a otro mientras cae,
// como mecida por la brisa. Se aplica como CanvasItemMaterial a las
// partículas (GPUParticles2D usa el material en cada quad emitido).

shader_type canvas_item;

uniform float amplitud : hint_range(0.0, 0.05) = 0.015;
uniform float velocidad : hint_range(0.0, 6.0) = 2.2;

void vertex() {
	// Cada partícula recibe TIME global, así que sumamos una fase a partir
	// de la posición para que no todas se mezan igual.
	float fase = (VERTEX.x + VERTEX.y) * 0.08;
	float sway = sin(TIME * velocidad + fase) * amplitud;
	VERTEX.x += sway * 80.0;
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
}
