extends RefCounted
## Low-poly meshes for the demo world, UV'd in world units so textures tile at one size everywhere.


## A box on the ground (its base at y = 0). `tile` metres per texture repeat; 0 maps each face
## once. Tiled faces are cut into quads of about 2 m, which keeps the affine warp PS1-sized.
static func box(size: Vector3, tile := 1.0) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var h := Vector3(size.x * 0.5, 0.0, size.z * 0.5)
	var faces := [  # normal, right, up
		[Vector3.FORWARD, Vector3.LEFT, Vector3.UP], [Vector3.BACK, Vector3.RIGHT, Vector3.UP],
		[Vector3.LEFT, Vector3.BACK, Vector3.UP], [Vector3.RIGHT, Vector3.FORWARD, Vector3.UP],
		[Vector3.UP, Vector3.RIGHT, Vector3.FORWARD], [Vector3.DOWN, Vector3.RIGHT, Vector3.BACK]]
	for f in faces:
		var n: Vector3 = f[0]
		var r: Vector3 = f[1]
		var u: Vector3 = f[2]
		var w := absf(r.dot(size))
		var ht := absf(u.dot(size))
		var center := Vector3(0, size.y * 0.5, 0) + n * absf(n.dot(size)) * 0.5
		if tile <= 0.0:
			_quad(st, center, r * w * 0.5, u * ht * 0.5, n, Vector2.ONE)
			continue
		var cuts := Vector2i(ceili(w / 2.0), ceili(ht / 2.0))
		var cell := Vector2(w, ht) / Vector2(cuts)
		for j in cuts.y:
			for i in cuts.x:
				var c := center + r * (cell.x * (i + 0.5) - w * 0.5) - u * (cell.y * (j + 0.5) - ht * 0.5)
				_quad(st, c, r * cell.x * 0.5, u * cell.y * 0.5, n, cell / tile, Vector2(i, j) * cell / tile)
	st.generate_tangents()
	return st.commit()


## An upright n-sided prism with caps, base at y = 0.
static func pillar(radius: float, height: float, sides := 8, tile := 1.0) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var around := TAU * radius
	for i in sides:
		var a0 := TAU * i / sides
		var a1 := TAU * (i + 1) / sides
		var p0 := Vector3(cos(a0), 0, sin(a0)) * radius
		var p1 := Vector3(cos(a1), 0, sin(a1)) * radius
		var n := ((p0 + p1) * 0.5).normalized()
		var u0 := around * i / sides / tile
		var u1 := around * (i + 1) / sides / tile
		var v := height / tile
		_tri(st, [p0, p1 + Vector3.UP * height, p1], [Vector2(u0, v), Vector2(u1, 0), Vector2(u1, v)], n)
		_tri(st, [p0, p0 + Vector3.UP * height, p1 + Vector3.UP * height], [Vector2(u0, v), Vector2(u0, 0), Vector2(u1, 0)], n)
		var top := Vector3.UP * height
		_tri(st, [top, top + p1, top + p0], [Vector2(0.5, 0.5), _cap_uv(a1), _cap_uv(a0)], Vector3.UP)
	st.generate_tangents()
	return st.commit()


## A ground plane centred on the origin, cut into `cuts` x `cuts` quads: the PS1 look warps
## big polygons, and vertex lighting only lights at vertices.
static func ground(size: float, cuts: int, tile := 1.0) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var step := size / cuts
	for z in cuts:
		for x in cuts:
			var c := Vector3(-size * 0.5 + (x + 0.5) * step, 0, -size * 0.5 + (z + 0.5) * step)
			var uv0 := Vector2(x, z) * step / tile
			_quad(st, c, Vector3.RIGHT * step * 0.5, Vector3.FORWARD * step * 0.5, Vector3.UP,
					Vector2.ONE * step / tile, uv0)
	st.generate_tangents()
	return st.commit()


## Two crossed upright quads, for leaves and flames. Base at y = 0.
static func cross(width: float, height: float) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for r in [Vector3.RIGHT, Vector3.BACK]:
		_quad(st, Vector3.UP * height * 0.5, r * width * 0.5, Vector3.UP * height * 0.5,
				r.cross(Vector3.UP), Vector2.ONE)
	return st.commit()


## An octahedron stretched tall: the gem.
static func gem(radius: float, height: float) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var ring: Array[Vector3] = []
	for i in 6:
		ring.append(Vector3(cos(TAU * i / 6), 0, sin(TAU * i / 6)) * radius)
	for i in 6:
		var a := ring[i]
		var b := ring[(i + 1) % 6]
		for tip in [Vector3.UP * height * 0.5, Vector3.DOWN * height * 0.5]:
			var tri := [tip, b, a] if tip.y > 0 else [tip, a, b]
			var n: Vector3 = (tri[1] - tri[0]).cross(tri[2] - tri[0]).normalized()
			_tri(st, tri, [Vector2(0.5, 0), Vector2(1, 1), Vector2(0, 1)], -n)
	st.generate_tangents()
	return st.commit()


static func _quad(st: SurfaceTool, c: Vector3, r: Vector3, u: Vector3, n: Vector3, uv_size: Vector2,
		uv0 := Vector2.ZERO) -> void:
	var p := [c - r - u, c + r - u, c + r + u, c - r + u]
	var uv := [uv0 + Vector2(0, uv_size.y), uv0 + uv_size, uv0 + Vector2(uv_size.x, 0), uv0]
	_tri(st, [p[0], p[2], p[1]], [uv[0], uv[2], uv[1]], n)
	_tri(st, [p[0], p[3], p[2]], [uv[0], uv[3], uv[2]], n)


## Godot's front faces wind clockwise seen from the front.
static func _tri(st: SurfaceTool, p: Array, uv: Array, n: Vector3) -> void:
	for i in 3:
		st.set_normal(n)
		st.set_uv(uv[i])
		st.add_vertex(p[i])


static func _cap_uv(a: float) -> Vector2:
	return Vector2(cos(a), sin(a)) * 0.5 + Vector2(0.5, 0.5)
