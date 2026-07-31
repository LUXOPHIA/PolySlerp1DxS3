# LUX.Sphere

[English](../README.md) | [日本語](README.md)

Delphi（Object Pascal）用の球面幾何ライブラリ。2 次元球面 $S^2$ 上の点（単位ベクトル）と 3 次元球面 $S^3$ 上の点（単位四元数）の型、`+` 演算子が球面線形補間となる *重み付き点* の代数、そして重み付き球面平均（重心）演算子の一族 — `Lerp`・`Glerp`・`Slerp`・`PolySlerp`・`SymSlerp`・`AveVecs`・`PowSlerp`・`ExpMap`・`ModExpMap` — を提供する。正多面体から生成される閉ループ点列グリッドと、それらを描画する FireMonkey コンポーネントも含む。

## 利用ライブラリ

* [**LUX**](https://github.com/LUXOPHIA/LUX) ：イプシロン定数・`TDouble3D` / `TDoubleQ` の線形代数・重み付き点レコード `TDoubleWector<>`・グリッドコンテナ `TPoins<>` を提供する基底ライブラリ。
* [**LUX.FMX.Graphics.D3**](https://github.com/LUXOPHIA/LUX.FMX.Graphics.D3) ：`FMX` ユニットが継承する `TF3DShaper` とシーンクラス群を提供する FireMonkey 3D コンポーネントフレームワーク。

## 1. 概要

| ユニット | 内容 |
|:---|:---|
| `S2/LUX.S2.pas` | `TSingle2S` / `TDouble2S` — $S^2$ の点。`TSingle3D` / `TDouble3D` の別名であり、`Unitor`（$\varepsilon$ 保護付きの正規化）を加えるレコードヘルパを伴う |
| `S2/Curve/LUX.S2.Curve.pas` | 重み付き点：`TSingleW2S` / `TDoubleW2S`（`TSingleWector<>` / `TDoubleWector<>` の別名）と、完全な演算子代数（$+$・$-$・スカラ $\times$・$/$・キャスト）を備えるレコード `TSingle2Sw` / `TDouble2Sw` |
| `S2/Curve/LUX.S2.Curve.Lerp.pas` | `Lerp` — $\mathbb{R}^3$ における弦（外在的）重み付き平均。正規化は**しない** |
| `S2/Curve/LUX.S2.Curve.Glerp.pas` | `Glerp` — 心射（gnomonic）線形補間：`Lerp` の後に正規化 |
| `S2/Curve/LUX.S2.Curve.Slerp.pas` | `Slerp`（媒介変数形・重み対形・重み付き点形）と `ChainSlerp` |
| `S2/Curve/LUX.S2.Curve.PolySlerp.pas` | `PolySlerp1D` — 二項重み付き `Slerp` の順序対称な二分ピラミッド |
| `S2/Curve/D2/LUX.S2.Curve.D2.PolySlerp.pas` | `PolySlerp` — 測地三角形の収縮による 3 点の球面重心 |
| `S2/Curve/D2/LUX.S2.Curve.D2.SymSlerp.pas` | `SymSlerp` — 重み付き `Slerp` の 3 重畳み込みを順序対称化したもの |
| `S2/Curve/D2/LUX.S2.Curve.D2.AveVecs.pas` | `AveVecs` — 重み付き平均に対する接平面不動点反復 |
| `S3/LUX.S3.pas` | `TSingle3S` / `TDouble3S` — $S^3$ の点。`TSingleQ` / `TDoubleQ`（単位四元数）の別名で、`Unitor` を伴う |
| `S3/Curve/LUX.S3.Curve.pas` | $S^3$ 版の `TSingleW3S` / `TDoubleW3S` と `TSingle3Sw` / `TDouble3Sw` |
| `S3/Curve/LUX.S3.Curve.{Glerp,Slerp,PolySlerp}.pas` | $S^3$ 上の同じ 3 系統の補間 |
| `S3/Curve/LUX.S3.Curve.PowSlerp.pas` | `PowSlerp` / `ChainPowSlerp` — 四元数の冪による測地線ステップ |
| `S3/Curve/LUX.S3.Curve.ExpMap.pas` | `ExpMap` — 対数領域での重み付き平均 |
| `S3/Curve/LUX.S3.Curve.ModExpMap.pas` | `ModExpMap` — `Glerp` 平均を原点とする接空間での対数領域平均 |
| `S2/Data/Grid/…`, `S3/Data/Grid/…` | `TPoins2S` / `TLoopPoins2S`、`TPoins3S` / `TLoopPoins3S`、正多面体ループ `TPolyPoins2S04`〜`20` と `TPolyPoins3S04`〜`20`、弧長再標本化器 `TPlots2S` / `TPlots3S` |
| `S2/FMX/…`, `S3/FMX/…`, `FMX/…` | FireMonkey コンポーネント：点群シェイパ `TPoins3D` / `THemiPoins3D` と、シーンのラッパ `TWorld3D` / `TCamera3D` / `TLight3D` / `TSphere3D` |

すべての型とルーチンは `Single` / `Double` の両精度で存在する。以下では `Double` 版を用いる。

## 2. 数学的背景

### 2.1. 2 つの球面

```math
S^2 = \left\{\, p \in \mathbb{R}^3 \;\middle|\; \lVert p \rVert = 1 \,\right\},
\qquad
S^3 = \left\{\, q \in \mathbb{H} \;\middle|\; \lVert q \rVert = 1 \,\right\}
\qquad \text{(2.1)}
```

`LUX.S2` は $S^2$ の点を 3 次元ベクトルと同一視し、`LUX.S3` は $S^3$ の点を四元数と同一視する。したがって `LUX.D3` と `LUX.Quaternion` の周囲空間の線形代数はそのまま継承され、球面性は正規化 `Unitor`（ノルムが $\varepsilon$ を下回る場合は $0$ を返す）を通じてのみ現れる。両球面は測地（角度）計量

```math
d(p,q) = \arccos \langle p, q \rangle \; \in [0, \pi] , \qquad \Omega \equiv d(p,q)
\qquad \text{(2.2)}
```

を備え、これが `TPlots2S.Distance` の測るものである。$S^3$ では自然な距離は誘導される回転の距離であるため、`TPlots3S.Distance` は固定軸の像同士、すなわち $\angle\bigl(R_{q_0}(\hat{y}), R_{q_1}(\hat{y})\bigr)$（ただし $R_q(v) = q\,v\,q^{-1}$）を比較する。

### 2.2. 重み付き点

*重み付き点* は球面上の点と実数の重みの対 $(v, w)$ である。`TDouble2Sw` と `TDouble3Sw` はこれを演算子付きレコードとして実装しており、平均化スキームを通常の算術として書けるようにする。

```math
(p, w_1) \oplus (q, w_2) \;=\; \mathrm{Slerp}\bigl((p, w_1), (q, w_2)\bigr),
\qquad
\lambda \cdot (v, w) = (v, \lambda w),
\qquad
-(v, w) = (v, -w)
\qquad \text{(2.3)}
```

すなわち `+` は §2.4 の重み付き球面補間、スカラ乗除は重みのみに作用し、単項マイナスは重みを反転する（したがって Catmull–Rom や Lanczos 系の基底が要求する負の重みも扱える）。`A - B` は `Slerp(A, -B)` である。暗黙キャストは素の点を重み $1$ に持ち上げ、明示キャストは重み付き点をその点へ射影する。

### 2.3. Lerp と Glerp

`Lerp` は周囲空間における弦（外在的）重み付き平均であり、意図的に正規化しない。

```math
L\bigl(p_1,\dots,p_n; w_1,\dots,w_n\bigr) = \frac{\sum_{i} w_i\, p_i}{\sum_{i} w_i}
\qquad \text{(2.4)}
```

`Glerp`（*gnomonic* 線形補間）は (2.4) を球面へ射影し戻したものである。

```math
G\bigl(p_1,\dots,p_n; w_1,\dots,w_n\bigr) = \frac{L(\cdots)}{\bigl\lVert L(\cdots) \bigr\rVert} ,
\qquad
G(p,q) = \frac{p+q}{\lVert p+q \rVert} = \mathrm{slerp}\bigl(p,q;\tfrac12\bigr)
\qquad \text{(2.5)}
```

ゆえに 2 点形はちょうど測地中点であり、$n$ 点形は *外在的* 球面平均、すなわち球面上で $\sum_i w_i \langle g, p_i \rangle$ を最大化する点である。`Glerp` はまた、$\sin\Omega$ が桁落ちする $\lvert\langle p,q\rangle\rvert > 1-\varepsilon$ の場合に、すべての `Slerp` オーバーロードが用いるフォールバックでもある。

### 2.4. Slerp

$p$ と $q$ を通る大円に沿った球面線形補間は [1][4]

```math
\mathrm{slerp}(p,q;t) = \frac{\sin\bigl((1-t)\,\Omega\bigr)}{\sin\Omega}\, p
                      + \frac{\sin\bigl(t\,\Omega\bigr)}{\sin\Omega}\, q
\qquad \text{(2.6)}
```

本ライブラリの主形式は *重み対* 形であり、これが `Slerp` を (2.3) の `+` として使える理由である。$W = w_1 + w_2$ として

```math
S\bigl((p,w_1),(q,w_2)\bigr) = \left(
\frac{\sin\!\bigl(\tfrac{w_1}{W}\Omega\bigr)\, p + \sin\!\bigl(\tfrac{w_2}{W}\Omega\bigr)\, q}{\sin\Omega},\;\; W \right)
= \Bigl( \mathrm{slerp}\bigl(p,q;\tfrac{w_2}{W}\bigr),\; W \Bigr)
\qquad \text{(2.7)}
```

合成された重み $W$ が持ち越されるため、列を畳み込むと総重みが累積される。`ChainSlerp` はその左畳み込みであり、

```math
\mathrm{ChainSlerp}(P_1,\dots,P_n) = \bigl(\cdots\bigl((P_1 \oplus P_2) \oplus P_3\bigr) \cdots \bigr) \oplus P_n
\qquad \text{(2.8)}
```

2 点では厳密だが $n \ge 3$ では被演算子の順序に依存する。これが以下の対称化演算子の動機である。

### 2.5. 順序対称な畳み込み

`PolySlerp1D` は二分ピラミッド再帰によって (2.8) の順序依存性を除く。各段で内部の重みを半分にし、隣接対を $\oplus$ で合成する。

```math
P^{(L)}_i = \tilde{P}^{(L+1)}_i \oplus \tilde{P}^{(L+1)}_{i+1},
\qquad
\tilde{P}^{(L+1)}_i =
\begin{cases}
P^{(L+1)}_i & i \in \{\, 0,\; L+1 \,\} \\
\tfrac12 P^{(L+1)}_i & \text{それ以外}
\end{cases}
\qquad \text{(2.9)}
```

これにより、ソース中の重み流図が示すとおり、すべての入力が等しい総影響度で頂点に到達する。

```
4 入力 A–D に対する二分ピラミッドの頂点。親は子の ⊕ であり、
/n はその子に掛かる重みのスケーリング。2 つの親へ流れ込むノードは
それぞれの親の下に再掲する。

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

`SymSlerp` は 3 点の場合を別の方法で対称化する。3 つ組の巡回置換それぞれを畳み込み、その 3 結果の心射平均をとる。

```math
\mathrm{SymSlerp}(V_1,V_2,V_3) = G\bigl(\,
V_1 \oplus V_2 \oplus V_3,\;\;
V_2 \oplus V_3 \oplus V_1,\;\;
V_3 \oplus V_1 \oplus V_2 \,\bigr)
\qquad \text{(2.10)}
```

### 2.6. $S^2$ 上の PolySlerp：測地三角形の収縮

`LUX.S2.Curve.D2.PolySlerp` は、球面三角形をその測地中点三角形で繰り返し置き換えることにより、真に対称な 3 点の球面重心を計算する。重みなしの場合のステップは

```math
(v_1, v_2, v_3) \;\longleftarrow\; \bigl(\, G(v_2,v_3),\; G(v_3,v_1),\; G(v_1,v_2) \,\bigr)
\qquad \text{(2.11)}
```

であり、候補 $m = L(v_1,v_2,v_3)$ は $\lVert m \rVert^2 > 1-\varepsilon$ となった時点、すなわち三角形が 1 点に収縮した時点で返される。重み付きの場合は辺を (2.7) の重み付き `Slerp` で収縮し、重みは対ごとに平均する。

```math
v_{23} = S(v_2,v_3; w_2,w_3), \quad w_{23} = \tfrac12 (w_2+w_3)
\qquad \text{（巡回的に）} \qquad \text{(2.12)}
```

1 回の収縮で三角形の直径はおよそ半分になるため収束は線形であり、ループは $10\,000$ 回で打ち切られる。得られる写像 $(w_1 : w_2 : w_3) \mapsto S^2$ は測地三角形上の球面重心座標系であり、頂点はそれ自身に写り、各辺は厳密な `Slerp` として辿られる。

### 2.7. AveVecs：接平面反復

`AveVecs` は `Glerp` 平均 $g$ から出発し、入力の接成分の重み付き平均で繰り返し補正する。

```math
P_i = v_i - \langle g, v_i \rangle\, g,
\qquad
V_\Delta = L(P_1,P_2,P_3; w_1,w_2,w_3),
\qquad
g \;\longleftarrow\; \frac{g + V_\Delta}{\lVert g + V_\Delta \rVert}
\qquad \text{(2.13)}
```

停止条件は $\lVert V_\Delta \rVert^2 < \varepsilon$ である。停留条件 $V_\Delta = 0$ は、$\sum_i w_i v_i$ が $g$ における球面の接方向成分を持たないこと、すなわち $g \parallel \sum_i w_i v_i$ を意味する。ゆえに不動点はまさに外在的平均 (2.5) であり、この反復は独立した演算子ではなくその精密化である。なお Buss と Fillmore [2] の内在的（リーマン／Karcher）平均は対数写像を用い、その接ベクトルは追加因子 $\Omega / \sin\Omega$ を持つ。(2.13) が計算するものはそれとは異なる。

### 2.8. $S^3$ 固有の演算子

$S^3$ は群であるため、$q_0$ と $q_1$ を通る測地線は四元数の冪 $q^t = \exp(t \ln q)$ で書ける。`PowSlerp` はこの形で評価する。

```math
\mathrm{PowSlerp}(q_0,q_1;t) = q_0 \left( q_0^{-1} q_1 \right)^{t}
\qquad \text{(2.14)}
```

`ChainPowSlerp` は $t = w_2 / (w_1+w_2)$ の重み付き点形を (2.8) とまったく同様に畳み込む。平均はリー環上で行うこともできる。`ExpMap` は入力を $\ln$ でリー環へ移し、線形に平均し、結果を戻す [3]。

```math
\mathcal{B}_{\mathrm{ExpMap}} = \exp\!\left( \frac{1}{W} \sum_i w_i \ln q_i \right),
\qquad W = \sum_i w_i
\qquad \text{(2.15)}
```

これは安価だが、接空間が単位元に固定されているため単位元側に偏る。`ModExpMap` は接空間の基点を代わりに `Glerp` 平均 $g$ に置くことで、その偏りの大部分を除く。

```math
\mathcal{B}_{\mathrm{ModExpMap}} = g\, \exp\!\left( \frac{1}{W} \sum_i w_i \ln\bigl( g^{-1} q_i \bigr) \right)
\qquad \text{(2.16)}
```

$\lvert W \rvert < \varepsilon$ の場合、両演算子は対数の重みなし総和へフォールバックする。

## 3. アーキテクチャ

型 — 球面層は LUX の線形代数の上に置かれた薄い別名とレコードヘルパの集合である。

```
点の型 — 別名は、それが改名する LUX の型の子として示す

・LUX.D3
  ┗・TDouble3D
     ┗・TDouble2S             ･･･ 別名。S² の点  [LUX.S2]
        ┗・HDouble2S.Unitor   ･･･ レコードヘルパ
・LUX.Quaternion
  ┗・TDoubleQ
     ┗・TDouble3S             ･･･ 別名。S³ の点  [LUX.S3]
        ┗・HDouble3S.Unitor   ･･･ レコードヘルパ

重み付き点  [LUX.S2.Curve / LUX.S3.Curve]

・LUX.Curve
  ┣・TDoubleWector<TDouble2S>
  ┃  ┗・TDoubleW2S           ･･･ 別名。重み付き点 (v, w) 素のレコード
  ┃     ┗・HDoubleW2S.Unitor ･･･ レコードヘルパ
  ┗・TDoubleWector<TDouble3S>
     ┗・TDoubleW3S            ･･･ 別名。重み付き点 (v, w) 素のレコード
        ┗・HDoubleW3S.Unitor  ･･･ レコードヘルパ

演算子付きの重み付き点 — Implicit / Explicit キャストが
TDoubleW2S / TDoubleW3S と TDouble2Sw / TDouble3Sw を相互に変換する

・TDouble2Sw / TDouble3Sw
  ┣・+ = Slerp
  ┣・- = 重みを反転した Slerp
  ┣・λ* , /λ = 重みのスケーリング
  ┗・Implicit( TDouble2S ) ⇒ w = 1
```

ルーチン — 平均化演算子ごとに 1 ユニット。すべて 4 種の点型（`2S`・`W2S`・`2Sw`、および `3S` 系）にオーバーロードされた自由関数である。

```
S²  LUX.S2.Curve.Lerp ........ Lerp        弦平均・非正規化                    (2.4)
    LUX.S2.Curve.Glerp ....... Glerp       正規化した弦平均                    (2.5)
    LUX.S2.Curve.Slerp ....... Slerp       重み付き大円補間                    (2.7)
                               ChainSlerp  ⊕ の左畳み込み                      (2.8)
    LUX.S2.Curve.PolySlerp ... PolySlerp1D ⊕ の二分ピラミッド                  (2.9)
    …Curve.D2.SymSlerp ....... SymSlerp    巡回対称化                          (2.10)
    …Curve.D2.PolySlerp ...... PolySlerp   測地三角形の収縮                    (2.11)
    …Curve.D2.AveVecs ........ AveVecs     接平面反復                          (2.13)

S³  LUX.S3.Curve.Glerp / .Slerp / .PolySlerp .... S³ 上の同じ 3 系統
    LUX.S3.Curve.PowSlerp .... PowSlerp, ChainPowSlerp   四元数の冪            (2.14)
    LUX.S3.Curve.ExpMap ...... ExpMap      対数領域平均                        (2.15)
    LUX.S3.Curve.ModExpMap ... ModExpMap   G 平均を基点とする対数領域平均      (2.16)
```

クラス — 点コンテナと FireMonkey シェイパ。

```
・TPoins<_TPoin_>                                ･･･ [LUX.Data.Grid.D1]
  ┣・TLoopPoins<_TPoin_>                        ･･･ 添字が巻き戻る（閉ループ）
  ┃  ┣・TLoopPoins2S = TLoopPoins<TDouble2S>   ･･･ [LUX.S2.Data.Grid.D1]
  ┃  ┃  ┗・TPolyPoins2S04 / 06 / 08 / 12 / 20 ･･･ 5 種の正多面体の頂点
  ┃  ┗・TLoopPoins3S = TLoopPoins<TDouble3S>   ･･･ [LUX.S3.Data.Grid.D1]
  ┃     ┗・TPolyPoins3S                        ･･･ 2S ループを S³ へ上げる
  ┃        ┗・TPolyPoins3S04 / 06 / 08 / 12 / 20
  ┗・TPlots<_TPoin_>                            ･･･ 弧長再標本化・PlotGap
     ┣・TPlots2S                                ･･･ Distance = Angle(p₀, p₁)
     ┗・TPlots3S                                ･･･ Distance = ∠(q₀ŷ, q₁ŷ)

・TF3DShaper                                     ･･･ [LUX.FMX.Graphics.D3]
  ┗・TPoins3D                                   ･･･ 1 点につき 1 球
     ┗・THemiPoins3D                            ･･･ 半球トポロジ
        ┣・THemiPoinsLo3D
        ┗・THemiPoinsUp3D                       ･･･ S2.FMX と S3.FMX で二重宣言

[LUX.Sphere.FMX] — FireMonkey シーンラッパ
・TF3DWorld
  ┗・TWorld3D
・TF3DCamera
  ┗・TCamera3D                                  ･･･ Radius・AngleX/Y で旋回
・TF3DLight
  ┗・TLight3D
・TF3DSphere
  ┗・TSphere3D
```

ファイル構成：

```
・LUX.Sphere/
  ┣・S2/                                                    ･･･ 2 次元球面
  ┃  ┣・LUX.S2.pas                                         ･･･ TDouble2S ほか
  ┃  ┣・Curve/                                             ･･･ 重み付き点
  ┃  ┃  ┣・LUX.S2.Curve.pas                               ･･･ TDouble2Sw ほか
  ┃  ┃  ┣・LUX.S2.Curve.{Lerp,Glerp,Slerp,PolySlerp}.pas
  ┃  ┃  ┗・D2/                                            ･･･ 3 点演算子
  ┃  ┃     ┗・LUX.S2.Curve.D2.{PolySlerp,SymSlerp,AveVecs}.pas
  ┃  ┣・Data/Grid/                                         ･･･ 点グリッド
  ┃  ┗・FMX/LUX.S2.FMX.pas                                 ･･･ シェイパ
  ┣・S3/                                                    ･･･ S³・同一構成
  ┃  ┣・LUX.S3.pas, Curve/…, Data/Grid/…, FMX/LUX.S3.FMX.pas
  ┃  ┗・Curve/LUX.S3.Curve.{PowSlerp,ExpMap,ModExpMap}.pas ･･･ S³ 固有
  ┗・FMX/LUX.Sphere.FMX.pas                                 ･･･ シーンラッパ
```

## 4. 使い方

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

     M := Slerp( P1, P2, 0.25 );                  // 弧に沿って 1/4 の位置
     M := Glerp( P1, P2 );                        // 測地中点
     M := PolySlerp( P1, P2, P3, 1, 2, 3 );       // 球面重心・重み 1:2:3

     A := P1;                                     // 暗黙キャスト：重み 1
     B := 2 * TDouble2Sw.Create( P2, 1 );         // 重み 2
     M := TDouble2S( A + B );                     // '+' は重み付き Slerp

     // S³：Glerp 平均を基点とする接空間での 3 回転の重み付き平均
     Qs := [ TDoubleW3S.Create( TDouble3S.Rotate( TDouble3D.IdentityX, 0.0    ), 1 ),
             TDoubleW3S.Create( TDouble3S.Rotate( TDouble3D.IdentityY, Pi/2   ), 2 ),
             TDoubleW3S.Create( TDouble3S.Rotate( TDouble3D.IdentityZ, Pi/2*3 ), 1 ) ];

     Q := ModExpMap( Qs ).Unitor.v;

     WriteLn( Angle( Q.Trans( TDouble3D.IdentityY ), P2 ) );   // 測地誤差（ラジアン）
end;
```

重みの総和が $1$ である必要はない。すべての演算子は総重みで除算する（総重みが $\varepsilon$ を下回る場合は重みなし形へフォールバックする）。結果の重みは `w` フィールドに保持されるため、値をさらに畳み込むことができる。

## 5. 必要環境

* **Delphi / RAD Studio** — 全体を通じてジェネリクス・レコードヘルパ・演算子オーバーロードを用いる。`S2/` と `S3/` のコアユニットは純粋な Object Pascal であり、`FMX/` ユニットは FireMonkey を要する。
* **[LUX](https://github.com/LUXOPHIA/LUX)** 基底ライブラリ — `LUX`（イプシロン定数）、`LUX.D3`（`TDouble3D`・`Angle`・`DotProduct`）、`LUX.Quaternion`（`TDoubleQ`・`Ln`・`Exp`・`Pow`・`Rotate`・`Trans`）、`LUX.Curve`（`TDoubleWector<>`）、`LUX.Data.Grid.D1`（`TPoins<>`・`TLoopPoins<>`）、`LUX.Curve.Data.Grid.D1.Plots`（`TPlots<>`）。
* **[LUX.FMX.Graphics.D3](https://github.com/LUXOPHIA/LUX.FMX.Graphics.D3)** — `TF3DShaper`・`TF3DWorld`・`TF3DCamera`・`TF3DLight`・`TF3DSphere` を継承する `FMX` ユニットのみが要する。

本ライブラリは `git subtree` として、サンプルアプリケーション [PolySlerp](https://github.com/LUXOPHIA/PolySlerp)（$S^2$ 上の球面重心グリッド）・[SphericalCurve](https://github.com/LUXOPHIA/SphericalCurve)（$S^2$ 上の曲線スキーム）・[QuaternionCurve](https://github.com/LUXOPHIA/QuaternionCurve)（$S^3$ 上の曲線スキーム）に取り込まれており、そこでは §2 の平均化演算子が相互に比較される。

## 6. 参考文献

1. Shoemake, K., [*Animating Rotation with Quaternion Curves*](https://doi.org/10.1145/325334.325242), SIGGRAPH '85, pp. 245–254, 1985.
2. Buss, S. R. and Fillmore, J. P., [*Spherical Averages and Applications to Spherical Splines and Interpolation*](https://doi.org/10.1145/502122.502124), ACM Transactions on Graphics, 20(2), pp. 95–126, 2001.
3. Kim, M.-J., Kim, M.-S. and Shin, S. Y., [*A General Construction Scheme for Unit Quaternion Curves with Simple High Order Derivatives*](https://doi.org/10.1145/218380.218486), SIGGRAPH '95, pp. 369–376, 1995.
4. [*Slerp*](https://en.wikipedia.org/wiki/Slerp), Wikipedia.
5. [*Fréchet mean*](https://en.wikipedia.org/wiki/Fr%C3%A9chet_mean), Wikipedia.

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
