// The PS1 look shared by every psx_*.gdshader: vertices snapped to the screen's pixel grid,
// affine (not perspective-correct) texture mapping, nearest-filtered textures, vertex colours.
// The including shader sets render_mode, and may #define PSX_CUTOUT, PSX_TRANSPARENT or PSX_CHROME.

uniform vec4 albedo : source_color = vec4(1.0);
uniform sampler2D albedo_texture : source_color, filter_nearest, repeat_enable, hint_default_white;
uniform vec2 uv_scale = vec2(1.0);
uniform vec2 uv_offset = vec2(0.0);
// UV units per second, for water, lava and conveyor belts.
uniform vec2 uv_scroll = vec2(0.0);
// Size of the grid vertices snap to, in pixels of the viewport drawing them. 0 turns it off.
uniform float snap_pixels : hint_range(0.0, 8.0) = 1.0;
// 1 is the PS1's warping affine mapping, 0 the modern perspective-correct one.
uniform float affine : hint_range(0.0, 1.0) = 1.0;
uniform bool vertex_colors = true;
#ifdef PSX_CUTOUT
uniform float alpha_cut : hint_range(0.0, 1.0) = 0.5;
#endif
#ifdef PSX_CHROME
// A sphere map looked up by the view-space normal, per vertex as on the PS1.
uniform sampler2D reflection_texture : source_color, filter_nearest, hint_default_black;
uniform float reflection : hint_range(0.0, 1.0) = 0.7;
varying vec3 psx_env;
#endif

varying vec3 psx_uv;

void vertex() {
	vec2 uv = UV * uv_scale + uv_offset + uv_scroll * TIME;
	vec4 clip = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	if (snap_pixels > 0.0 && clip.w > 0.0) {
		vec2 grid = VIEWPORT_SIZE * 0.5 / snap_pixels;
		clip.xy = round(clip.xy / clip.w * grid) / grid * clip.w;
	}
	POSITION = clip;
	float w = mix(1.0, clip.w, affine);
	psx_uv = vec3(uv * w, w);
#ifdef PSX_CHROME
	vec3 n = normalize((MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
	psx_env = vec3((n.xy * vec2(0.5, -0.5) + 0.5) * w, w);
#endif
}

void fragment() {
	vec4 c = albedo * texture(albedo_texture, psx_uv.xy / psx_uv.z);
	if (vertex_colors) {
		c *= COLOR;
	}
#ifdef PSX_CHROME
	c.rgb = mix(c.rgb, texture(reflection_texture, psx_env.xy / psx_env.z).rgb, reflection);
#endif
	ALBEDO = c.rgb;
#ifdef PSX_CUTOUT
	ALPHA = c.a;
	ALPHA_SCISSOR_THRESHOLD = alpha_cut;
#endif
#ifdef PSX_TRANSPARENT
	ALPHA = c.a;
#endif
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;
}
