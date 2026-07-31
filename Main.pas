unit Main;

interface //#################################################################### Å°

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Math, System.Math.Vectors, System.Generics.Collections,
  FMX.Forms, FMX.Edit, FMX.EditBox, FMX.SpinBox, FMX.Controls, FMX.TabControl,
  FMX.StdCtrls, FMX.ListBox, FMX.Controls.Presentation, FMX.Types, FMX.Viewport3D,
  LUX,
  LUX.S3,
  LUX.S3.Data.Grid.D1,
  LUX.S3.Data.Grid.D1.Plots,
  LIB.Bary.S3,
  LIB.Bary.S3.Glerp,
  LIB.Bary.S3.Slerp,
  LIB.Bary.S3.PowSlerp,
  LIB.Bary.S3.PolySlerp,
  LIB.Bary.S3.ExpMap,
  LIB.Bary.S3.ModExpMap,
  LIB.Curve.S3,
  LIB.Curve.S3.Linear,
  LIB.Curve.S3.Bezier,
  LIB.Curve.S3.BSpline,
  LIB.Curve.S3.CatmullRom,
  LIB.Curve.S3.Lanczos,
  Scene;

type
  TForm1 = class(TForm)
    Viewport3D1: TViewport3D;
    Panel1: TPanel;
      GroupBoxP: TGroupBox;
        LabelPN: TLabel;
          ComboBoxPN: TComboBox;
        LabelPT: TLabel;
          ScrollBarPT: TScrollBar;
      GroupBoxUC: TGroupBox;
        LabelUCK: TLabel;
          ComboBoxUCK: TComboBox;
        LabelUCB: TLabel;
          ComboBoxUCB: TComboBox;
        TabControlUC: TTabControl;
          TabItemUC0: TTabItem;
            LabelUC0A: TLabel;
              ComboBoxUC0A: TComboBox;
            LabelUC0D: TLabel;
              SpinBoxUC0D: TSpinBox;
          TabItemUC1: TTabItem;
            LabelUC1A: TLabel;
              ComboBoxUC1A: TComboBox;
            LabelUC1D: TLabel;
              SpinBoxUC1D: TSpinBox;
          TabItemUC2: TTabItem;
            LabelUC2A: TLabel;
              ComboBoxUC2A: TComboBox;
            LabelUC2D: TLabel;
              SpinBoxUC2D: TSpinBox;
          TabItemUC3: TTabItem;
            LabelUC3A: TLabel;
              ComboBoxUC3A: TComboBox;
            LabelUC3D: TLabel;
              SpinBoxUC3D: TSpinBox;
          TabItemUC4: TTabItem;
            LabelUC4A: TLabel;
              ComboBoxUC4A: TComboBox;
            LabelUC4W: TLabel;
              SpinBoxUC4W: TSpinBox;
      GroupBoxLC: TGroupBox;
        LabelLCK: TLabel;
          ComboBoxLCK: TComboBox;
        LabelLCB: TLabel;
          ComboBoxLCB: TComboBox;
        TabControlLC: TTabControl;
          TabItemLC0: TTabItem;
            LabelLC0A: TLabel;
              ComboBoxLC0A: TComboBox;
            LabelLC0D: TLabel;
              SpinBoxLC0D: TSpinBox;
          TabItemLC1: TTabItem;
            LabelLC1A: TLabel;
              ComboBoxLC1A: TComboBox;
            LabelLC1D: TLabel;
              SpinBoxLC1D: TSpinBox;
          TabItemLC2: TTabItem;
            LabelLC2A: TLabel;
              ComboBoxLC2A: TComboBox;
            LabelLC2D: TLabel;
              SpinBoxLC2D: TSpinBox;
          TabItemLC3: TTabItem;
            LabelLC3A: TLabel;
              ComboBoxLC3A: TComboBox;
            LabelLC3D: TLabel;
              SpinBoxLC3D: TSpinBox;
          TabItemLC4: TTabItem;
            LabelLC4A: TLabel;
              ComboBoxLC4A: TComboBox;
            LabeLC4W: TLabel;
              SpinBoxLC4W: TSpinBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Viewport3D1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure Viewport3D1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure Viewport3D1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure ComboBoxPNChange(Sender: TObject);
    procedure ScrollBarPTChange(Sender: TObject);
    procedure ComboBoxUCKChange(Sender: TObject);
    procedure ComboBoxLCKChange(Sender: TObject);
    procedure ComboBoxUCBChange(Sender: TObject);
    procedure ComboBoxLCBChange(Sender: TObject);
    procedure ComboBoxUC1AChange(Sender: TObject);
    procedure ComboBoxLC1AChange(Sender: TObject);
    procedure SpinBoxUC1DChange(Sender: TObject);
    procedure SpinBoxLC1DChange(Sender: TObject);
    procedure ComboBoxUC2AChange(Sender: TObject);
    procedure ComboBoxLC2AChange(Sender: TObject);
    procedure SpinBoxUC2DChange(Sender: TObject);
    procedure SpinBoxLC2DChange(Sender: TObject);
    procedure ComboBoxUC3AChange(Sender: TObject);
    procedure ComboBoxLC3AChange(Sender: TObject);
    procedure SpinBoxUC4WChange(Sender: TObject);
    procedure SpinBoxLC4WChange(Sender: TObject);
  private
    { private êÈåæ }
    _MouseS :TShiftState;
    _MouseP :TPointF;
  public
    { public êÈåæ }
    _Poins3S  :TObjectList<TPolyPoins3S>;
    _Bary3S   :TObjectList<TDoubleBary3S>;
    _Curve3S0 :TObjectList<TCurve3S>;
    _Curve3S1 :TObjectList<TCurve3S>;
    _Plots3S0 :TPlots3S;
    _Plots3S1 :TPlots3S;
    ///// M E T H O D
    procedure MakeObject;
    procedure InitObject;
  end;


