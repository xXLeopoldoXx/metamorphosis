// Rayos de sol (god rays) suaves y animados. Se aplica a un ColorRect a pantalla
// completa dentro de un CanvasLayer, en modo aditivo, para simular haces de luz
// entrando entre los árboles. Muy sutil a propósito.

shader_type canvas_item;
render_mode blend_add;

uniform float intensidad : hint_range(0.0, 0.4) = 0.09;
uniform float velocidad : hint_range(0.0, 1.0) = 0.06;
uniform vec3 color_luz : source_color = vec3(1.0, 0.95, 0.72);

void fragment() {
	vec2 uv = UV;
	// Eje diagonal de los haces (la luz cae de arriba-derecha).
	float eje = uv.x * 2.2 - uv.y * 1.1;
	float t = TIME * velocidad;

	float haces = 0.0;
	haces += sin(eje * 7.0 + t * 6.0) * 0.6;
	haces += sin(eje * 12.0 - t * 4.0) * 0.4;
	haces = max(haces, 0.0);

	// Se desvanece hacia abajo (más fuerte arriba).
	float caida = smoothstep(1.0, 0.15, uv.y);

	float a = haces * caida * intensidad;
	COLOR = vec4(color_luz * a, a);
}
