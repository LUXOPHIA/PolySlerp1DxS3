unit Main;

interface //#################################################################### Å°

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Math, System.Math.Vectors, System.Generics.Collections,
  FMX.Forms, FMX.Edit, FMX.EditBox, FMX.SpinBox, FMX.Controls, FMX.TabControl,
  FMX.StdCtrls, FMX.ListBox, FMX.Controls.Presentation, FMX.Types, FMX.Viewport3D,
  LUX.Poins.S3,
  LUX.Poins.Plots.S3,
  LUX.Curve.S3,
  LUX.Curve.S3.Linear,
  LUX.Curve.S3.Bezier,
  LUX.Curve.S3.BSpline,
  LUX.Curve.S3.CatmullRom,
  Scene;

type
  TForm1 = class(TForm)
    Viewport3D1: TViewport3D;
    Panel1: TPanel;
      Label1: TLabel;
        ComboBox1: TComboBox;
      GroupBoxCU: TGroupBox;
        LabelCUA: TLabel;
          ComboBoxCUA: TComboBox;
        TabControlCU: TTabControl;
          TabItemCU0: TTabItem;
          TabItemCU1: TTabItem;
            LabelCU1D: TLabel;
              SpinBoxCU1D: TSpinBox;
          TabItemCU2: TTabItem;
            LabelCU2D: TLabel;
              SpinBoxCU2D: TSpinBox;
          TabItemCU3: TTabItem;
      GroupBoxCL: TGroupBox;
        LabelCLA: TLabel;
          ComboBoxCLA: TComboBox;
        TabControlCL: TTabControl;
          TabItemCL0: TTabItem;
          TabItemCL1: TTabItem;
            LabelCL1D: TLabel;
              SpinBoxCL1D: TSpinBox;
          TabItemCL2: TTabItem;
            LabelCL2D: TLabel;
              SpinBoxCL2D: TSpinBox;
          TabItemCL3: TTabItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Viewport3D1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure Viewport3D1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure Viewport3D1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBoxCUAChange(Sender: TObject);
    procedure ComboBoxCLAChange(Sender: TObject);
    procedure SpinBoxCU1DChange(Sender: TObject);
    procedure SpinBoxCU2DChange(Sender: TObject);
    procedure SpinBoxCL1DChange(Sender: TObject);
    procedure SpinBoxCL2DChange(Sender: TObject);
  private
    { private êÈåæ }
    _MouseS :TShiftState;
    _MouseP :TPointF;
  public
    { public êÈåæ }
    _Poins3S  :TObjectList<TPoins3S>;
    _Curve3S0 :TObjectList<TCurve3S>;
    _Curve3S1 :TObjectList<TCurve3S>;
    _Plots3S0 :TPlots3S;
    _Plots3S1 :TPlots3S;
  end;

var
  Form1: TForm1;

implementation //############################################################### Å°

{$R *.fmx}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _Poins3S := TObjectList<TPoins3S>.Create;
     ///// Points
     _Poins3S.Add( TPolyPoins3S04.Create );
     _Poins3S.Add( TPolyPoins3S06.Create );
     _Poins3S.Add( TPolyPoins3S08.Create );
     _Poins3S.Add( TPolyPoins3S12.Create );
     _Poins3S.Add( TPolyPoins3S20.Create );

     _Curve3S0 := TObjectList<TCurve3S>.Create;
     ///// Recursive Algorithm Curve
     _Curve3S0.Add( TCurveLinearREC    .Create( _Poins3S[4] ) );
     _Curve3S0.Add( TCurveBezierREC    .Create( _Poins3S[4] ) );
     _Curve3S0.Add( TCurveBSplineREC   .Create( _Poins3S[4] ) );
     _Curve3S0.Add( TCurveCatmullRomREC.Create( _Poins3S[4] ) );

     _Curve3S1 := TObjectList<TCurve3S>.Create;
     ///// Polynomial Curve
     _Curve3S1.Add( TCurveLinearPOL    .Create( _Poins3S[4] ) );
     _Curve3S1.Add( TCurveBezierPOL    .Create( _Poins3S[4] ) );
     _Curve3S1.Add( TCurveBSplinePOL   .Create( _Poins3S[4] ) );
     _Curve3S1.Add( TCurveCatmullRomPOL.Create( _Poins3S[4] ) );

     _Plots3S0 := TPlots3S.Create( _Curve3S0[ 0 ] );
     _Plots3S1 := TPlots3S.Create( _Curve3S1[ 0 ] );

     _Plots3S0.PlotGap := 2 * ArcSin( 0.15 / 5 );
     _Plots3S1.PlotGap := 2 * ArcSin( 0.15 / 5 );

     MakeScene;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Curve3S0.Free;
     _Curve3S1.Free;
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

procedure TForm1.ComboBox1Change(Sender: TObject);
var
   Ps :TPoins3S;
   C :TCurve3S;
begin
     Ps := _Poins3S[ ComboBox1.ItemIndex ];

     for C in _Curve3S0 do C.Poins := Ps;
     for C in _Curve3S1 do C.Poins := Ps;

     _Poins3D.Poins := Ps;
end;

//------------------------------------------------------------------------------

procedure TForm1.ComboBoxCUAChange(Sender: TObject);
begin
     TabControlCU.TabIndex := ComboBoxCUA.ItemIndex;

     _Plots3S0.Curve := _Curve3S0[ ComboBoxCUA.ItemIndex ];
end;

//------------------------------------------------------------------------------

procedure TForm1.ComboBoxCLAChange(Sender: TObject);
begin
     TabControlCL.TabIndex := ComboBoxCLA.ItemIndex;

     _Plots3S1.Curve := _Curve3S1[ ComboBoxCLA.ItemIndex ];
end;

//------------------------------------------------------------------------------

procedure TForm1.SpinBoxCU1DChange(Sender: TObject);
begin
     TCurveBezier ( _Curve3S0[ 1 ] ).DegN := Round( SpinBoxCU1D.Value );
end;

procedure TForm1.SpinBoxCU2DChange(Sender: TObject);
begin
     TCurveBSpline( _Curve3S0[ 2 ] ).DegN := Round( SpinBoxCU2D.Value );
end;

//------------------------------------------------------------------------------

procedure TForm1.SpinBoxCL1DChange(Sender: TObject);
begin
     TCurveBezier ( _Curve3S1[ 1 ] ).DegN := Round( SpinBoxCL1D.Value );
end;

procedure TForm1.SpinBoxCL2DChange(Sender: TObject);
begin
     TCurveBSpline( _Curve3S1[ 2 ] ).DegN := Round( SpinBoxCL2D.Value );
end;

end. //######################################################################### Å°
