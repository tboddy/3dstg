varying vec4 worldPosition;
extern vec3 player;
vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
	vec4 pixel = Texel(tex, tc);
	number d = distance(player, vec3(worldPosition[0], worldPosition[1], worldPosition[2]));
	number amount = smoothstep(0, 65, d);
	if (pixel.a == 0.0) { discard; }
	else {pixel.a = 0.5;}
	return mix(pixel, vec4(0.024,0.024,0.031,1), amount);
}