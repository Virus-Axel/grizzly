shader_type spatial;

//uniform uvec3 fur_color = vec(1.0, 1.0, 1.0);
uniform vec3 fur_color;
uniform float DENSITY = 900;
uniform float FUR_THICKNESS = 0.3;
uniform float DISSPLACEMENT = 0.1;
uniform int layer = 0;
uniform vec3 wind = vec3(0.0, 0.0, 0.0);
uniform sampler2D fur_bump;

float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289_i(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289_i(((x * 34.0) + 1.0) * x);}

float noise(vec3 p){
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise_2(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}


void vertex(){
	vec3 wrld_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float dissplacement_x = noise(wrld_vertex * 50000.0) * DISSPLACEMENT;
	float dissplacement_y = noise(300.0 + wrld_vertex * 50000.0) * DISSPLACEMENT;
	float dissplacement_z = noise(600.0 + wrld_vertex * 50000.0) * DISSPLACEMENT;
	VERTEX = float(layer) * wind + VERTEX + (vec3(DISSPLACEMENT) - vec3(dissplacement_x, dissplacement_y, dissplacement_z));
	VERTEX.x += 0.001 - sin(TIME * 2.1) * 0.002;
}

void fragment() {
	ALBEDO = fur_color;
	vec3 wrld_vertex = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	//float noise_float = noise_2(UV * DENSITY);
	float noise_float = texture(fur_bump, UV * DENSITY).r;
	if(noise_float < FUR_THICKNESS){
		ALPHA = (FUR_THICKNESS - noise_float) / FUR_THICKNESS;
		//ALPHA = 255.0;
	}
	else{
		ALPHA = 0.0;
	}
	ALPHA = 2.0 * noise_float;
	if(layer == 0){
		ALPHA = 1.0F;
	}
	// Place fragment code here.
}
