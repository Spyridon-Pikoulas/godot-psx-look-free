# PSX Look

PS1-style 3D for Godot 4.3+ (Forward+, Mobile, Compatibility).

## Use

```gdscript
var psx := PSXScreen.new()          # the low-res, 15-bit, dithered picture
add_child(psx)
psx.viewport.add_child(level)       # your 3D scene goes in its SubViewport
PSX.convert(level)                  # StandardMaterial3Ds become PSX materials
```

In the editor: add a PSXScreen, give it a SubViewport child, and put your 3D scene under that.
Keep UI outside the PSXScreen to keep it sharp.

## PSXScreen

- `lines`: the picture's height at least (240 is the PS1's usual, 480 its high mode). It is the
  screen divided by a whole number, so 1080p at 240 lines draws 270.
- `dither`: the PS1's 4x4 ordered dither.
- `color_bits`: bits per channel, 5 for the PS1's 15-bit colour, 8 for none.

## Materials

`PSX.make(kind, texture, color)` makes one; `kind` is `lit`, `unlit`, `cutout`, `transparent` or
`chrome`, each a `shaders/psx_<kind>.gdshader` you can also put on a ShaderMaterial yourself.
`PSX.convert(root)` maps unshaded to unlit, alpha scissor to cutout, alpha to transparent and
metallic to chrome, and returns how many materials it made. `PSX.set_param(root, name, value)`
sets a parameter on every PSX material under `root`.

Parameters on every kind: `albedo`, `albedo_texture`, `uv_scale`, `uv_offset`, `uv_scroll` (UV
per second), `snap_pixels` (the vertex grid in screen pixels, 0 = off), `affine` (1 = PS1
warping, 0 = perspective-correct), `vertex_colors`. Cutout adds `alpha_cut`, chrome
`reflection_texture` (a sphere map, `chrome.png` by default) and `reflection`.

Affine mapping warps more the bigger a polygon is on screen: cut large floors and walls into
smaller quads, as PS1 games did. Lit materials light per vertex, so the same goes for lights.

Fog is the Environment's: depth fog (`fog_mode = FOG_MODE_DEPTH`) with a near `fog_depth_end`
gives the PS1's draw-distance haze.
