program QuaternionCurve;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {Form1},
  LUX.D1 in '_LIBRARY\LUXOPHIA\LUX\LUX.D1.pas',
  LUX.D2 in '_LIBRARY\LUXOPHIA\LUX\LUX.D2.pas',
  LUX.D3 in '_LIBRARY\LUXOPHIA\LUX\LUX.D3.pas',
  LUX in '_LIBRARY\LUXOPHIA\LUX\LUX.pas',
  LUX.FMX.Graphics.D3 in '_LIBRARY\LUXOPHIA\LUX.FMX.Graphics.D3\LUX.FMX.Graphics.D3.pas',
  LUX.FMX.Graphics.D3.Shaper in '_LIBRARY\LUXOPHIA\LUX.FMX.Graphics.D3\LUX.FMX.Graphics.D3.Shaper.pas',
  LUX.D4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D4.pas',
  LUX.D4x4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D4x4.pas',
  LUX.D2x2 in '_LIBRARY\LUXOPHIA\LUX\LUX.D2x2.pas',
  LUX.D3x3 in '_LIBRARY\LUXOPHIA\LUX\LUX.D3x3.pas',
  LUX.Quaternion in '_LIBRARY\LUXOPHIA\LUX\LUX.Quaternion.pas',
  LIB.D4 in '_LIBRARY\LUXOPHIA\LUX.Sphere\LIB.D4.pas',
  LIB.D3 in '_LIBRARY\LUXOPHIA\LUX.Sphere\LIB.D3.pas',
  LUX.S2 in '_LIBRARY\LUXOPHIA\LUX.Sphere\S2\LUX.S2.pas',
  LUX.S3 in '_LIBRARY\LUXOPHIA\LUX.Sphere\S3\LUX.S3.pas',
  LUX.FMX.S3 in '_LIBRARY\LUXOPHIA\LUX.Sphere\S3\FMX\LUX.FMX.S3.pas',
  LUX.FMX.Sphere in '_LIBRARY\LUXOPHIA\LUX.Sphere\FMX\LUX.FMX.Sphere.pas',
  Scene in 'Scene.pas',
  LUX.FMX.S2 in '_LIBRARY\LUXOPHIA\LUX.Sphere\S2\FMX\LUX.FMX.S2.pas',
  LIB in '_LIBRARY\LUXOPHIA\LUX.Sphere\LIB.pas',
  LUX.Curve.S2.BSpline in '_LIBRARY\LUXOPHIA\LUX.Sphere\S2\Curve\LUX.Curve.S2.BSpline.pas',
  LUX.Curve.S2.CatmullRom in '_LIBRARY\LUXOPHIA\LUX.Sphere\S2\Curve\LUX.Curve.S2.CatmullRom.pas',
  LUX.Curve.S2.Linear in '_LIBRARY\LUXOPHIA\LUX.Sphere\S2\Curve\LUX.Curve.S2.Linear.pas',
  LUX.Curve.S2 in '_LIBRARY\LUXOPHIA\LUX.Sphere\S2\Curve\LUX.Curve.S2.pas',
  LUX.Curve.S2.Bezier in '_LIBRARY\LUXOPHIA\LUX.Sphere\S2\Curve\LUX.Curve.S2.Bezier.pas',
  LUX.Curve.S3.Linear in '_LIBRARY\LUXOPHIA\LUX.Sphere\S3\Curve\LUX.Curve.S3.Linear.pas',
  LUX.Curve.S3 in '_LIBRARY\LUXOPHIA\LUX.Sphere\S3\Curve\LUX.Curve.S3.pas',
  LUX.Curve.S3.Bezier in '_LIBRARY\LUXOPHIA\LUX.Sphere\S3\Curve\LUX.Curve.S3.Bezier.pas',
  LUX.Curve.S3.BSpline in '_LIBRARY\LUXOPHIA\LUX.Sphere\S3\Curve\LUX.Curve.S3.BSpline.pas',
  LUX.Curve.S3.CatmullRom in '_LIBRARY\LUXOPHIA\LUX.Sphere\S3\Curve\LUX.Curve.S3.CatmullRom.pas',
  LUX.S3.Bary.PolySlerp in '_LIBRARY\LUXOPHIA\LUX.Sphere\S3\Bary\LUX.S3.Bary.PolySlerp.pas',
  LUX.S3.Bary.Glerp in '_LIBRARY\LUXOPHIA\LUX.Sphere\S3\Bary\LUX.S3.Bary.Glerp.pas',
  LUX.S3.Bary in '_LIBRARY\LUXOPHIA\LUX.Sphere\S3\Bary\LUX.S3.Bary.pas',
  LUX.Poins.Plots.S3 in '_LIBRARY\LUXOPHIA\LUX.Sphere\S3\Poins\LUX.Poins.Plots.S3.pas',
  LUX.Poins.S3 in '_LIBRARY\LUXOPHIA\LUX.Sphere\S3\Poins\LUX.Poins.S3.pas',
  LUX.Poins.S2 in '_LIBRARY\LUXOPHIA\LUX.Sphere\S2\Poins\LUX.Poins.S2.pas',
  LUX.Poins.Plots.S2 in '_LIBRARY\LUXOPHIA\LUX.Sphere\S2\Poins\LUX.Poins.Plots.S2.pas',
  LUX.S3.Bary.Slerp in '_LIBRARY\LUXOPHIA\LUX.Sphere\S3\Bary\LUX.S3.Bary.Slerp.pas',
  LUX.S3.Bary.ExpMap in '_LIBRARY\LUXOPHIA\LUX.Sphere\S3\Bary\LUX.S3.Bary.ExpMap.pas',
  LUX.S3.Bary.PowSlerp in '_LIBRARY\LUXOPHIA\LUX.Sphere\S3\Bary\LUX.S3.Bary.PowSlerp.pas',
  LUX.S3.Bary.ModExpMap in '_LIBRARY\LUXOPHIA\LUX.Sphere\S3\Bary\LUX.S3.Bary.ModExpMap.pas',
  LIB.Curve.Linear in '_LIBRARY\LUXOPHIA\LUX.Sphere\Curve\LIB.Curve.Linear.pas',
  LIB.Curve in '_LIBRARY\LUXOPHIA\LUX.Sphere\Curve\LIB.Curve.pas',
  LIB.Curve.Bezier in '_LIBRARY\LUXOPHIA\LUX.Sphere\Curve\LIB.Curve.Bezier.pas',
  LIB.Curve.BSpline in '_LIBRARY\LUXOPHIA\LUX.Sphere\Curve\LIB.Curve.BSpline.pas',
  LIB.Curve.CatmullRom in '_LIBRARY\LUXOPHIA\LUX.Sphere\Curve\LIB.Curve.CatmullRom.pas',
  LIB.Poins in '_LIBRARY\LUXOPHIA\LUX.Sphere\Poins\LIB.Poins.pas',
  LIB.Poins.Plots in '_LIBRARY\LUXOPHIA\LUX.Sphere\Poins\LIB.Poins.Plots.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
