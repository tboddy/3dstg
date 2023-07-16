// variables provided by g3d's vertex shader
varying vec4 worldPosition;
varying vec3 vertexNormal;

// the model matrix comes from the camera automatically
uniform mat4 modelMatrix;
uniform vec3 lightPosition = vec3(1,1,1);
uniform float ambient = 0.8;

extern vec3 player;

vec4 effect(vec4 color, Image tex, vec2 texcoord, vec2 pixcoord) {
    // diffuse light
    // computed by the dot product of the normal vector and the direction to the light source
    vec3 lightDirection = normalize(lightPosition.xyz - worldPosition.xyz);
    vec3 normal = normalize(mat3(modelMatrix) * vertexNormal);
    float diffuse = max(dot(lightDirection, normal), 0);

    // get color from the texture
    vec4 texcolor = Texel(tex, texcoord);

    // if this pixel is invisible, get rid of it
    if (texcolor.a == 0.0) { discard; }

    // draw the color from the texture multiplied by the light amount
    float lightness = diffuse + ambient;

    // fog
    number d = distance(player, vec3(worldPosition[0], worldPosition[1], worldPosition[2]));
    number amount = smoothstep(0, 55, d);

    // return vec4((texcolor * color).rgb * lightness, 1.0);
    return mix(vec4((texcolor * color).rgb * lightness, 1.0), vec4(0.024,0.024,0.031,1), amount);
}