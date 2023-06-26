varying vec4 worldPosition;
extern vec3 player;
vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
	vec4 pixel = Texel(tex, tc);
	if (pixel.a == 0.0) { discard; }
	number d = distance(player, vec3(worldPosition[0], worldPosition[1], worldPosition[2]));
	number amount = smoothstep(0, 50, d);
	return mix(pixel, vec4(0.078,0.063,0.075,1), amount);
}