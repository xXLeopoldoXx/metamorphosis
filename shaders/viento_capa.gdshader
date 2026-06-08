// Viento suave para las CAPAS pintadas (arbustos, nubes). A diferencia del
// viento_bg viejo (que ondulaba en X e Y como agua), este solo desplaza en
// HORIZONTAL, de forma muy sutil, más fuerte arriba y nulo en el suelo.
// Resultado: el follaje se mece con la brisa, sin verse líquido.

shader_type canvas_item;

uniform float amplitud : hint_range(0.0, 0.02) = 0.005;
uniform float velocidad : hint_range(0.0, 4.0) = 1.0;
uniform float linea_suelo : hint_range(0.5, 1.0) = 0.78;
uniform float fase = 0.0;

void fragment() {
	vec2 uv = UV;
	// 1 arriba (follaje), 0 en/under el suelo pintado.
	float mascara = 1.0 - smoothstep(linea_suelo - 0.15, linea_suelo, uv.y);
	float altura = 1.0 - uv.y;
	uv.x += sin(TIME * velocidad + fase + uv.y * 2.5) * amplitud * mascara * altura;
	COLOR = texture(TEXTURE, uv);
}