var
  Form1: TForm1;

implementation //############################################################### Å°

{$R *.fmx}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

procedure TForm1.MakeObject;
begin
     ///// Point Set
     _Poins3S.Add( TPolyPoins3S04.Create );  // 0: 04
     _Poins3S.Add( TPolyPoins3S06.Create );  // 1: 06
     _Poins3S.Add( TPolyPoins3S08.Create );  // 2: 08
     _Poins3S.Add( TPolyPoins3S12.Create );  // 3: 12
     _Poins3S.Add( TPolyPoins3S20.Create );  // 4: 20

     ///// Barycenter
     _Bary3S.Add( TBaryGLerp3S    .Create );  // 0: GLerp
     _Bary3S.Add( TBarySlerp3S    .Create );  // 1: Slerp
     _Bary3S.Add( TBaryPowSlerp3S .Create );  // 2: PowSlerp
     _Bary3S.Add( TBaryPolySlerp3S.Create );  // 3: PolySlerp
     _Bary3S.Add( TBaryExpMap3S   .Create );  // 4: ExpMap
     _Bary3S.Add( TBaryModExpMap3S.Create );  // 5: ModExpMap

     ///// Curve
     _Curve3S0.Add( TCurveLinear3S    .Create );  // 0: Linear
     _Curve3S0.Add( TCurveBezier3S    .Create );  // 1: Bezier
     _Curve3S0.Add( TCurveBSpline3S   .Create );  // 2: B-Spline
     _Curve3S0.Add( TCurveCatmullRom3S.Create );  // 3: Catmull-Rom
     _Curve3S0.Add( TCurveLanczos3S   .Create );  // 4: Lanczos

     _Curve3S1.Add( TCurveLinear3S    .Create );  // 0: Linear
     _Curve3S1.Add( TCurveBezier3S    .Create );  // 1: Bezier
     _Curve3S1.Add( TCurveBSpline3S   .Create );  // 2: B-Spline
     _Curve3S1.Add( TCurveCatmullRom3S.Create );  // 3: Catmull-Rom
     _Curve3S1.Add( TCurveLanczos3S   .Create );  // 4: Lanczos
end;

procedure TForm1.InitObject;
begin
     ///// Point Set
     ComboBoxPNChange ( Self );
     ScrollBarPTChange( Self );

     ///// Barycenter
     ComboBoxUCBChange( Self );
     ComboBoxLCBChange( Self );

     ///// Curve
     ComboBoxUCKChange( Self );
     ComboBoxLCKChange( Self );

     // 1: Bezier
     ComboBoxUC1AChange( Self );  SpinBoxUC1DChange( Self );
     ComboBoxLC1AChange( Self );  SpinBoxLC1DChange( Self );

     // 2: B-Spline
     ComboBoxUC2AChange( Self );  SpinBoxUC2DChange( Self );
     ComboBoxLC2AChange( Self );  SpinBoxLC2DChange( Self );

     // 3: Catmull-Rom
     ComboBoxUC3AChange( Self );
     ComboBoxLC3AChange( Self );

     // 4: Lanczos
     SpinBoxUC4WChange( Self );
     SpinBoxLC4WChange( Self );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _Poins3S  := TObjectList<TPolyPoins3S> .Create;
     _Bary3S   := TObjectList<TDoubleBary3S>.Create;
     _Curve3S0 := TObjectList<TCurve3S>     .Create;
     _Curve3S1 := TObjectList<TCurve3S>     .Create;
     _Plots3S0 := TPlots3S                  .Create;
     _Plots3S1 := TPlots3S                  .Create;

     MakeObject;

     MakeScene;

     _Plots3S0.PlotGap := 2 * ArcSin( _Plots3D0.DotSize.x / _Plots3D0.Radius ){rad};
     _Plots3S1.PlotGap := 2 * ArcSin( _Plots3D1.DotSize.x / _Plots3D1.Radius ){rad};

     InitObject;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Poins3D .Poins := nil;
     _Plots3D0.Poins := nil;
     _Plots3D1.Poins := nil;

     _Plots3S0.Free;
     _Plots3S1.Free;
     _Curve3S0.Free;
     _Curve3S1.Free;
     _Bary3S  .Free;
     _Poins3S .Free;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.Viewport3D1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
     _MouseS := Shift;
     _MouseP := TPointF.Create( X, Y );
end;

