# PSX Look Free

**PS1-style 3D for Godot 4, free.** Wobbling vertices, warping textures and 240 chunky lines over
your own level in one line:

```gdscript
var psx := PSXScreen.new()
add_child(psx)
psx.viewport.add_child(level)
PSX.convert(level)   # every StandardMaterial3D becomes its PS1 version
```

### What's inside

- **Vertex snap:** vertices land on the low-res pixel grid, so edges jitter as the camera moves.
- **Affine texture mapping:** textures warp across big polygons as the PS1's did. A slider blends
  back to perspective-correct.
- **PSXScreen:** renders at 240 lines (or 480, or any), scaled up in sharp square pixels. UI
  outside it stays crisp.
- **The lit material** (per-vertex lighting, nearest-filtered textures, vertex colours, UV
  scrolling) and **PSX.convert**, which turns an imported level's StandardMaterial3Ds into it.
- **Demo:** a ruined courtyard at dusk with torches and 9 PS1-style textures. Walk it right here
  in the browser.

### Want more?

**[PSX Look](https://heyheythere.itch.io/psx-look)** adds the PS1's 15-bit colour and its 4x4
dither on PSXScreen, and four more materials: unlit, cutout for foliage and fences, transparent
for water and glass, and sphere-mapped chrome. Same code: install it over this one.

### Compatibility

- Godot **4.3 to 4.7**, tested on both ends.
- **Forward+, Mobile and Compatibility** renderers: desktop, mobile and web.
- GDScript and shaders only: no plugin to enable, no C#, no GDExtension.

### Install

Copy `addons/psx_look/` into your project. Open `demo/demo.tscn` to try it.

### License

[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/): use it in any game, commercial or not,
change it and share it, as long as you credit it. The credit line, for your game's credits:

`PSX Look Free by heyheythere - https://heyheythere.itch.io/psx-look-free - CC BY 4.0`

*Made with AI assistance (code, text, demo art), tested in Godot 4.3 and 4.7 on every renderer.*
