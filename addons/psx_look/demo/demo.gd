extends Node
## The level through PSXScreen with its materials converted by PSX.convert, and a switch for
## every part of the look.

const World := preload("res://addons/psx_look/demo/world.gd")
const RESOLUTIONS := [[240, "240p"], [480, "480p"], [1080, "Native"]]

## Hides the panel, for the store captures.
@export var no_ui := false

var psx := PSXScreen.new()
var world := World.new()
var _res := 0


func _ready() -> void:
	add_child(psx)
	psx.viewport.add_child(world)
	PSX.convert(world)
	if no_ui:
		return
	var ui := CanvasLayer.new()
	add_child(ui)
	var panel := PanelContainer.new()
	panel.position = Vector2(16, 16)
	ui.add_child(panel)
	var box := VBoxContainer.new()
	panel.add_child(box)
	var title := Label.new()
	title.text = "PSX LOOK"
	box.add_child(title)
	var res := Button.new()
	res.text = "Resolution: 240p"
	res.pressed.connect(func() -> void:
		_res = (_res + 1) % RESOLUTIONS.size()
		psx.lines = RESOLUTIONS[_res][0]
		res.text = "Resolution: " + RESOLUTIONS[_res][1])
	box.add_child(res)
	_toggle(box, "Vertex snap", func(on: bool) -> void: PSX.set_param(world, &"snap_pixels", 1.0 if on else 0.0))
	_toggle(box, "Affine textures", func(on: bool) -> void: PSX.set_param(world, &"affine", 1.0 if on else 0.0))
	if psx.material:
		_toggle(box, "Dither", func(on: bool) -> void: psx.dither = on)
		_toggle(box, "15-bit colour", func(on: bool) -> void: psx.color_bits = 5 if on else 8)
	_toggle(box, "Fog", func(on: bool) -> void: world.env.fog_enabled = on)
	var hint := Label.new()
	hint.text = "WASD / arrows to walk\ndrag to look"
	hint.add_theme_font_size_override("font_size", 13)
	box.add_child(hint)


func _toggle(box: Container, text: String, apply: Callable) -> void:
	var b := CheckButton.new()
	b.text = text
	b.button_pressed = true
	b.focus_mode = Control.FOCUS_NONE
	b.toggled.connect(apply)
	box.add_child(b)
