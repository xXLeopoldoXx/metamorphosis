// Shader de viento para los fondos pintados.
//
// Desplaza ligeramente los UVs combinando dos sinusoides de distinta frecuencia
// para que la copa de los árboles "respire" como mecida por el viento.
// La máscara lleva el efecto a 0 cerca del suelo pintado (ajustable con
// "linea_suelo"), así la tierra queda quieta y solo se mueve el follaje.
// Tambien aplica una sutil pulsacion de luz solar para sumar vida.

shader_type canvas_item;

uniform float velocidad_viento : hint_range(0.0, 5.0) = 1.0;
uniform float fuerza_viento : hint_range(0.0, 0.04) = 0.012;
uniform float linea_suelo : hint_range(0.5, 1.0) = 0.78;
uniform float pulso_luz : hint_range(0.0, 0.15) = 0.04;

void fragment() {
	vec2 uv = UV;

	// Mascara vertical: 1.0 arriba (follaje), 0.0 abajo (suelo).
	float mascara = 1.0 - smoothstep(linea_suelo - 0.18, linea_suelo, uv.y);

	float t = TIME * velocidad_viento;
	// Onda lenta y amplia
	float onda1 = sin(uv.y * 4.0 + t * 1.2) * 0.7;
	// Onda rapida y pequeña (rompe la regularidad)
	float onda2 = sin(uv.y * 11.0 + uv.x * 5.0 + t * 1.7) * 0.3;

	float dx = (onda1 + onda2) * fuerza_viento * mascara;
	float dy = cos(uv.x * 6.0 + t) * fuerza_viento * 0.35 * mascara;

	uv.x += dx;
	uv.y += dy;

	vec4 color = texture(TEXTURE, uv);

	// Pulsacion de luz solar (solo en la zona con follaje)
	float pulso = 1.0 + sin(TIME * 0.5) * pulso_luz * mascara;
	color.rgb *= pulso;

	COLOR = color;
}
