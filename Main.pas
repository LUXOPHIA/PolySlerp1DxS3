unit Main;

interface //#################################################################### Å°

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Math, System.Math.Vectors,
  FMX.Forms, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls,
  FMX.Controls, FMX.Controls.Presentation, FMX.Types, FMX.Viewport3D,
  FMX.ExtCtrls, FMX.ListBox,
  LUX.S3,
  LUX.Poins.S3,
  LUX.Poins.Plots.S3,
  LUX.Curve.S3,
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
      Button1: TButton;
        Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Viewport3D1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure Viewport3D1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure Viewport3D1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure ComboBox1Change(Sender: TObject);
  private
    { private êÈåæ }
    _MouseS :TShiftState;
    _MouseP :TPointF;
  public
    { public êÈåæ }
    _Poins3S  :TPoins3S;
    _Curve3S0 :TCurve3S;
    _Curve3S1 :TCurve3S;
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
     _Poins3S := TPolyhedron12.Create;

     _Curve3S0 := TCurveBSplineREC.Create( _Poins3S );
     _Curve3S1 := TCurveBSplinePOL.Create( _Poins3S );

     _Plots3S0 := TPlots3S.Create( _Curve3S0 );
     _Plots3S1 := TPlots3S.Create( _Curve3S1 );

     _Plots3S0.PlotGap := 2 * ArcSin( 0.15 / 5 );
     _Plots3S1.PlotGap := 2 * ArcSin( 0.15 / 5 );

     MakeScene;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Poins3S.Free;
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
begin
     _Poins3D .Poins := nil;
     _Curve3S0.Poins := nil;
     _Curve3S1.Poins := nil;

     _Poins3S.Free;

     case ComboBox1.ItemIndex of
       0: _Poins3S := TPolyhedron4 .Create;
       1: _Poins3S := TPolyhedron8 .Create;
       2: _Poins3S := TPolyhedron6 .Create;
       3: _Poins3S := TPolyhedron20.Create;
       4: _Poins3S := TPolyhedron12.Create;
     end;

     _Poins3D .Poins := _Poins3S;
     _Curve3S0.Poins := _Poins3S;
     _Curve3S1.Poins := _Poins3S;
end;

end. //######################################################################### Å°
