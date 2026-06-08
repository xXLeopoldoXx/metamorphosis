// Rayos de sol estáticos anclados al mundo. Se aplica a un ColorRect en espacio
// de mundo (4884×2400) para que el patrón no se mueva con la cámara.

shader_type canvas_item;
render_mode blend_add;

uniform float intensidad : hint_range(0.0, 0.4) = 0.09;
uniform vec3 color_luz : source_color = vec3(1.0, 0.95, 0.72);

void fragment() {
	vec2 uv = UV;
	// Eje diagonal escalado al tamaño del mundo (4884×2400 ≈ 3.8× la pantalla).
	float eje = uv.x * 8.4 - uv.y * 4.2;

	float haces = 0.0;
	haces += sin(eje * 7.0) * 0.6;
	haces += sin(eje * 12.0) * 0.4;
	haces = max(haces, 0.0);

	// Desvanece de arriba (brillo máximo) hacia abajo del nivel.
	float caida = smoothstep(1.0, 0.0, uv.y);

	float a = haces * caida * intensidad;
	COLOR = vec4(color_luz * a, a);
}
