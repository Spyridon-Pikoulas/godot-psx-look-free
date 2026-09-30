# PSX Look Free

**PS1-style 3D for Godot 4 and Unity, free.** Wobbling vertices, warping textures and 240 chunky lines over
your own level in one line:

```gdscript
var psx := PSXScreen.new()
add_child(psx)
psx.viewport.add_child(level)
PSX.convert(level)   # every StandardMaterial3D becomes its PS1 version
```

### Want more?

**[PSX Look](https://heyheythere.itch.io/psx-look)** adds the PS1's 15-bit colour and its 4x4
dither on PSXScreen, and four more materials: unlit, cutout for foliage and fences, transparent
for water and glass, and sphere-mapped chrome. Same code: install it over this one.

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

### Made for it

- **[PSX Horror Props](https://heyheythere.itch.io/psx-horror-props)**: 64 PS1-style survival horror
  props, 18 of them animated, with a Godot addon ([12 free](https://heyheythere.itch.io/psx-horror-props-free)).
- **[PSX Furniture](https://heyheythere.itch.io/psx-furniture)**: 476 PS1-style household props,
  145 of them moving, from the bed to the beer can ([36 for a room free](https://heyheythere.itch.io/psx-furniture-free)).
- **[PSX Hospital Kit](https://heyheythere.itch.io/psx-hospital-kit)**: a modular abandoned hospital
  level, 81 pieces on a 2 m grid ([15 for a ward free](https://heyheythere.itch.io/psx-hospital-kit-free)).
- **[PSX Apartment Kit](https://heyheythere.itch.io/psx-apartment-kit)**: a modular condemned
  apartment block, 105 pieces on a 2 m grid ([15 for a flat free](https://heyheythere.itch.io/psx-apartment-kit-free)).
- **[PSX Textures](https://heyheythere.itch.io/psx-textures)**: 138 seamless PS1-style textures, 16
  colours at 128 and 64 px ([16 free](https://heyheythere.itch.io/psx-textures-free)).
- **[PSX Firearms](https://heyheythere.itch.io/psx-firearms)**: 14 PS1-style guns whose slides,
  cylinders, pumps and magazines move ([a pistol and a shotgun free](https://heyheythere.itch.io/psx-firearms-free)).
- **[PSX Skyboxes](https://heyheythere.itch.io/psx-skyboxes)**: 26 dithered PS1-style skies, night to
  storm to space, as cubemaps and panoramas ([4 free](https://heyheythere.itch.io/psx-skyboxes-free)).
- **[PSX Horror SFX](https://heyheythere.itch.io/psx-horror-sfx)**: 194 PS1-style survival horror
  sounds, a shot and the reload for each PSX Firearms gun ([30 free](https://heyheythere.itch.io/psx-horror-sfx-free)).

### Compatibility

- Godot **4.3 to 4.7**, tested on both ends.
- **Forward+, Mobile and Compatibility** renderers: desktop, mobile and web.
- GDScript and shaders only: no plugin to enable, no C#, no GDExtension.

### Install

Copy `addons/psx_look/` into your project. Open `addons/psx_look/demo/demo.tscn` to try it.

### License

[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/): use it in any game, commercial or not,
change it and share it, as long as you credit it. The credit line, for your game's credits:

`PSX Look Free by heyheythere - https://heyheythere.itch.io/psx-look-free - CC BY 4.0`

*Made with AI assistance (code, text, demo art), tested in Godot 4.3 and 4.7 on every renderer and in Unity 6.3.*
