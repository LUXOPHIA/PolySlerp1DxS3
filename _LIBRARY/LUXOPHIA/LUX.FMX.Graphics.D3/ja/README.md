# LUX.FMX.Graphics.D3

[English](../README.md) | [日本語](README.md)

FireMonkey の３Ｄフレームワークをベースとした、Delphi 用の３Ｄグラフィックスライブラリ。FireMonkey の `TControl3D`・`TCamera`・`TLight` を、姿勢を LUX の 4×4 行列で表す Y 軸上向きのワールドのノードとして包み、手続き的に生成するメッシュのための更新フラグ方式のビルド機構を加える。

## 利用ライブラリ

* [**LUX**](https://github.com/LUXOPHIA/LUX) ：ベクトル型・行列型 `TSingle3D`・`TSingleM4` を提供する基底ライブラリ。

## 1. 概要

FireMonkey は既に、ルートの `TViewport3D`・その下の `TControl3D` 派生・`TMeshData` とマテリアルソースによる描画からなる３Ｄシーン木を備えている [1][2]。本ライブラリはその上に載る薄い適応層であり、目的は3つある。

1. **姿勢を行列で扱う。** 各ノードは `LocaPose` / `AbsoPose`（いずれも `Pose` として別名を持つ）を `TSingleM4` として、`LocaPos` / `AbsoPos`（別名 `Pos`）を `TSingle3D` として公開する。FireMonkey の `Position` / `RotationAngle` / `Scale` の三点セットの代わりである。`LocaPose` への書き込みは `FLocalMatrix` を直接代入し、続いて `RecalcAbsolute`・`RebuildRenderingList`・`Repaint` を呼ぶ。寸法も同様に `Width` / `Height` / `Depth` の上に `SizeX` / `SizeY` / `SizeZ` として再公開される。
2. **Y 軸上向きのワールド。** `TViewport3D` から直接生成される `TF3DWorld` は自身の姿勢を `TSingleM4.Scale( +1, -1, -1 )` とするため、その下のすべては ＋Y が画面上方向・＋Z が視点方向を向く座標系に属する。`TF3DCamera` は `Scale.Y = Scale.Z = -1` を持つ FireMonkey の `TCamera` を内部に所有し、カメラ自身の軸に同じ反転を再適用する。
3. **モデルの遅延構築。** `TF3DObject.BeforeRender` は `upModel` フラグが立っていれば `MakeModel` を呼んでフラグを下ろす。`TF3DShaper` はこれを `MakeGeometry`（頂点バッファ）と `MakeTopology`（インデックスバッファ）に分け、それぞれを専用のフラグ（`upGeometry`・`upTopology`）で守る。プロパティのセッタはフラグを立てるだけなので、セッタを連続で呼んでも再構築は次フレームの1回で済む。

全ノードに共通する便宜が2つある。コンストラクタは `Owner` が `TControl3D` であればそこへ自動的に所属し、`TF3DObject` は `HitTest := False` を設定して補助ノードをマウスのピッキングから外す。

## 2. 数学的背景

### 2.1 4×4 行列としての姿勢、および2つの規約

LUX の `TSingleM4` は列ベクトルに作用し、平行移動成分は第4列に置かれる。

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

第1〜第3列は局所座標軸の像（`AxisX`, `AxisY`, `AxisZ`）、第4列は局所原点の像（`AxisP`）である。FireMonkey の `TMatrix3D` は行ベクトルに作用するため、両型の間の型変換は転置となる。

```math
M_{\mathrm{FMX}} = M^{\mathsf T}
\tag{2}
```

したがって `AbsoPose` の読み出しは、FireMonkey がシーン木に沿って蓄積する `TControl3D.AbsoluteMatrix` の転置を返す。(1) の規約でその蓄積は次のように書ける。

```math
M^{\mathrm{a}}_{k} = M^{\mathrm{a}}_{\pi(k)}\, M^{\mathrm{l}}_{k}
\tag{3}
```

ここで $\pi(k)$ はノード $k$ の親である。

### 2.2 ワールドの反転

`TF3DWorld` は次を設定する。

```math
M_{\mathrm{world}} = S(+1,-1,-1) = \operatorname{diag}(1,-1,-1,1)
\tag{4}
```

FireMonkey のビューポート座標系は ＋X が右・＋Y が下・＋Z が視点から遠ざかる向きである。(4) は Y 軸と Z 軸を反転させるため、ワールドノードの座標系では ＋Y が上・＋Z が視点方向を向く。$\det \operatorname{diag}(1,-1,-1) = +1$ であるから (4) は X 軸まわりの $\pi$ 回転であり、基底の向き（掌性）は保たれる。`TF3DCamera` の内部 `TCamera` は自身の `Scale` に同じ反転を持ち、視軸については (4) を打ち消す。

### 2.3 図形の描画変換

`TF3DShaper.Render` は、ノードの寸法を局所側に畳み込んだ絶対行列を描画コンテキストの行列とする。(1) の規約では次のようになる。

```math
M^{\mathrm{r}}_{k} = M^{\mathrm{a}}_{k}\; S\!\left( S_x, S_y, S_z \right)
\tag{5}
```

したがって形状は局所座標系で単位スケールで一度だけ作られ、頂点バッファに触れることなく `SizeX` / `SizeY` / `SizeZ` で伸縮される。

### 2.4 球のメッシュ

`TF3DSphere` は単位球を $(D_x{+}1) \times (D_y{+}1)$ の格子で標本化する。

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

ここで $0 \le x \le D_x$、$0 \le y \le D_y$ であり、頂点バッファへの平坦化は次で行う。

```math
i(x,y) = (D_x + 1)\,y + x
\tag{7}
```

$\lVert \mathbf{p} \rVert = 1$ であるから、位置はそのまま外向き法線を兼ねる。テクスチャ座標は正規化した格子添字 $(x/D_x,\; y/D_y)$ である。継ぎ目の列 $x = D_x$ は $x = 0$ と同じ位置を複製しつつ $u = 0$ ではなく $u = 2\pi$ を担うため、テクスチャは不連続なく巻き付く。格子の各四角形は2つの三角形を生むので、インデックスバッファの要素数は

```math
N_{\mathrm{index}} = 6\, D_x D_y
\tag{8}
```

であり、既定値は $D_x = 36$、$D_y = 18$ である。

## 3. アーキテクチャ

### 3.1 クラス

```
・TControl3D  (FMX)
  ┗・TF3DObject       ･･･ Pose :TSingleM4, Pos :TSingle3D, upModel → MakeModel
     ┣・TF3DWorld     ･･･ Create( TViewport3D )；Pose = Scale( +1, -1, -1 )
     ┣・TF3DCamera    ･･･ Camera :TCamera — 内部カメラ、Scale.Y=Scale.Z=-1
     ┗・TF3DShaper    ･･･ upGeometry/upTopology → MakeGeometry/MakeTopology
        ┗・TF3DSphere ･･･ DivX/DivY, Material :TLightMaterialSource, TMeshData

・TLight  (FMX)
  ┗・TF3DLight        ･･･ 同じ姿勢／位置／寸法のプロパティ群
```

`MakeGeometry` と `MakeTopology` は抽象であるため、`TF3DSphere` は同梱される唯一の具体形状であると同時に、新しい形状の雛形でもある。`TF3DShaper` から派生し、この2つのメソッドで `TMeshData` を埋め、`Render` をオーバーライドして描画すればよい。

### 3.2 ファイル

```
・LUX.FMX.Graphics.D3/
  ┣・LUX.FMX.Graphics.D3.pas        ･･･ TF3DObject/World/Camera/Light/Shaper
  ┗・LUX.FMX.Graphics.D3.Shaper.pas ･･･ 手続き的メッシュ：TF3DSphere
```

本ライブラリは `TSingle3D`・`TSingleM4` のために LUX 基底ライブラリに依存し、FireMonkey 側では `FMX.Types3D`・`FMX.Controls3D`・`FMX.Viewport3D`・`FMX.MaterialSources` に依存する。

## 4. 使い方

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
     World := TF3DWorld.Create( Viewport3D1 );           // ＋Y が上、＋Z が視点方向

     Camera     := TF3DCamera.Create( World );           // Owner へ自動所属
     Camera.Pos := TSingle3D.Create( 0, 0, 10 );         // ワールドの ＋Z 軸上
     Viewport3D1.Camera := Camera.Camera;                // 内部の FMX カメラを渡す

     Light      := TF3DLight.Create( World );
     Light.Pose := TSingleM4.RotateX( -0.5 );            // 平行光源の向き

     Ball := TF3DSphere.Create( World );

     Ball.DivX := 72;                                    // upGeometry / upTopology を立てる。
     Ball.DivY := 36;                                    // 再構築は次フレーム直前に1回

     Ball.SizeX := 2;                                    // 式 (5) により単位球を伸縮する。
     Ball.SizeY := 2;                                    // 頂点バッファには触れない
     Ball.SizeZ := 2;

     Ball.Pos := TSingle3D.Create( 0, 0, 0 );
     Ball.Material.Diffuse := TAlphaColors.Orange;
end;
```

各ノードは `Owner` に所有される通常の FireMonkey コンポーネントであるため、ビューポートまたはフォームを解放すればシーン全体が解放される。

## 5. 参考文献

1. Embarcadero, [*FireMonkey 3D*](https://docwiki.embarcadero.com/RADStudio/en/FireMonkey_3D).
2. Embarcadero, [*FMX.Controls3D.TControl3D*](https://docwiki.embarcadero.com/Libraries/en/FMX.Controls3D.TControl3D).
3. Embarcadero, [*FMX.Types3D.TMeshData*](https://docwiki.embarcadero.com/Libraries/en/FMX.Types3D.TMeshData).

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
