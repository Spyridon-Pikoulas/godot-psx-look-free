@tool
class_name PSXScreen
extends SubViewportContainer
## Draws the 3D under its SubViewport at a PS1 resolution, scaled up in sharp pixels, in 15-bit
## colour with the PS1's dither. Put your 3D scene under it:
##
##     var psx := PSXScreen.new()
##     add_child(psx)
##     psx.viewport.add_child(my_level)
##
## UI outside it stays sharp.

const COLOR_SHADER := "res://addons/psx_look/shaders/psx_screen.gdshader"

## Lines of the low-resolution picture, at least: 240 is the PS1's usual, 480 its high mode. The
## picture is the screen divided by a whole number, so pixels stay square and even.
@export_range(120, 1080) var lines := 240:
	set(value):
		lines = value
		_fit()
@export var dither := true:
	set(value):
		dither = value
		_set_color(&"dither", value)
## Bits per colour channel: 5 is the PS1's, 8 turns the colour reduction off.
@export_range(1, 8) var color_bits := 5:
	set(value):
		color_bits = value
		_set_color(&"color_bits", value)

var viewport: SubViewport


func _init() -> void:
	stretch = true
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if ResourceLoader.exists(COLOR_SHADER):
		material = ShaderMaterial.new()
		material.shader = load(COLOR_SHADER)


func _ready() -> void:
	for child in get_children():
		if child is SubViewport:
			viewport = child
	if not viewport:
		viewport = SubViewport.new()
		viewport.own_world_3d = true
		add_child(viewport)
	_set_color(&"dither", dither)
	_set_color(&"color_bits", color_bits)
	resized.connect(_fit)
	_fit()


func _fit() -> void:
	stretch_shrink = maxi(1, floori(size.y / lines))


func _set_color(param: StringName, value: Variant) -> void:
	if material:
		material.set_shader_parameter(param, value)
