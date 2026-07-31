# PolySlerp1DxS3

[English](README.md) | [日本語](ja/README.md)

**PolySlerp1DxS3** is the official sample program of the paper *"PolySlerp: Spherical Polygon Linear Interpolation"* [1] — an interactive FireMonkey (Delphi) application for constructing and comparing **curves of unit quaternions** — smooth one-parameter families of 3D rotations — on the unit 3-sphere $S^3$. Five spline schemes (Linear, Bézier, B-Spline, Catmull-Rom, Lanczos) are combined with six spherical weighted-averaging ("barycenter") operators (GLerp, Slerp, PowSlerp, PolySlerp, ExpMap, ModExpMap), and two independently configured curves are rendered simultaneously over a textured globe for direct visual comparison.

<!-- TODO: screenshot -->

## 利用ライブラリ

* [**LUX**](https://github.com/LUXOPHIA/LUX) ：The LUXOPHIA standard library providing basic mathematical types such as vectors, matrices, and quaternions.
* [**LUX.FMX.Graphics.D3**](https://github.com/LUXOPHIA/LUX.FMX.Graphics.D3) ：A 3D graphics helper library built on the FireMonkey framework.
* [**LUX.Sphere**](https://github.com/LUXOPHIA/LUX.Sphere) ：A spherical geometry library for curves and barycenter operations on the spheres $S^2$ and $S^3$.

## 1. Overview

* **Control loops**: closed loops of $N \in \{4, 6, 8, 12, 20\}$ control quaternions (`TPolyPoins3S04` … `TPolyPoins3S20`). Each loop is derived from a closed loop of $N$ points on the 2-sphere (`TPolyPoins2S04` … `TPolyPoins2S20`): every anchor starts as the rotation carrying the pole vector $\hat{y}$ onto its loop point, composed with a random twist about $\hat{y}$; the twists are then relaxed by iterated degree-4 B-spline smoothing (built from repeated slerp steps, `TPolyPoins3S.BSpline4`), re-pinning each axis to its loop point on every pass, until the loop of orientations converges.
* **Curve = spline scheme × barycenter operator**: every spline scheme is written so that each evaluation is a *weighted barycenter* of control quaternions. The averaging rule is pluggable — the same Bézier or B-spline weights can be averaged by six different spherical methods, which produce visibly different curves.
* **Two curves at once**: an *Upper Curve* and a *Lower Curve* are configured independently. Their sample dots are drawn as complementary hemisphere caps (`THemiPoinsUp3D` / `THemiPoinsLo3D`), so the two curves remain distinguishable even where they coincide.
* **Rotation visualization**: a quaternion $q$ is displayed at the point $R\,(q\,\hat{y}\,q^{-1})$ on a globe of radius $R$, as a small textured sphere oriented by the full rotation of $q$ — the position shows the image of the rotation axis and the texture orientation shows the twist around it.
* **Arc-length-uniform sampling**: `TPlots3S` resamples each curve at equal angular steps, with the step (`PlotGap`) chosen from the dot size so that successive dots just touch.
* **Twist stress-test**: a slider applies an alternating twist of $\pm\tau$ ($\tau \in [-90^\circ, +90^\circ]$) to consecutive control quaternions about their local axes, exposing the different behaviors of the averaging operators.

## 2. Mathematical Background

### 2.1 Unit quaternions and rotations

A unit quaternion $q = w + x\,\mathbf{i} + y\,\mathbf{j} + z\,\mathbf{k}$ with $\lVert q \rVert = 1$ lies on the 3-sphere $S^3 \subset \mathbb{H}$ and acts on a vector $v \in \mathbb{R}^3$ (a pure imaginary quaternion) as a rotation [5]:

```math
R_q(v) = q\,v\,q^{-1} \tag{1}
```

The application identifies the type `TDouble3S` (a point of $S^3$) with the quaternion type `TDoubleQ`, and displays $q$ at $R \cdot R_q(\hat{y})$ on the globe (`TDoubleQ.Trans`, `Scene.pas`).

### 2.2 Slerp and weighted slerp

Spherical linear interpolation between $p, q \in S^3$ with $\cos\theta = \langle p, q \rangle$ is [2][4]

```math
\mathrm{Slerp}(p, q; t) = \frac{\sin\bigl((1-t)\,\theta\bigr)\,p + \sin(t\,\theta)\,q}{\sin\theta} \tag{2}
```

The code (`LUX.S3.Curve.Slerp`) generalizes this to *weighted points* $(p, w_1)$, $(q, w_2)$ with arbitrary real weights. With $W = w_1 + w_2$:

```math
(p, w_1) \oplus (q, w_2)
= \left( \frac{\sin\bigl(\tfrac{w_1}{W}\theta\bigr)\,p + \sin\bigl(\tfrac{w_2}{W}\theta\bigr)\,q}{\sin\theta},\; W \right) \tag{3}
```

which equals $\mathrm{Slerp}(p, q;\, w_2/W)$ carrying the combined weight $W$. Nearly parallel inputs fall back to normalized linear interpolation. Signed weights are supported (`TDouble3Sw` negates the weight under unary minus), which is required by the Catmull-Rom and Lanczos schemes whose basis functions have negative lobes.

### 2.3 Exponential and logarithm maps

Identifying pure imaginary quaternions with the Lie algebra $\mathfrak{so}(3)$, the exponential map $\exp : \mathfrak{so}(3) \to S^3$ and its inverse are

```math
\exp(\theta\,\hat{n}) = \cos\theta + \hat{n}\,\sin\theta,
\qquad
\ln\bigl(\cos\theta + \hat{n}\,\sin\theta\bigr) = \theta\,\hat{n} \tag{4}
```

`LUX.Quaternion` implements the general versions on $\mathbb{H}$ ($\ln q = \ln\lVert q \rVert + \operatorname{atan2}(\lVert \mathbf{v} \rVert, w)\,\hat{\mathbf{v}}$, and the corresponding $\exp$, with `Pow(q, t) = Exp(t·Ln(q))`).

### 2.4 Barycenter operators

Each curve evaluation reduces to a weighted barycenter $\mathcal{B}\bigl(\{(q_i, w_i)\}_{i=1}^{n}\bigr)$ of unit quaternions. Six operators are implemented (`LIB.Bary.S3.*` delegating to `LUX.S3.Curve.*`):

| Operator | Definition |
|---|---|
| **GLerp** | Gnomonic (normalized) linear average, eq. (5) — the *mGlerp* of [1] |
| **Slerp** | Left-fold of the weighted binary slerp (3): $\bigl(\cdots\bigl((q_1,w_1) \oplus (q_2,w_2)\bigr) \oplus \cdots\bigr) \oplus (q_n,w_n)$ — the order-dependent *cSlerp* of [1] |
| **PowSlerp** | Left-fold of the geodesic step (6) using quaternion power |
| **PolySlerp** | Order-symmetrized dyadic recursion of $\oplus$, eq. (7) — the *PolySlerp-2* (interior-correction summation) of [1] |
| **ExpMap** | Log-domain linear average, eq. (8) |
| **ModExpMap** | Log-domain average in a tangent space centered at the GLerp mean, eq. (9) |

```math
\mathcal{B}_{\mathrm{GLerp}} = \frac{\sum_i w_i\,q_i}{\bigl\lVert \sum_i w_i\,q_i \bigr\rVert} \tag{5}
```

```math
(p, w_1) \oplus_{\mathrm{pow}} (q, w_2) = \Bigl( p\,\bigl(p^{-1} q\bigr)^{w_2 / (w_1+w_2)},\; w_1 + w_2 \Bigr),
\qquad q^{t} = \exp\bigl(t \ln q\bigr) \tag{6}
```

**PolySlerp** (`PolySlerp1D`) removes the order dependence of the chained fold by a binary-pyramid recursion — the *type-2 (interior-correction) summation* of [1], i.e. **PolySlerp-2**: at each level the interior weights are halved and adjacent pairs are combined with $\oplus$ from (3),

```math
P^{(L)}_i = \tilde{P}^{(L+1)}_i \oplus \tilde{P}^{(L+1)}_{i+1},
\qquad
\tilde{P}^{(L+1)}_i = \begin{cases} P^{(L+1)}_i & i \in \{0, L+1\} \\ \tfrac{1}{2} P^{(L+1)}_i & \text{otherwise} \end{cases} \tag{7}
```

as illustrated by the weight-flow diagram in the source (Fig. 3(c) of [1]):

```
Weight flow for n = 4 points A–D — each node is the ⊕ of its two children,
"/k" is the factor the node is scaled by before it is fed to its parent
(end entries /1, interior entries /2, per the tilde in eq. (7))

・4A+4B+4C+4D       ･･･ level 0 : result
  ┣・4A+3B+1C /1   ･･･ level 1
  ┃  ┣・4A+2B /1  ･･･ level 2
  ┃  ┃  ┣・4A /1 ･･･ level 3 : control point A
  ┃  ┃  ┗・4B /2 ･･･ level 3 : control point B
  ┃  ┗・2B+2C /2  ･･･ level 2
  ┃     ┣・4B /2
  ┃     ┗・4C /2
  ┗・1B+3C+4D /1   ･･･ level 1
     ┣・2B+2C /2   ･･･ level 2 : the same node as above (shared)
     ┃  ┣・4B /2
     ┃  ┗・4C /2
     ┗・2C+4D /1   ･･･ level 2
        ┣・4C /2   ･･･ level 3 : control point C
        ┗・4D /1   ･･･ level 3 : control point D
```

**ExpMap** averages in the log domain (cf. the exp/log curve constructions of [3]); as noted in [1], the result depends on the base point of the projection, so it is only an approximate average:

```math
\mathcal{B}_{\mathrm{ExpMap}} = \exp\!\left( \frac{1}{W} \sum_i w_i \ln q_i \right),
\qquad W = \sum_i w_i \tag{8}
```

**ModExpMap** first computes the GLerp mean $g$ from (5) and averages in the tangent space at $g$ — exactly the base-point choice recommended in [1] — largely removing the bias of (8):

```math
\mathcal{B}_{\mathrm{ModExpMap}} = g\,\exp\!\left( \frac{1}{W} \sum_i w_i \ln\bigl(g^{-1} q_i\bigr) \right) \tag{9}
```

### 2.5 Spline schemes

All schemes (`LIB.Curve.*`, generic over the point type) express one segment as a barycenter of consecutive control points. Where two algorithms are offered, *Basis Function* evaluates one $n$-ary barycenter with basis weights, while *Recursive Lerp* applies the classical pairwise recursion using binary barycenters — for non-flat averaging operators these are **not** equivalent, and the difference can be inspected in the viewer.

| Scheme | Basis-function form | Recursive form |
|---|---|---|
| Linear | $\mathcal{B}\bigl((p_i, 1-t), (p_{i+1}, t)\bigr)$ | — |
| Bézier (degree $n$) | weights $b_{j,n}(t) = \binom{n}{j} t^j (1-t)^{n-j}$, eq. (10) | de Casteljau recursion |
| B-Spline (degree $n$) | uniform B-spline basis weights | de Boor recursion, $s = \tfrac{t+N-j}{N+1}$ |
| Catmull-Rom | cubic Catmull-Rom weights over 4 points (signed) | Barry–Goldman-style pyramid |
| Lanczos (radius $a$) | $L(x) = \operatorname{sinc}(x)\operatorname{sinc}(x/a)$ for $\lvert x \rvert < a$ (signed) | — |

```math
C(t) = \mathcal{B}\Bigl( \bigl\{ \bigl(p_{i+j},\; b_{j,n}(t)\bigr) \bigr\}_{j=0}^{n} \Bigr) \tag{10}
```

### 2.6 Arc-length resampling

`TPlots3S` measures the length of a curve as the accumulated angle between consecutive rotated axis vectors, $d(q_0, q_1) = \angle\bigl(R_{q_0}(\hat{y}),\, R_{q_1}(\hat{y})\bigr)$, over a 1024-edge table, then places sample points at equal arc-length intervals `PlotGap` $= 2 \arcsin(r_{\mathrm{dot}} / R)$, so that adjacent dots exactly touch on screen.

## 3. Architecture

```
[1] Ownership — Main.pas

・TForm1
  ┣・_Poins3S :TPolyPoins3S     ･･･ control-quaternion loop
  ┣・_Bary3S :TDoubleBary3S ×6 ･･･ the six barycenter operators
  ┣・_Curve3S0 :TCurve3S ×5    ･･･ the five spline schemes (Lower Curve)
  ┣・_Curve3S1 :TCurve3S ×5    ･･･ the five spline schemes (Upper Curve)
  ┣・_Plots3S0 :TPlots3S        ･･･ arc-length resampling of _Curve3S0
  ┗・_Plots3S1 :TPlots3S        ･･･ arc-length resampling of _Curve3S1

[2] Scene graph — Scene.pas, inside TViewport3D (LUX.Sphere.FMX / LUX.S3.FMX)

・TWorld3D
  ┣・TCamera3D
  ┃  ┗・TLight3D
  ┣・TSphere3D                  ･･･ globe
  ┣・TPoins3D                   ･･･ ← _Poins3S
  ┣・THemiPoinsLo3D             ･･･ ← _Plots3S0
  ┗・THemiPoinsUp3D             ･･･ ← _Plots3S1

[3] Data flow — Main.pas model → Scene.pas mesh

・_Poins3S :TPolyPoins3S
  ┣・TPoins3D                   ･･･ control-point dots
  ┣・_Curve3S0 :TCurve3S ×5
  ┃  ┗・_Plots3S0 :TPlots3S
  ┃     ┗・THemiPoinsLo3D      ･･･ lower-hemisphere dots
  ┗・_Curve3S1 :TCurve3S ×5
     ┗・_Plots3S1 :TPlots3S
        ┗・THemiPoinsUp3D       ･･･ upper-hemisphere dots

[4] Class hierarchy — control points, sampling (Q = TDouble3S, unit quaternion)

・TPoins<Q>
  ┣・TLoopPoins<Q>
  ┃  ┗・TPolyPoins3S
  ┃     ┣・TPolyPoins3S04      ･･･ (4 points)
  ┃     ┣・TPolyPoins3S06      ･･･ (6 points)
  ┃     ┣・TPolyPoins3S08      ･･･ (8 points)
  ┃     ┣・TPolyPoins3S12      ･･･ (12 points)
  ┃     ┗・TPolyPoins3S20      ･･･ (20 points)
  ┗・TPlots<Q>
     ┗・TPlots3S                ･･･ arc-length resampler

[5] Class hierarchy — curves and barycenter operators

・TCurve<Q>
  ┗・TCurveAlgo<Q>              ･･･ Bary property references a TBarycenter<Q>
     ┣・TCurveLinear<Q>         ･･･ (TCurveLinear3S)
     ┣・TCurveBezier<Q>         ･･･ (TCurveBezier3S)
     ┣・TCurveBSpline<Q>        ･･･ (TCurveBSpline3S)
     ┣・TCurveCatmullRom<Q>     ･･･ (TCurveCatmullRom3S)
     ┗・TCurveLanczos<Q>        ･･･ (TCurveLanczos3S)

・TBarycenter<Q> (TDoubleBary3S)
  ┣・TBaryGLerp3S
  ┣・TBarySlerp3S
  ┣・TBaryPowSlerp3S
  ┣・TBaryPolySlerp3S
  ┣・TBaryExpMap3S
  ┗・TBaryModExpMap3S
```

```
・PolySlerp1DxS3/
  ┣・PolySlerp1DxS3.dpr         ･･･ program entry
  ┣・PolySlerp1DxS3.dproj       ･･･ RAD Studio project (Win32 / Win64)
  ┣・Main.pas / Main.fmx        ･･･ main form: UI controls and model wiring
  ┣・Scene.pas                  ･･･ 3D scene construction (globe, dots, camera)
  ┣・_DATA/                     ･･･ textures (globe, dot markers; Git LFS)
  ┗・_LIBRARY/                  ･･･ vendored libraries (reference only)
     ┣・Bary/                   ･･･ TBarycenter<> and the six S³ operators
     ┣・Curve/                  ･･･ generic spline schemes and S³ aliases
     ┗・LUXOPHIA/
        ┣・LUX/                 ･･･ scalar/vector/quaternion/basis functions
        ┣・LUX.Sphere/          ･･･ S²/S³ point grids, curves, FMX meshes
        ┗・LUX.FMX.Graphics.D3/ ･･･ 3D mesh shaper base classes
```

## 4. Usage / Controls

| Control | Effect |
|---|---|
| Viewport, left-drag | Orbit the camera around the globe |
| **Points › Count** | Number of control quaternions in the loop: `04` / `06` / `08` / `12` / `20` |
| **Points › Twist Angle** | Alternating $\pm\tau$ twist of the control orientations about their local axes, $\tau \in [-90^\circ, +90^\circ]$ |
| **Upper/Lower Curve › Kind** | Spline scheme: `Linear` / `Bezier` / `B-Spline` / `Catmull-Rom` / `Lanczos` |
| **Upper/Lower Curve › Barycenter** | Averaging operator: `GLerp` / `Slerp` / `PowSlerp` / `PolySlerp` / `ExpMap` / `ModExpMap` |
| **Algorithm** (per scheme tab) | `Basis Function` (one $n$-ary barycenter) or `Recursive Lerp` (pairwise recursion); available for Bézier, B-Spline, Catmull-Rom |
| **Degree** (Bézier, B-Spline) | Basis degree $n$, 1–10 |
| **Width** (Lanczos) | Window radius $a$, 1–10 |

The *Upper Curve* is drawn with upper-hemisphere dots, the *Lower Curve* with lower-hemisphere dots; the larger dots are the shared control points.

## 5. Building

1. Requirements: RAD Studio (Delphi) with the FireMonkey framework; the project file uses format version 20.4. Target platforms defined in `PolySlerp1DxS3.dproj`: **Win32** and **Win64**.
2. Clone with Git LFS enabled (`git lfs install`) — the textures in `_DATA/` are stored in LFS.
3. Open `PolySlerp1DxS3.dproj`, select a platform, and run. All library units are vendored under `_LIBRARY/`; no external packages are required.
4. The application loads textures from `..\..\_DATA\` relative to the executable, which matches the default output directory layout (e.g. `Win64\Debug\`). Keep that relative location if you move the binary.

## 6. References

1. M. Nakayama and I. Fujishiro, ["PolySlerp: Spherical Polygon Linear Interpolation"](https://cir.nii.ac.jp/crid/1390026970010384512), *The Journal of the Institute of Image Electronics Engineers of Japan*, 54(4), pp. 384–393, 2025 (in Japanese). [[PDF](https://www.iieej.org/wordpress/wp-content/uploads/2025/11/IIEEJ_Vol54-No4_web_v1.pdf)]
2. K. Shoemake, ["Animating Rotation with Quaternion Curves"](https://doi.org/10.1145/325334.325242), *SIGGRAPH '85*, pp. 245–254, 1985.
3. M.-J. Kim, M.-S. Kim, S. Y. Shin, ["A General Construction Scheme for Unit Quaternion Curves with Simple High Order Derivatives"](https://doi.org/10.1145/218380.218486), *SIGGRAPH '95*, pp. 369–376, 1995.
4. Wikipedia: [Slerp](https://en.wikipedia.org/wiki/Slerp)
5. Wikipedia: [Quaternions and spatial rotation](https://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation)

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
