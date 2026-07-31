# LUX.Sphere

[English](README.md) | [日本語](ja/README.md)

A spherical geometry library for Delphi (Object Pascal). It provides point types on the 2-sphere $S^2$ (unit vectors) and on the 3-sphere $S^3$ (unit quaternions), an algebra of *weighted points* whose `+` operator is spherical linear interpolation, and a family of weighted spherical averaging (barycenter) operators — `Lerp`, `Glerp`, `Slerp`, `PolySlerp`, `SymSlerp`, `AveVecs`, `PowSlerp`, `ExpMap`, `ModExpMap`. Closed-loop point grids seeded from the Platonic solids and FireMonkey components for rendering them are included.

## 利用ライブラリ

* [**LUX**](https://github.com/LUXOPHIA/LUX) ：Base library supplying the epsilon constants, the `TDouble3D` / `TDoubleQ` linear algebra, the weighted-point record `TDoubleWector<>` and the `TPoins<>` grid containers.
* [**LUX.FMX.Graphics.D3**](https://github.com/LUXOPHIA/LUX.FMX.Graphics.D3) ：FireMonkey 3D component framework providing the `TF3DShaper` and scene classes that the `FMX` units derive from.

## 1. Overview

| Unit | Contents |
|:---|:---|
| `S2/LUX.S2.pas` | `TSingle2S` / `TDouble2S` — points of $S^2$, aliases of `TSingle3D` / `TDouble3D`; record helpers adding `Unitor` (normalization with an $\varepsilon$ guard) |
| `S2/Curve/LUX.S2.Curve.pas` | Weighted points: `TSingleW2S` / `TDoubleW2S` (aliases of `TSingleWector<>` / `TDoubleWector<>`) and `TSingle2Sw` / `TDouble2Sw`, records with the full operator algebra ($+$, $-$, scalar $\times$, $/$, casts) |
| `S2/Curve/LUX.S2.Curve.Lerp.pas` | `Lerp` — chordal (extrinsic) weighted average in $\mathbb{R}^3$, **not** normalized |
| `S2/Curve/LUX.S2.Curve.Glerp.pas` | `Glerp` — gnomonic linear interpolation: `Lerp` followed by normalization |
| `S2/Curve/LUX.S2.Curve.Slerp.pas` | `Slerp` (parameter form, weight-pair form, weighted-point forms) and `ChainSlerp` |
| `S2/Curve/LUX.S2.Curve.PolySlerp.pas` | `PolySlerp1D` — order-symmetric dyadic pyramid of the binary weighted `Slerp` |
| `S2/Curve/D2/LUX.S2.Curve.D2.PolySlerp.pas` | `PolySlerp` — spherical barycenter of three points by geodesic triangle contraction |
| `S2/Curve/D2/LUX.S2.Curve.D2.SymSlerp.pas` | `SymSlerp` — order-symmetrized triple fold of the weighted `Slerp` |
| `S2/Curve/D2/LUX.S2.Curve.D2.AveVecs.pas` | `AveVecs` — tangent-plane fixed-point iteration for the weighted mean |
| `S3/LUX.S3.pas` | `TSingle3S` / `TDouble3S` — points of $S^3$, aliases of `TSingleQ` / `TDoubleQ` (unit quaternions), with `Unitor` |
| `S3/Curve/LUX.S3.Curve.pas` | The $S^3$ counterparts `TSingleW3S` / `TDoubleW3S` and `TSingle3Sw` / `TDouble3Sw` |
| `S3/Curve/LUX.S3.Curve.{Glerp,Slerp,PolySlerp}.pas` | The same three interpolation families on $S^3$ |
| `S3/Curve/LUX.S3.Curve.PowSlerp.pas` | `PowSlerp` / `ChainPowSlerp` — geodesic step by quaternion power |
| `S3/Curve/LUX.S3.Curve.ExpMap.pas` | `ExpMap` — log-domain weighted average |
| `S3/Curve/LUX.S3.Curve.ModExpMap.pas` | `ModExpMap` — log-domain average in the tangent space at the `Glerp` mean |
| `S2/Data/Grid/…`, `S3/Data/Grid/…` | `TPoins2S` / `TLoopPoins2S`, `TPoins3S` / `TLoopPoins3S`, the Platonic-solid loops `TPolyPoins2S04`…`20` and `TPolyPoins3S04`…`20`, and the arc-length resamplers `TPlots2S` / `TPlots3S` |
| `S2/FMX/…`, `S3/FMX/…`, `FMX/…` | FireMonkey components: `TPoins3D` / `THemiPoins3D` dot-cloud shapers, and the `TWorld3D` / `TCamera3D` / `TLight3D` / `TSphere3D` scene wrappers |

Every type and routine exists in both `Single` and `Double` precision; the `Double` forms are used below.

## 2. Mathematical Background

### 2.1. The two spheres

```math
S^2 = \left\{\, p \in \mathbb{R}^3 \;\middle|\; \lVert p \rVert = 1 \,\right\},
\qquad
S^3 = \left\{\, q \in \mathbb{H} \;\middle|\; \lVert q \rVert = 1 \,\right\}
\qquad \text{(2.1)}
```

`LUX.S2` identifies a point of $S^2$ with a 3-vector and `LUX.S3` identifies a point of $S^3$ with a quaternion, so the ambient linear algebra of `LUX.D3` and `LUX.Quaternion` is inherited unchanged, and the sphere enters only through the normalization `Unitor` (which returns $0$ when the norm falls below $\varepsilon$). Both spheres carry the geodesic (angular) metric

```math
d(p,q) = \arccos \langle p, q \rangle \; \in [0, \pi] , \qquad \Omega \equiv d(p,q)
\qquad \text{(2.2)}
```

which is what `TPlots2S.Distance` measures. On $S^3$ the natural distance is that of the induced rotation, so `TPlots3S.Distance` compares the images of a fixed axis, $\angle\bigl(R_{q_0}(\hat{y}), R_{q_1}(\hat{y})\bigr)$, where $R_q(v) = q\,v\,q^{-1}$.

### 2.2. Weighted points

A *weighted point* pairs a point of the sphere with a real weight, $(v, w)$. `TDouble2Sw` and `TDouble3Sw` implement it as records with operators, so that averaging schemes can be written as ordinary arithmetic:

```math
(p, w_1) \oplus (q, w_2) \;=\; \mathrm{Slerp}\bigl((p, w_1), (q, w_2)\bigr),
\qquad
\lambda \cdot (v, w) = (v, \lambda w),
\qquad
-(v, w) = (v, -w)
\qquad \text{(2.3)}
```

That is, `+` is the weighted spherical interpolation of §2.4, scalar multiplication and division act on the weight alone, unary minus negates the weight (so negative weights — required by Catmull–Rom and Lanczos style bases — are supported), and `A - B` is `Slerp(A, -B)`. An implicit cast lifts a bare point to weight $1$, and an explicit cast projects a weighted point back to its point.

### 2.3. Lerp and Glerp

`Lerp` is the chordal (extrinsic) weighted average of the ambient space, deliberately left unnormalized:

```math
L\bigl(p_1,\dots,p_n; w_1,\dots,w_n\bigr) = \frac{\sum_{i} w_i\, p_i}{\sum_{i} w_i}
\qquad \text{(2.4)}
```

`Glerp` — *gnomonic* linear interpolation — is (2.4) projected back onto the sphere:

```math
G\bigl(p_1,\dots,p_n; w_1,\dots,w_n\bigr) = \frac{L(\cdots)}{\bigl\lVert L(\cdots) \bigr\rVert} ,
\qquad
G(p,q) = \frac{p+q}{\lVert p+q \rVert} = \mathrm{slerp}\bigl(p,q;\tfrac12\bigr)
\qquad \text{(2.5)}
```

so the two-point form is exactly the geodesic midpoint, and the $n$-point form is the *extrinsic* spherical mean — the maximizer of $\sum_i w_i \langle g, p_i \rangle$ on the sphere. `Glerp` is also the fallback used by every `Slerp` overload when $\lvert\langle p,q\rangle\rvert > 1-\varepsilon$, where $\sin\Omega$ would underflow.

### 2.4. Slerp

Spherical linear interpolation along the great circle through $p$ and $q$ [1][4] is

```math
\mathrm{slerp}(p,q;t) = \frac{\sin\bigl((1-t)\,\Omega\bigr)}{\sin\Omega}\, p
                      + \frac{\sin\bigl(t\,\Omega\bigr)}{\sin\Omega}\, q
\qquad \text{(2.6)}
```

The library's primary form is the *weight pair*, which is what makes `Slerp` usable as the `+` of (2.3): with $W = w_1 + w_2$,

```math
S\bigl((p,w_1),(q,w_2)\bigr) = \left(
\frac{\sin\!\bigl(\tfrac{w_1}{W}\Omega\bigr)\, p + \sin\!\bigl(\tfrac{w_2}{W}\Omega\bigr)\, q}{\sin\Omega},\;\; W \right)
= \Bigl( \mathrm{slerp}\bigl(p,q;\tfrac{w_2}{W}\bigr),\; W \Bigr)
\qquad \text{(2.7)}
```

The combined weight $W$ is carried along, so folding a sequence accumulates the total weight. `ChainSlerp` is that left fold,

```math
\mathrm{ChainSlerp}(P_1,\dots,P_n) = \bigl(\cdots\bigl((P_1 \oplus P_2) \oplus P_3\bigr) \cdots \bigr) \oplus P_n
\qquad \text{(2.8)}
```

which is exact on two points but depends on the order of the operands for $n \ge 3$ — the motivation for the symmetrized operators that follow.

### 2.5. Order-symmetric folds

`PolySlerp1D` removes the order dependence of (2.8) by a binary-pyramid recursion: at each level the interior weights are halved and adjacent pairs are combined with $\oplus$,

```math
P^{(L)}_i = \tilde{P}^{(L+1)}_i \oplus \tilde{P}^{(L+1)}_{i+1},
\qquad
\tilde{P}^{(L+1)}_i =
\begin{cases}
P^{(L+1)}_i & i \in \{\, 0,\; L+1 \,\} \\
\tfrac12 P^{(L+1)}_i & \text{otherwise}
\end{cases}
\qquad \text{(2.9)}
```

so that every input reaches the apex with equal total influence, as the weight-flow diagram in the source shows:

```
Apex of the dyadic pyramid over four inputs A–D; a parent is the ⊕ of its
children, /n is the weight scaling applied to that child, and a node feeding
two parents is shown under each of them.

・4A+4B+4C+4D
  ┣・4A+3B+1C /1
  ┃  ┣・4A+2B /1
  ┃  ┃  ┣・4A /1
  ┃  ┃  ┗・4B /2
  ┃  ┗・2B+2C /2
  ┃     ┣・4B /2
  ┃     ┗・4C /2
  ┗・1B+3C+4D /1
     ┣・2B+2C /2
     ┃  ┣・4B /2
     ┃  ┗・4C /2
     ┗・2C+4D /1
        ┣・4C /2
        ┗・4D /1
```

`SymSlerp` symmetrizes the three-point case differently — it folds each cyclic rotation of the triple and takes the gnomonic average of the three results:

```math
\mathrm{SymSlerp}(V_1,V_2,V_3) = G\bigl(\,
V_1 \oplus V_2 \oplus V_3,\;\;
V_2 \oplus V_3 \oplus V_1,\;\;
V_3 \oplus V_1 \oplus V_2 \,\bigr)
\qquad \text{(2.10)}
```

### 2.6. PolySlerp on $S^2$: geodesic triangle contraction

`LUX.S2.Curve.D2.PolySlerp` computes a genuinely symmetric spherical barycenter of three points by repeatedly replacing the spherical triangle with its geodesic medial triangle. Unweighted, the step is

```math
(v_1, v_2, v_3) \;\longleftarrow\; \bigl(\, G(v_2,v_3),\; G(v_3,v_1),\; G(v_1,v_2) \,\bigr)
\qquad \text{(2.11)}
```

and the candidate $m = L(v_1,v_2,v_3)$ is returned as soon as $\lVert m \rVert^2 > 1-\varepsilon$, i.e. when the triangle has collapsed. In the weighted case the edges are contracted by the weighted `Slerp` of (2.7) and the weights are averaged pairwise:

```math
v_{23} = S(v_2,v_3; w_2,w_3), \quad w_{23} = \tfrac12 (w_2+w_3)
\qquad \text{(cyclically)} \qquad \text{(2.12)}
```

Each contraction roughly halves the triangle diameter, so convergence is linear; the loop is capped at $10\,000$ iterations. The resulting map $(w_1 : w_2 : w_3) \mapsto S^2$ is a spherical barycentric coordinate system over the geodesic triangle: vertices map to themselves and each edge is traversed as an exact `Slerp`.

### 2.7. AveVecs: tangent-plane iteration

`AveVecs` starts from the `Glerp` mean $g$ and repeatedly corrects it with the weighted average of the tangential components of the inputs:

```math
P_i = v_i - \langle g, v_i \rangle\, g,
\qquad
V_\Delta = L(P_1,P_2,P_3; w_1,w_2,w_3),
\qquad
g \;\longleftarrow\; \frac{g + V_\Delta}{\lVert g + V_\Delta \rVert}
\qquad \text{(2.13)}
```

stopping when $\lVert V_\Delta \rVert^2 < \varepsilon$. The stationary condition $V_\Delta = 0$ says that $\sum_i w_i v_i$ has no component tangent to the sphere at $g$, i.e. that $g \parallel \sum_i w_i v_i$ — so the fixed point is precisely the extrinsic mean (2.5), and the iteration is a refinement of it rather than an independent operator. Note that the intrinsic (Riemannian / Karcher) mean of Buss and Fillmore [2] uses the logarithmic map, whose tangent vector carries the extra factor $\Omega / \sin\Omega$; it is *not* what (2.13) computes.

### 2.8. Operators specific to $S^3$

Because $S^3$ is a group, the geodesic through $q_0$ and $q_1$ can be written with the quaternion power $q^t = \exp(t \ln q)$, which is how `PowSlerp` evaluates it:

```math
\mathrm{PowSlerp}(q_0,q_1;t) = q_0 \left( q_0^{-1} q_1 \right)^{t}
\qquad \text{(2.14)}
```

`ChainPowSlerp` folds the weighted-point form, $t = w_2 / (w_1+w_2)$, exactly as (2.8) does. Averaging can also be performed in the Lie algebra: `ExpMap` transports the inputs to it with $\ln$, averages linearly, and transports the result back [3],

```math
\mathcal{B}_{\mathrm{ExpMap}} = \exp\!\left( \frac{1}{W} \sum_i w_i \ln q_i \right),
\qquad W = \sum_i w_i
\qquad \text{(2.15)}
```

which is cheap but biased toward the identity, because the tangent space is anchored there. `ModExpMap` removes most of that bias by anchoring the tangent space at the `Glerp` mean $g$ instead:

```math
\mathcal{B}_{\mathrm{ModExpMap}} = g\, \exp\!\left( \frac{1}{W} \sum_i w_i \ln\bigl( g^{-1} q_i \bigr) \right)
\qquad \text{(2.16)}
```

When $\lvert W \rvert < \varepsilon$ both operators fall back to the unweighted sum of logarithms.

## 3. Architecture

Types — the sphere layer is a thin set of aliases and record helpers over the LUX linear algebra:

```
Point types — an alias is the child of the LUX type it renames

・LUX.D3
  ┗・TDouble3D
     ┗・TDouble2S             ･･･ alias; point of S²  [LUX.S2]
        ┗・HDouble2S.Unitor   ･･･ record helper
・LUX.Quaternion
  ┗・TDoubleQ
     ┗・TDouble3S             ･･･ alias; point of S³  [LUX.S3]
        ┗・HDouble3S.Unitor   ･･･ record helper

Weighted points  [LUX.S2.Curve / LUX.S3.Curve]

・LUX.Curve
  ┣・TDoubleWector<TDouble2S>
  ┃  ┗・TDoubleW2S           ･･･ alias; weighted point (v, w), plain record
  ┃     ┗・HDoubleW2S.Unitor ･･･ record helper
  ┗・TDoubleWector<TDouble3S>
     ┗・TDoubleW3S            ･･･ alias; weighted point (v, w), plain record
        ┗・HDoubleW3S.Unitor  ･･･ record helper

Weighted points with operators — Implicit / Explicit casts convert between
TDoubleW2S / TDoubleW3S and TDouble2Sw / TDouble3Sw

・TDouble2Sw / TDouble3Sw
  ┣・+ = Slerp
  ┣・- = Slerp with negated weight
  ┣・λ* , /λ = weight scaling
  ┗・Implicit( TDouble2S ) ⇒ w = 1
```

Routines — one unit per averaging operator, all of them free functions overloaded on the four point kinds (`2S`, `W2S`, `2Sw`, and the `3S` family):

```
S²  LUX.S2.Curve.Lerp ........ Lerp        chordal average, unnormalized       (2.4)
    LUX.S2.Curve.Glerp ....... Glerp       normalized chordal average          (2.5)
    LUX.S2.Curve.Slerp ....... Slerp       weighted great-circle interpolation (2.7)
                               ChainSlerp  left fold of ⊕                      (2.8)
    LUX.S2.Curve.PolySlerp ... PolySlerp1D dyadic pyramid of ⊕                 (2.9)
    …Curve.D2.SymSlerp ....... SymSlerp    cyclic symmetrization               (2.10)
    …Curve.D2.PolySlerp ...... PolySlerp   geodesic triangle contraction       (2.11)
    …Curve.D2.AveVecs ........ AveVecs     tangent-plane iteration             (2.13)

S³  LUX.S3.Curve.Glerp / .Slerp / .PolySlerp .... same three families on S³
    LUX.S3.Curve.PowSlerp .... PowSlerp, ChainPowSlerp   quaternion power      (2.14)
    LUX.S3.Curve.ExpMap ...... ExpMap      log-domain average                  (2.15)
    LUX.S3.Curve.ModExpMap ... ModExpMap   log-domain average at the G mean    (2.16)
```

Classes — point containers and FireMonkey shapers:

```
・TPoins<_TPoin_>                                ･･･ [LUX.Data.Grid.D1]
  ┣・TLoopPoins<_TPoin_>                        ･･･ closed loop; index wraps
  ┃  ┣・TLoopPoins2S = TLoopPoins<TDouble2S>   ･･･ [LUX.S2.Data.Grid.D1]
  ┃  ┃  ┗・TPolyPoins2S04 / 06 / 08 / 12 / 20 ･･･ Platonic solid vertices
  ┃  ┗・TLoopPoins3S = TLoopPoins<TDouble3S>   ･･･ [LUX.S3.Data.Grid.D1]
  ┃     ┗・TPolyPoins3S                        ･･･ lifts a 2S loop to S³
  ┃        ┗・TPolyPoins3S04 / 06 / 08 / 12 / 20
  ┗・TPlots<_TPoin_>                            ･･･ arc-length resampling
     ┣・TPlots2S                                ･･･ Distance = Angle(p₀, p₁)
     ┗・TPlots3S                                ･･･ Distance = ∠(q₀ŷ, q₁ŷ)

・TF3DShaper                                     ･･･ [LUX.FMX.Graphics.D3]
  ┗・TPoins3D                                   ･･･ one sphere per point
     ┗・THemiPoins3D                            ･･･ hemisphere topology
        ┣・THemiPoinsLo3D
        ┗・THemiPoinsUp3D                       ･･･ in both S2.FMX and S3.FMX

[LUX.Sphere.FMX] — FireMonkey scene wrappers
・TF3DWorld
  ┗・TWorld3D
・TF3DCamera
  ┗・TCamera3D                                  ･･･ Radius / AngleX/Y orbit
・TF3DLight
  ┗・TLight3D
・TF3DSphere
  ┗・TSphere3D
```

File layout:

```
・LUX.Sphere/
  ┣・S2/                                                    ･･･ the 2-sphere
  ┃  ┣・LUX.S2.pas                                         ･･･ TDouble2S etc.
  ┃  ┣・Curve/                                             ･･･ weighted points
  ┃  ┃  ┣・LUX.S2.Curve.pas                               ･･･ TDouble2Sw etc.
  ┃  ┃  ┣・LUX.S2.Curve.{Lerp,Glerp,Slerp,PolySlerp}.pas
  ┃  ┃  ┗・D2/                                            ･･･ 3-point ops
  ┃  ┃     ┗・LUX.S2.Curve.D2.{PolySlerp,SymSlerp,AveVecs}.pas
  ┃  ┣・Data/Grid/                                         ･･･ point grids
  ┃  ┗・FMX/LUX.S2.FMX.pas                                 ･･･ shapers
  ┣・S3/                                                    ･･･ S³ counterpart
  ┃  ┣・LUX.S3.pas, Curve/…, Data/Grid/…, FMX/LUX.S3.FMX.pas
  ┃  ┗・Curve/LUX.S3.Curve.{PowSlerp,ExpMap,ModExpMap}.pas ･･･ S³-only ops
  ┗・FMX/LUX.Sphere.FMX.pas                                 ･･･ scene wrappers
```

## 4. Usage

```pascal
uses LUX, LUX.D3, LUX.Quaternion,
     LUX.S2, LUX.S2.Curve, LUX.S2.Curve.Glerp, LUX.S2.Curve.Slerp,
     LUX.S2.Curve.D2.PolySlerp,
     LUX.S3, LUX.S3.Curve, LUX.S3.Curve.ModExpMap;

var
   P1, P2, P3, M :TDouble2S;
   A, B :TDouble2Sw;
   Qs :TArray<TDoubleW3S>;
   Q :TDouble3S;
begin
     P1 := TDouble3D.IdentityX;
     P2 := TDouble3D.IdentityY;
     P3 := TDouble3D.IdentityZ;

     M := Slerp( P1, P2, 0.25 );                  // a quarter of the way along the arc
     M := Glerp( P1, P2 );                        // geodesic midpoint
     M := PolySlerp( P1, P2, P3, 1, 2, 3 );       // spherical barycenter, weights 1:2:3

     A := P1;                                     // implicit cast: weight 1
     B := 2 * TDouble2Sw.Create( P2, 1 );         // weight 2
     M := TDouble2S( A + B );                     // '+' is the weighted Slerp

     // S³: a weighted average of three rotations, in the tangent space at the Glerp mean
     Qs := [ TDoubleW3S.Create( TDouble3S.Rotate( TDouble3D.IdentityX, 0.0    ), 1 ),
             TDoubleW3S.Create( TDouble3S.Rotate( TDouble3D.IdentityY, Pi/2   ), 2 ),
             TDoubleW3S.Create( TDouble3S.Rotate( TDouble3D.IdentityZ, Pi/2*3 ), 1 ) ];

     Q := ModExpMap( Qs ).Unitor.v;

     WriteLn( Angle( Q.Trans( TDouble3D.IdentityY ), P2 ) );   // geodesic error, radians
end;
```

Weights need not sum to $1$: every operator divides by the total weight (or falls back to an unweighted form when that total is below $\varepsilon$), and the resulting weight is carried in the `w` field so that the value can be folded further.

## 5. Requirements

* **Delphi / RAD Studio** — generics, record helpers and operator overloading are used throughout. The `S2/` and `S3/` core units are plain Object Pascal; the `FMX/` units require FireMonkey.
* **[LUX](https://github.com/LUXOPHIA/LUX)** base library — `LUX` (epsilon constants), `LUX.D3` (`TDouble3D`, `Angle`, `DotProduct`), `LUX.Quaternion` (`TDoubleQ`, `Ln`, `Exp`, `Pow`, `Rotate`, `Trans`), `LUX.Curve` (`TDoubleWector<>`), `LUX.Data.Grid.D1` (`TPoins<>`, `TLoopPoins<>`) and `LUX.Curve.Data.Grid.D1.Plots` (`TPlots<>`).
* **[LUX.FMX.Graphics.D3](https://github.com/LUXOPHIA/LUX.FMX.Graphics.D3)** — required only by the `FMX` units, which derive from `TF3DShaper`, `TF3DWorld`, `TF3DCamera`, `TF3DLight` and `TF3DSphere`.

The library is consumed as a `git subtree` by the sample applications [PolySlerp](https://github.com/LUXOPHIA/PolySlerp) (spherical barycentric grids on $S^2$), [SphericalCurve](https://github.com/LUXOPHIA/SphericalCurve) (curve schemes on $S^2$) and [QuaternionCurve](https://github.com/LUXOPHIA/QuaternionCurve) (curve schemes on $S^3$), which compare the averaging operators of §2 against each other.

## 6. References

1. Shoemake, K., [*Animating Rotation with Quaternion Curves*](https://doi.org/10.1145/325334.325242), SIGGRAPH '85, pp. 245–254, 1985.
2. Buss, S. R. and Fillmore, J. P., [*Spherical Averages and Applications to Spherical Splines and Interpolation*](https://doi.org/10.1145/502122.502124), ACM Transactions on Graphics, 20(2), pp. 95–126, 2001.
3. Kim, M.-J., Kim, M.-S. and Shin, S. Y., [*A General Construction Scheme for Unit Quaternion Curves with Simple High Order Derivatives*](https://doi.org/10.1145/218380.218486), SIGGRAPH '95, pp. 369–376, 1995.
4. [*Slerp*](https://en.wikipedia.org/wiki/Slerp), Wikipedia.
5. [*Fréchet mean*](https://en.wikipedia.org/wiki/Fr%C3%A9chet_mean), Wikipedia.

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
