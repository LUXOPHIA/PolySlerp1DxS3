# LUX.FMX.Graphics.D3

[English](README.md) | [日本語](ja/README.md)

A 3D graphics library for Delphi built on the FireMonkey 3D framework. It wraps FireMonkey's `TControl3D`, `TCamera` and `TLight` in nodes whose poses are LUX 4×4 matrices in a Y-up world, and adds a dirty-flag build pipeline for procedurally generated meshes.

## 利用ライブラリ

* [**LUX**](https://github.com/LUXOPHIA/LUX) ：The base library providing the vector and matrix types `TSingle3D` and `TSingleM4`.

## 1. Overview

FireMonkey already supplies a 3D scene tree — `TViewport3D` at the root, `TControl3D` descendants below it, rendered with `TMeshData` and material sources [1][2]. This library is a thin adaptation layer over that framework, with three purposes.

1. **Poses as matrices.** Every node exposes `LocaPose` / `AbsoPose` (both aliased as `Pose`) as `TSingleM4`, and `LocaPos` / `AbsoPos` (aliased `Pos`) as `TSingle3D`, in place of FireMonkey's separate `Position` / `RotationAngle` / `Scale` triplet. Writing `LocaPose` assigns `FLocalMatrix` directly, then calls `RecalcAbsolute`, `RebuildRenderingList` and `Repaint`. The extents are likewise re-exposed as `SizeX` / `SizeY` / `SizeZ` over `Width` / `Height` / `Depth`.
2. **A Y-up world.** `TF3DWorld`, constructed directly from a `TViewport3D`, sets its own pose to `TSingleM4.Scale( +1, -1, -1 )`, so that everything below it lives in a frame whose +Y points up on screen and whose +Z points toward the viewer. `TF3DCamera` owns an inner FireMonkey `TCamera` carrying `Scale.Y = Scale.Z = -1`, which re-applies the same flip to the camera's own axes.
3. **Lazy model building.** `TF3DObject.BeforeRender` calls `MakeModel` whenever the `upModel` flag is raised, then lowers it; `TF3DShaper` refines this into `MakeGeometry` (vertex buffer) and `MakeTopology` (index buffer), each guarded by its own flag (`upGeometry`, `upTopology`). A property setter only raises a flag, so a burst of setter calls costs a single rebuild at the next frame.

Two conveniences apply to every node: the constructor auto-parents the node to its `Owner` when that owner is a `TControl3D`, and `TF3DObject` sets `HitTest := False`, keeping the helper nodes out of mouse picking.

## 2. Mathematical background

### 2.1 Poses as 4×4 matrices, and the two conventions

LUX `TSingleM4` acts on column vectors, with the translation in the fourth column:

```math
p' = M\,p, \qquad
M = \begin{pmatrix}
m_{11} & m_{12} & m_{13} & m_{14} \\
m_{21} & m_{22} & m_{23} & m_{24} \\
m_{31} & m_{32} & m_{33} & m_{34} \\
0 & 0 & 0 & 1
\end{pmatrix}, \qquad
p = \begin{pmatrix} x \\ y \\ z \\ 1 \end{pmatrix}
\tag{1}
```

The first three columns are the images of the local axes (`AxisX`, `AxisY`, `AxisZ`) and the fourth is the image of the local origin (`AxisP`). FireMonkey's `TMatrix3D` multiplies row vectors instead, so the casts between the two types transpose:

```math
M_{\mathrm{FMX}} = M^{\mathsf T}
\tag{2}
```

Reading `AbsoPose` therefore returns the transpose of `TControl3D.AbsoluteMatrix`, which FireMonkey accumulates down the scene tree. In the convention of (1) that accumulation reads

```math
M^{\mathrm{a}}_{k} = M^{\mathrm{a}}_{\pi(k)}\, M^{\mathrm{l}}_{k}
\tag{3}
```

where $\pi(k)$ is the parent of node $k$.

### 2.2 The world flip

`TF3DWorld` installs

```math
M_{\mathrm{world}} = S(+1,-1,-1) = \operatorname{diag}(1,-1,-1,1)
\tag{4}
```

FireMonkey's viewport frame runs +X to the right, +Y downward and +Z away from the viewer; (4) negates the Y and Z axes, so in the world node's frame +Y points up and +Z points toward the viewer. Since $\det \operatorname{diag}(1,-1,-1) = +1$, (4) is a proper rotation by $\pi$ about the X axis and the orientation of the basis is preserved. `TF3DCamera`'s inner `TCamera` carries the same negations on its own `Scale`, undoing (4) for the viewing axes.

### 2.3 The render transform of a shaper

`TF3DShaper.Render` sets the rendering context matrix to the absolute matrix with the node's extents folded in on the local side, i.e. in the convention of (1)

```math
M^{\mathrm{r}}_{k} = M^{\mathrm{a}}_{k}\; S\!\left( S_x, S_y, S_z \right)
\tag{5}
```

Geometry is therefore authored once at unit scale in local space and stretched by `SizeX` / `SizeY` / `SizeZ` without touching the vertex buffer.

### 2.4 The sphere mesh

`TF3DSphere` samples the unit sphere on a $(D_x{+}1) \times (D_y{+}1)$ lattice:

```math
\mathbf{p}(u,v) =
\begin{pmatrix}
+\sin v \, \cos u \\
\cos v \\
-\sin v \, \sin u
\end{pmatrix}, \qquad
u = \frac{2\pi x}{D_x}, \quad
v = \frac{\pi y}{D_y}
\tag{6}
```

for $0 \le x \le D_x$ and $0 \le y \le D_y$, flattened into the vertex buffer by

```math
i(x,y) = (D_x + 1)\,y + x
\tag{7}
```

Because $\lVert \mathbf{p} \rVert = 1$, the position doubles as the outward normal, and the texture coordinate is the normalized lattice index $(x/D_x,\; y/D_y)$. The seam column $x = D_x$ duplicates the positions of $x = 0$ while carrying $u = 2\pi$ instead of $0$, so the texture wraps without a discontinuity. Each lattice quad emits two triangles, so the index buffer holds

```math
N_{\mathrm{index}} = 6\, D_x D_y
\tag{8}
```

entries; the defaults are $D_x = 36$, $D_y = 18$.

## 3. Architecture

### 3.1 Classes

```
・TControl3D  (FMX)
  ┗・TF3DObject       ･･･ Pose :TSingleM4, Pos :TSingle3D, upModel → MakeModel
     ┣・TF3DWorld     ･･･ Create( TViewport3D ); Pose = Scale( +1, -1, -1 )
     ┣・TF3DCamera    ･･･ Camera :TCamera — inner camera, Scale.Y=Scale.Z=-1
     ┗・TF3DShaper    ･･･ upGeometry/upTopology → MakeGeometry/MakeTopology
        ┗・TF3DSphere ･･･ DivX/DivY, Material :TLightMaterialSource, TMeshData

・TLight  (FMX)
  ┗・TF3DLight        ･･･ the same pose / position / size property set
```

`MakeGeometry` and `MakeTopology` are abstract, so `TF3DSphere` is both the single concrete shape shipped and the template for new ones: derive from `TF3DShaper`, fill a `TMeshData` in those two methods, and render it in an overridden `Render`.

### 3.2 Files

```
・LUX.FMX.Graphics.D3/
  ┣・LUX.FMX.Graphics.D3.pas        ･･･ TF3DObject/World/Camera/Light/Shaper
  ┗・LUX.FMX.Graphics.D3.Shaper.pas ･･･ procedural mesh: TF3DSphere
```

The library depends on the LUX base library for `TSingle3D` and `TSingleM4`, and on FireMonkey for `FMX.Types3D`, `FMX.Controls3D`, `FMX.Viewport3D` and `FMX.MaterialSources`.

## 4. Usage

```pascal
uses System.UITypes,
     LUX, LUX.D3, LUX.D4x4,
     LUX.FMX.Graphics.D3, LUX.FMX.Graphics.D3.Shaper;

var
   World  :TF3DWorld;
   Camera :TF3DCamera;
   Light  :TF3DLight;
   Ball   :TF3DSphere;
begin
     World := TF3DWorld.Create( Viewport3D1 );           // +Y up, +Z toward the viewer

     Camera     := TF3DCamera.Create( World );           // auto-parented to its Owner
     Camera.Pos := TSingle3D.Create( 0, 0, 10 );         // on the +Z axis of the world
     Viewport3D1.Camera := Camera.Camera;                // hand the inner FMX camera over

     Light      := TF3DLight.Create( World );
     Light.Pose := TSingleM4.RotateX( -0.5 );            // orientation of a directional light

     Ball := TF3DSphere.Create( World );

     Ball.DivX := 72;                                    // raises upGeometry / upTopology;
     Ball.DivY := 36;                                    // rebuilt once, before the next frame

     Ball.SizeX := 2;                                    // scales the unit sphere per (5),
     Ball.SizeY := 2;                                    // leaving the vertex buffer alone
     Ball.SizeZ := 2;

     Ball.Pos := TSingle3D.Create( 0, 0, 0 );
     Ball.Material.Diffuse := TAlphaColors.Orange;
end;
```

The nodes are ordinary FireMonkey components owned by their `Owner`, so freeing the viewport or the form releases the whole scene.

## 5. References

1. Embarcadero, [*FireMonkey 3D*](https://docwiki.embarcadero.com/RADStudio/en/FireMonkey_3D).
2. Embarcadero, [*FMX.Controls3D.TControl3D*](https://docwiki.embarcadero.com/Libraries/en/FMX.Controls3D.TControl3D).
3. Embarcadero, [*FMX.Types3D.TMeshData*](https://docwiki.embarcadero.com/Libraries/en/FMX.Types3D.TMeshData).

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
