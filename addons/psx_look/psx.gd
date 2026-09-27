class_name PSX
## PS1-style materials: make one, or turn a whole scene's StandardMaterial3Ds into them.
##
##     PSX.convert(level)                         # every mesh under level
##     mesh.material_override = PSX.make(&"lit", preload("res://crate.png"))
##     PSX.set_param(level, &"affine", 0.0)       # on every PSX material under level

## Material kinds, each a shaders/psx_<kind>.gdshader.
const KINDS: Array[StringName] = [&"lit", &"unlit", &"cutout", &"transparent", &"chrome"]


static func has(kind: StringName) -> bool:
	return ResourceLoader.exists(_path(kind))


## A PSX material of `kind`, or lit where that kind isn't installed.
static func make(kind: StringName = &"lit", texture: Texture2D = null, color := Color.WHITE) -> ShaderMaterial:
	var m := ShaderMaterial.new()
	m.shader = load(_path(kind if has(kind) else &"lit"))
	m.set_shader_parameter(&"albedo", color)
	if texture:
		m.set_shader_parameter(&"albedo_texture", texture)
	if m.shader.resource_path == _path(&"chrome"):
		m.set_shader_parameter(&"reflection_texture", load("res://addons/psx_look/chrome.png"))
	return m


## The PSX material closest to a BaseMaterial3D: unshaded becomes unlit, alpha scissor cutout,
## alpha transparent, metallic chrome. Albedo colour, texture and UV1 scale and offset carry over.
static func from_material(source: BaseMaterial3D) -> ShaderMaterial:
	var kind := &"lit"
	if source.shading_mode == BaseMaterial3D.SHADING_MODE_UNSHADED:
		kind = &"unlit"
	elif source.transparency in [BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR, BaseMaterial3D.TRANSPARENCY_ALPHA_HASH]:
		kind = &"cutout"
	elif source.transparency != BaseMaterial3D.TRANSPARENCY_DISABLED:
		kind = &"transparent"
	elif source.metallic > 0.5:
		kind = &"chrome"
	var m := make(kind, source.albedo_texture, source.albedo_color)
	m.set_shader_parameter(&"uv_scale", Vector2(source.uv1_scale.x, source.uv1_scale.y))
	m.set_shader_parameter(&"uv_offset", Vector2(source.uv1_offset.x, source.uv1_offset.y))
	m.set_shader_parameter(&"vertex_colors", source.vertex_color_use_as_albedo)
	if kind == &"cutout":
		m.set_shader_parameter(&"alpha_cut", source.alpha_scissor_threshold)
	return m


## Swaps every BaseMaterial3D on the meshes under `root` (overrides and surface materials) for
## its PSX material, sharing one per source material. Returns how many it made.
static func convert(root: Node) -> int:
	var made := {}
	for node in _meshes(root):
		var mi := node as MeshInstance3D
		if mi.material_override is BaseMaterial3D:
			mi.material_override = _swap(mi.material_override, made)
		if mi.mesh:
			for s in mi.mesh.get_surface_count():
				var source: Material = mi.get_surface_override_material(s)
				if not source:
					source = mi.mesh.surface_get_material(s)
				if source is BaseMaterial3D:
					mi.set_surface_override_material(s, _swap(source, made))
	return made.size()


## Sets a shader parameter on every PSX material under `root`, for an options menu say.
static func set_param(root: Node, param: StringName, value: Variant) -> void:
	for node in _meshes(root):
		var mi := node as MeshInstance3D
		var mats: Array[Material] = [mi.material_override]
		for s in mi.get_surface_override_material_count():
			mats.append(mi.get_surface_override_material(s))
		for m in mats:
			if m is ShaderMaterial and m.shader and m.shader.resource_path.begins_with("res://addons/psx_look/"):
				m.set_shader_parameter(param, value)


static func _swap(source: BaseMaterial3D, made: Dictionary) -> ShaderMaterial:
	if source not in made:
		made[source] = from_material(source)
	return made[source]


static func _meshes(root: Node) -> Array[Node]:
	var out: Array[Node] = root.find_children("*", "MeshInstance3D", true, false)
	if root is MeshInstance3D:
		out.append(root)
	return out


static func _path(kind: StringName) -> String:
	return "res://addons/psx_look/shaders/psx_%s.gdshader" % kind
