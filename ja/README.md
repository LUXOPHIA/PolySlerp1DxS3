# PolySlerp1DxS3

[English](../README.md) | [日本語](README.md)

**PolySlerp1DxS3** は、論文『PolySlerp: 球面多角線形補間』[1] の公式サンプルプログラムです。**単位四元数の曲線** — すなわち 3 次元回転の滑らかな 1 パラメータ族 — を単位 3 次元球面 $S^3$ 上に構成し比較する、対話的な FireMonkey（Delphi）アプリケーションです。5 種のスプライン方式（Linear・Bézier・B-Spline・Catmull-Rom・Lanczos）と 6 種の球面重み付き平均（「重心」）演算子（GLerp・Slerp・PowSlerp・PolySlerp・ExpMap・ModExpMap）を組み合わせ、独立に設定した 2 本の曲線をテクスチャ付き地球儀上に同時に描画して直接比較できます。

<!-- TODO: screenshot -->

## 利用ライブラリ

* [**LUX**](https://github.com/LUXOPHIA/LUX) ：ベクトル・行列・四元数などの基礎数学型を提供する LUXOPHIA の標準ライブラリ。
* [**LUX.FMX.Graphics.D3**](https://github.com/LUXOPHIA/LUX.FMX.Graphics.D3) ：FireMonkey フレームワークをベースとした 3D グラフィックス補助ライブラリ。
* [**LUX.Sphere**](https://github.com/LUXOPHIA/LUX.Sphere) ：球面 $S^2$・$S^3$ 上の曲線・重心演算を扱う球面幾何ライブラリ。

## 1. 概要

* **制御ループ**: $N \in \{4, 6, 8, 12, 20\}$ 個の制御四元数からなる閉ループ（`TPolyPoins3S04` … `TPolyPoins3S20`）。各ループは 2 次元球面上の $N$ 点の閉ループ（`TPolyPoins2S04` … `TPolyPoins2S20`）から導出されます。各アンカーは、極ベクトル $\hat{y}$ をループ点へ移す回転と $\hat{y}$ まわりのランダムなねじりの合成として初期化され、その後、slerp の反復で構成した 4 次 B-スプライン平滑化（`TPolyPoins3S.BSpline4`）を繰り返し適用し、毎回軸をループ点に固定し直しながら、向きのループが収束するまで緩和されます。
* **曲線 = スプライン方式 × 重心演算子**: すべてのスプライン方式は、各評価が制御四元数の*重み付き重心*になるよう書かれています。平均化規則は差し替え可能で、同じ Bézier や B-スプラインの重みを 6 種の球面的方法で平均でき、目に見えて異なる曲線が得られます。
* **2 本同時表示**: *Upper Curve* と *Lower Curve* を独立に設定できます。サンプル点は相補的な半球キャップ（`THemiPoinsUp3D` / `THemiPoinsLo3D`）として描かれるため、2 本の曲線が一致する箇所でも判別できます。
* **回転の可視化**: 四元数 $q$ は半径 $R$ の地球儀上の点 $R\,(q\,\hat{y}\,q^{-1})$ に、$q$ の回転全体で向き付けられた小さなテクスチャ付き球として表示されます — 位置が回転軸の像を、テクスチャの向きが軸まわりのねじりを示します。
* **弧長等間隔サンプリング**: `TPlots3S` が各曲線を等角度間隔で再サンプリングします。間隔（`PlotGap`）は点のサイズから、隣接する点がちょうど接するように決められます。
* **ねじり負荷テスト**: スライダーで連続する制御四元数に局所軸まわりの交互ねじり $\pm\tau$（$\tau \in [-90^\circ, +90^\circ]$）を加え、各平均化演算子の挙動の違いをあぶり出せます。

## 2. 数学的背景

### 2.1 単位四元数と回転

単位四元数 $q = w + x\,\mathbf{i} + y\,\mathbf{j} + z\,\mathbf{k}$（$\lVert q \rVert = 1$）は 3 次元球面 $S^3 \subset \mathbb{H}$ 上にあり、ベクトル $v \in \mathbb{R}^3$（純虚四元数）に回転として作用します [5]:

```math
R_q(v) = q\,v\,q^{-1} \tag{1}
```

本アプリケーションは型 `TDouble3S`（$S^3$ の点）を四元数型 `TDoubleQ` と同一視し、$q$ を地球儀上の $R \cdot R_q(\hat{y})$ に表示します（`TDoubleQ.Trans`, `Scene.pas`）。

### 2.2 Slerp と重み付き slerp

$\cos\theta = \langle p, q \rangle$ とするとき、$p, q \in S^3$ 間の球面線形補間は [2][4]

```math
\mathrm{Slerp}(p, q; t) = \frac{\sin\bigl((1-t)\,\theta\bigr)\,p + \sin(t\,\theta)\,q}{\sin\theta} \tag{2}
```

コード（`LUX.S3.Curve.Slerp`）はこれを任意の実数重みをもつ*重み付き点* $(p, w_1)$, $(q, w_2)$ に一般化します。$W = w_1 + w_2$ として:

```math
(p, w_1) \oplus (q, w_2)
= \left( \frac{\sin\bigl(\tfrac{w_1}{W}\theta\bigr)\,p + \sin\bigl(\tfrac{w_2}{W}\theta\bigr)\,q}{\sin\theta},\; W \right) \tag{3}
```

これは合成重み $W$ を伴った $\mathrm{Slerp}(p, q;\, w_2/W)$ に等しくなります。ほぼ平行な入力に対しては正規化線形補間へフォールバックします。符号付き重みに対応しており（`TDouble3Sw` は単項マイナスで重みを反転）、基底関数が負のローブをもつ Catmull-Rom や Lanczos 方式に必要です。

### 2.3 指数写像と対数写像

純虚四元数をリー環 $\mathfrak{so}(3)$ と同一視すると、指数写像 $\exp : \mathfrak{so}(3) \to S^3$ とその逆写像は

```math
\exp(\theta\,\hat{n}) = \cos\theta + \hat{n}\,\sin\theta,
\qquad
\ln\bigl(\cos\theta + \hat{n}\,\sin\theta\bigr) = \theta\,\hat{n} \tag{4}
```

`LUX.Quaternion` は $\mathbb{H}$ 上の一般形（$\ln q = \ln\lVert q \rVert + \operatorname{atan2}(\lVert \mathbf{v} \rVert, w)\,\hat{\mathbf{v}}$ と対応する $\exp$、および `Pow(q, t) = Exp(t·Ln(q))`）を実装しています。

### 2.4 重心演算子

各曲線評価は単位四元数の重み付き重心 $\mathcal{B}\bigl(\{(q_i, w_i)\}_{i=1}^{n}\bigr)$ に帰着します。6 種の演算子が実装されています（`LIB.Bary.S3.*` が `LUX.S3.Curve.*` へ委譲）:

| 演算子 | 定義 |
|---|---|
| **GLerp** | 心射（正規化）線形平均、式 (5) — [1] の *mGlerp* |
| **Slerp** | 重み付き 2 項 slerp (3) の左畳み込み: $\bigl(\cdots\bigl((q_1,w_1) \oplus (q_2,w_2)\bigr) \oplus \cdots\bigr) \oplus (q_n,w_n)$ — [1] の順序依存な *cSlerp* |
| **PowSlerp** | 四元数冪を用いた測地線ステップ (6) の左畳み込み |
| **PolySlerp** | $\oplus$ の順序対称化された 2 分再帰、式 (7) — [1] の *PolySlerp-2*（内部修正加算） |
| **ExpMap** | 対数領域での線形平均、式 (8) |
| **ModExpMap** | GLerp 平均を中心とする接空間での対数領域平均、式 (9) |

```math
\mathcal{B}_{\mathrm{GLerp}} = \frac{\sum_i w_i\,q_i}{\bigl\lVert \sum_i w_i\,q_i \bigr\rVert} \tag{5}
```

```math
(p, w_1) \oplus_{\mathrm{pow}} (q, w_2) = \Bigl( p\,\bigl(p^{-1} q\bigr)^{w_2 / (w_1+w_2)},\; w_1 + w_2 \Bigr),
\qquad q^{t} = \exp\bigl(t \ln q\bigr) \tag{6}
```

**PolySlerp**（`PolySlerp1D`）は、各レベルで内部の重みを半分にし隣接ペアを (3) の $\oplus$ で結合する 2 分ピラミッド再帰 — [1] の *type-2（内部修正加算）*、すなわち **PolySlerp-2** — により、連鎖畳み込みの順序依存性を除去します:

```math
P^{(L)}_i = \tilde{P}^{(L+1)}_i \oplus \tilde{P}^{(L+1)}_{i+1},
\qquad
\tilde{P}^{(L+1)}_i = \begin{cases} P^{(L+1)}_i & i \in \{0, L+1\} \\ \tfrac{1}{2} P^{(L+1)}_i & \text{otherwise} \end{cases} \tag{7}
```

ソース中の重みフロー図（[1] の図 3(c)）の通りです:

```
制御点 n = 4 個（A, B, C, D）の重みフロー ― 各ノードは 2 つの子の ⊕ であり、
"/k" は親へ渡す前にそのノードへ掛かる係数
（式 (7) のチルダの通り、端の項は /1、内部の項は /2）

・4A+4B+4C+4D       ･･･ レベル 0（結果）
  ┣・4A+3B+1C /1   ･･･ レベル 1
  ┃  ┣・4A+2B /1  ･･･ レベル 2
  ┃  ┃  ┣・4A /1 ･･･ レベル 3（制御点 A）
  ┃  ┃  ┗・4B /2 ･･･ レベル 3（制御点 B）
  ┃  ┗・2B+2C /2  ･･･ レベル 2
  ┃     ┣・4B /2
  ┃     ┗・4C /2
  ┗・1B+3C+4D /1   ･･･ レベル 1
     ┣・2B+2C /2   ･･･ レベル 2（上と同一の共有ノード）
     ┃  ┣・4B /2
     ┃  ┗・4C /2
     ┗・2C+4D /1   ･･･ レベル 2
        ┣・4C /2   ･･･ レベル 3（制御点 C）
        ┗・4D /1   ･･･ レベル 3（制御点 D）
```

**ExpMap** は対数領域で平均します（[3] の exp/log による曲線構成を参照）。[1] が指摘するように、結果は射影の基点に依存するため、あくまで近似的な平均です:

```math
\mathcal{B}_{\mathrm{ExpMap}} = \exp\!\left( \frac{1}{W} \sum_i w_i \ln q_i \right),
\qquad W = \sum_i w_i \tag{8}
```

**ModExpMap** はまず (5) の GLerp 平均 $g$ を求め、$g$ における接空間で平均することで — まさに [1] が推奨する基点の取り方 — (8) の基点バイアスを大幅に除去します:

```math
\mathcal{B}_{\mathrm{ModExpMap}} = g\,\exp\!\left( \frac{1}{W} \sum_i w_i \ln\bigl(g^{-1} q_i\bigr) \right) \tag{9}
```

### 2.5 スプライン方式

すべての方式（点型についてジェネリックな `LIB.Curve.*`）は、1 セグメントを連続する制御点の重心として表現します。2 つのアルゴリズムが用意されている方式では、*Basis Function* が基底関数の重みによる 1 回の $n$ 項重心を評価し、*Recursive Lerp* が 2 項重心を用いた古典的なペアワイズ再帰を適用します — 平坦でない平均化演算子に対して両者は等価では**なく**、その差をビューアで観察できます。

| 方式 | 基底関数形 | 再帰形 |
|---|---|---|
| Linear | $\mathcal{B}\bigl((p_i, 1-t), (p_{i+1}, t)\bigr)$ | — |
| Bézier（次数 $n$） | 重み $b_{j,n}(t) = \binom{n}{j} t^j (1-t)^{n-j}$、式 (10) | de Casteljau 再帰 |
| B-Spline（次数 $n$） | 一様 B-スプライン基底の重み | de Boor 再帰、$s = \tfrac{t+N-j}{N+1}$ |
| Catmull-Rom | 4 点上の 3 次 Catmull-Rom 重み（符号付き） | Barry–Goldman 型ピラミッド |
| Lanczos（半径 $a$） | $\lvert x \rvert < a$ で $L(x) = \operatorname{sinc}(x)\operatorname{sinc}(x/a)$（符号付き） | — |

```math
C(t) = \mathcal{B}\Bigl( \bigl\{ \bigl(p_{i+j},\; b_{j,n}(t)\bigr) \bigr\}_{j=0}^{n} \Bigr) \tag{10}
```

### 2.6 弧長リサンプリング

`TPlots3S` は曲線の長さを、連続する回転後の軸ベクトル間の角度の累積 $d(q_0, q_1) = \angle\bigl(R_{q_0}(\hat{y}),\, R_{q_1}(\hat{y})\bigr)$ として 1024 辺のテーブルで測り、隣接する点が画面上でちょうど接するよう、等弧長間隔 `PlotGap` $= 2 \arcsin(r_{\mathrm{dot}} / R)$ でサンプル点を配置します。

## 3. アーキテクチャ

```
[1] 所有関係 ― Main.pas

・TForm1
  ┣・_Poins3S :TPolyPoins3S     ･･･ 制御四元数のループ
  ┣・_Bary3S :TDoubleBary3S ×6 ･･･ 6 種の重心演算子
  ┣・_Curve3S0 :TCurve3S ×5    ･･･ 5 種のスプライン方式（Lower Curve）
  ┣・_Curve3S1 :TCurve3S ×5    ･･･ 5 種のスプライン方式（Upper Curve）
  ┣・_Plots3S0 :TPlots3S        ･･･ _Curve3S0 の弧長リサンプリング
  ┗・_Plots3S1 :TPlots3S        ･･･ _Curve3S1 の弧長リサンプリング

[2] シーングラフ ― Scene.pas、TViewport3D の中（LUX.Sphere.FMX / LUX.S3.FMX）

・TWorld3D
  ┣・TCamera3D
  ┃  ┗・TLight3D
  ┣・TSphere3D                  ･･･ 地球儀
  ┣・TPoins3D                   ･･･ ← _Poins3S
  ┣・THemiPoinsLo3D             ･･･ ← _Plots3S0
  ┗・THemiPoinsUp3D             ･･･ ← _Plots3S1

[3] データフロー ― Main.pas のモデル → Scene.pas のメッシュ

・_Poins3S :TPolyPoins3S
  ┣・TPoins3D                   ･･･ 制御点の点描
  ┣・_Curve3S0 :TCurve3S ×5
  ┃  ┗・_Plots3S0 :TPlots3S
  ┃     ┗・THemiPoinsLo3D      ･･･ 下半球の点描
  ┗・_Curve3S1 :TCurve3S ×5
     ┗・_Plots3S1 :TPlots3S
        ┗・THemiPoinsUp3D       ･･･ 上半球の点描

[4] クラス階層 ― 制御点とサンプリング   （Q = TDouble3S、単位四元数）

・TPoins<Q>
  ┣・TLoopPoins<Q>
  ┃  ┗・TPolyPoins3S
  ┃     ┣・TPolyPoins3S04      ･･･ (4 点)
  ┃     ┣・TPolyPoins3S06      ･･･ (6 点)
  ┃     ┣・TPolyPoins3S08      ･･･ (8 点)
  ┃     ┣・TPolyPoins3S12      ･･･ (12 点)
  ┃     ┗・TPolyPoins3S20      ･･･ (20 点)
  ┗・TPlots<Q>
     ┗・TPlots3S                ･･･ 弧長リサンプラ

[5] クラス階層 ― 曲線と重心演算子

・TCurve<Q>
  ┗・TCurveAlgo<Q>              ･･･ Bary プロパティが TBarycenter<Q> を参照する
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
  ┣・PolySlerp1DxS3.dpr         ･･･ プログラムエントリ
  ┣・PolySlerp1DxS3.dproj       ･･･ RAD Studio プロジェクト（Win32 / Win64）
  ┣・Main.pas / Main.fmx        ･･･ メインフォーム: UI コントロールとモデル結線
  ┣・Scene.pas                  ･･･ 3D シーン構築（地球儀・点・カメラ）
  ┣・_DATA/                     ･･･ テクスチャ（地球儀・点マーカー; Git LFS）
  ┗・_LIBRARY/                  ･･･ 同梱ライブラリ（参照のみ）
     ┣・Bary/                   ･･･ TBarycenter<> と 6 種の S³ 重心演算子
     ┣・Curve/                  ･･･ ジェネリックなスプライン方式と S³ 別名
     ┗・LUXOPHIA/
        ┣・LUX/                 ･･･ スカラー・ベクトル・四元数・基底関数
        ┣・LUX.Sphere/          ･･･ S²/S³ 点グリッド・曲線・FMX メッシュ
        ┗・LUX.FMX.Graphics.D3/ ･･･ 3D メッシュシェイパー基底クラス
```

## 4. 使い方 / 操作

| 操作 | 効果 |
|---|---|
| ビューポートを左ドラッグ | 地球儀を周回するカメラ操作 |
| **Points › Count** | ループ内の制御四元数の個数: `04` / `06` / `08` / `12` / `20` |
| **Points › Twist Angle** | 制御向きへの局所軸まわりの交互ねじり $\pm\tau$、$\tau \in [-90^\circ, +90^\circ]$ |
| **Upper/Lower Curve › Kind** | スプライン方式: `Linear` / `Bezier` / `B-Spline` / `Catmull-Rom` / `Lanczos` |
| **Upper/Lower Curve › Barycenter** | 平均化演算子: `GLerp` / `Slerp` / `PowSlerp` / `PolySlerp` / `ExpMap` / `ModExpMap` |
| **Algorithm**（各方式タブ） | `Basis Function`（1 回の $n$ 項重心）または `Recursive Lerp`（ペアワイズ再帰）; Bézier・B-Spline・Catmull-Rom で選択可能 |
| **Degree**（Bézier・B-Spline） | 基底次数 $n$、1–10 |
| **Width**（Lanczos） | 窓半径 $a$、1–10 |

*Upper Curve* のサンプル点は上半球、*Lower Curve* のサンプル点は下半球として描かれます。大きい点は共有の制御点です。

## 5. ビルド

1. 必要環境: FireMonkey フレームワークを含む RAD Studio（Delphi）。プロジェクトファイルはフォーマットバージョン 20.4 を使用します。`PolySlerp1DxS3.dproj` に定義されたターゲットプラットフォーム: **Win32** および **Win64**。
2. Git LFS を有効にしてクローンしてください（`git lfs install`）— `_DATA/` のテクスチャは LFS に格納されています。
3. `PolySlerp1DxS3.dproj` を開き、プラットフォームを選択して実行します。ライブラリユニットはすべて `_LIBRARY/` に同梱されており、外部パッケージは不要です。
4. アプリケーションは実行ファイルからの相対パス `..\..\_DATA\` からテクスチャを読み込みます。これは既定の出力ディレクトリ構成（例: `Win64\Debug\`）に一致します。バイナリを移動する場合はこの相対位置を維持してください。

## 6. 参考文献

1. 中山雅紀, 藤代一成, [「PolySlerp: 球面多角線形補間」](https://cir.nii.ac.jp/crid/1390026970010384512), 画像電子学会誌, Vol.54, No.4, pp. 384–393, 2025. [[PDF](https://www.iieej.org/wordpress/wp-content/uploads/2025/11/IIEEJ_Vol54-No4_web_v1.pdf)]
2. K. Shoemake, ["Animating Rotation with Quaternion Curves"](https://doi.org/10.1145/325334.325242), *SIGGRAPH '85*, pp. 245–254, 1985.
3. M.-J. Kim, M.-S. Kim, S. Y. Shin, ["A General Construction Scheme for Unit Quaternion Curves with Simple High Order Derivatives"](https://doi.org/10.1145/218380.218486), *SIGGRAPH '95*, pp. 369–376, 1995.
4. Wikipedia: [Slerp](https://en.wikipedia.org/wiki/Slerp)
5. Wikipedia: [Quaternions and spatial rotation](https://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation)

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