procedure TForm1.Viewport3D1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
var
   P :TPointF;
begin
     if ssLeft in _MouseS then
     begin
          P := TPointF.Create( X, Y );

          with _Camera3D do
          begin
               AngleX := AngleX - DegToRad( P.X - _MouseP.X );
               AngleY := AngleY + DegToRad( P.Y - _MouseP.Y );
          end;

          _MouseP := P;
     end;
end;

procedure TForm1.Viewport3D1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
     Viewport3D1MouseMove( Sender, Shift, X, Y );

     _MouseS := [];
end;

//------------------------------------------------------------------------------

procedure TForm1.ComboBoxPNChange(Sender: TObject);
var
   Ps :TPoins3S;
   C :TCurve3S;
begin
     Ps := _Poins3S[ ComboBoxPN.ItemIndex ];

     for C in _Curve3S0 do C.Poins := Ps;
     for C in _Curve3S1 do C.Poins := Ps;

     _Poins3D.Poins := Ps;
end;

procedure TForm1.ScrollBarPTChange(Sender: TObject);
var
   Ps :TPolyPoins3S;
begin
     for Ps in _Poins3S do Ps.Twist := DegToRad( ScrollBarPT.Value );
end;

//------------------------------------------------------------------------------

procedure TForm1.ComboBoxUCKChange(Sender: TObject);
begin
     TabControlUC.TabIndex := ComboBoxUCK.ItemIndex;

     _Plots3S1.Curve := _Curve3S1[ ComboBoxUCK.ItemIndex ];
end;

procedure TForm1.ComboBoxLCKChange(Sender: TObject);
begin
     TabControlLC.TabIndex := ComboBoxLCK.ItemIndex;

     _Plots3S0.Curve := _Curve3S0[ ComboBoxLCK.ItemIndex ];
end;

//------------------------------------------------------------------------------

procedure TForm1.ComboBoxUCBChange(Sender: TObject);
var
   C :TCurve3S;
begin
     for C in _Curve3S1 do C.Bary := _Bary3S[ ComboBoxUCB.ItemIndex ];
end;

procedure TForm1.ComboBoxLCBChange(Sender: TObject);
var
   C :TCurve3S;
begin
     for C in _Curve3S0 do C.Bary := _Bary3S[ ComboBoxLCB.ItemIndex ];
end;

//------------------------------------------------------------------------------

procedure TForm1.ComboBoxUC1AChange(Sender: TObject);
begin
     TCurveBezier3S( _Curve3S1[ 1 ] ).AlgoID := ComboBoxUC1A.ItemIndex;
end;

procedure TForm1.ComboBoxLC1AChange(Sender: TObject);
begin
     TCurveBezier3S( _Curve3S0[ 1 ] ).AlgoID := ComboBoxLC1A.ItemIndex;
end;

procedure TForm1.SpinBoxUC1DChange(Sender: TObject);
begin
     TCurveBezier3S( _Curve3S1[ 1 ] ).DegN := Round( SpinBoxUC1D.Value );
end;

procedure TForm1.SpinBoxLC1DChange(Sender: TObject);
begin
     TCurveBezier3S( _Curve3S0[ 1 ] ).DegN := Round( SpinBoxLC1D.Value );
end;

//------------------------------------------------------------------------------

procedure TForm1.ComboBoxUC2AChange(Sender: TObject);
begin
     TCurveBSpline3S( _Curve3S1[ 2 ] ).AlgoID := ComboBoxUC2A.ItemIndex;
end;

procedure TForm1.ComboBoxLC2AChange(Sender: TObject);
begin
     TCurveBSpline3S( _Curve3S0[ 2 ] ).AlgoID := ComboBoxLC2A.ItemIndex;
end;

procedure TForm1.SpinBoxUC2DChange(Sender: TObject);
begin
     TCurveBSpline3S( _Curve3S1[ 2 ] ).DegN := Round( SpinBoxUC2D.Value );
end;

procedure TForm1.SpinBoxLC2DChange(Sender: TObject);
begin
     TCurveBSpline3S( _Curve3S0[ 2 ] ).DegN := Round( SpinBoxLC2D.Value );
end;

//------------------------------------------------------------------------------

procedure TForm1.ComboBoxUC3AChange(Sender: TObject);
begin
     TCurveCatmullRom3S( _Curve3S1[ 3 ] ).AlgoID := ComboBoxUC3A.ItemIndex;
end;

procedure TForm1.ComboBoxLC3AChange(Sender: TObject);
begin
     TCurveCatmullRom3S( _Curve3S0[ 3 ] ).AlgoID := ComboBoxLC3A.ItemIndex;
end;

//------------------------------------------------------------------------------

procedure TForm1.SpinBoxUC4WChange(Sender: TObject);
begin
     TCurveLanczos3S( _Curve3S1[ 4 ] ).WinR := Round( SpinBoxUC4W.Value );
end;

procedure TForm1.SpinBoxLC4WChange(Sender: TObject);
begin
     TCurveLanczos3S( _Curve3S0[ 4 ] ).WinR := Round( SpinBoxLC4W.Value );
end;

end. //######################################################################### Å°
