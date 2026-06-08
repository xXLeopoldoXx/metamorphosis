// Viñeteado: oscurece sutilmente los bordes de la pantalla para dar profundidad
// y un look más cinematográfico. Se aplica a un ColorRect a pantalla completa.

shader_type canvas_item;

uniform float fuerza : hint_range(0.0, 1.0) = 0.38;
uniform float radio : hint_range(0.1, 1.2) = 0.85;
uniform float suavidad : hint_range(0.05, 1.0) = 0.55;

void fragment() {
	// Distancia al centro corrigiendo un poco la relación de aspecto.
	vec2 d = UV - vec2(0.5);
	d.x *= 1.2;
	float dist = length(d);

	float oscuro = smoothstep(radio * suavidad, radio, dist) * fuerza;
	COLOR = vec4(0.0, 0.0, 0.0, oscuro);
}
