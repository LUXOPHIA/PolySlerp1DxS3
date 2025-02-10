unit LUX.S3.Curve.PolySlerp;

// Slerp :Sherical Linear Interpolation

interface //#################################################################### ■

uses LUX,
     LUX.S3.Curve;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PolySlerp1D

function PolySlerp1D( Ps_:TArray<TSingle3Sw> ) :TSingle3Sw; overload;
function PolySlerp1D( Ps_:TArray<TDouble3Sw> ) :TDouble3Sw; overload;

implementation //############################################################### ■

uses System.Math,
     LUX.Quaternion,
     LUX.S3.Curve.Glerp;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PolySlerp1D

//  4A /1-+
//        |- 4A+2B /1-+
//  4B /2-+           |- 4A+3B+1C /1-+
//        |- 2B+2C /2-+              |- 4A+4B+4C+4D
//  4C /2-+           |- 1B+3C+4D /1-+
//        |- 2C+4D /1-+
//  4D /1-+

function PolySlerp1D( Ps_:TArray<TSingle3Sw> ) :TSingle3Sw;
var
   N, L, I :Integer;
begin
     N := High( Ps_ );

     for L := N-1 downto 0 do
     begin
          for I := 1 to L do Ps_[ I ] := Ps_[ I ] / 2;

          for I := 0 to L do Ps_[ I ] := Ps_[ I ] + Ps_[ I+1 ];
     end;

     Result := Ps_[ 0 ];
end;

function PolySlerp1D( Ps_:TArray<TDouble3Sw> ) :TDouble3Sw;
var
   N, L, I :Integer;
begin
     N := High( Ps_ );

     for L := N-1 downto 0 do
     begin
          for I := 1 to L do Ps_[ I ] := Ps_[ I ] / 2;

          for I := 0 to L do Ps_[ I ] := Ps_[ I ] + Ps_[ I+1 ];
     end;

     Result := Ps_[ 0 ];
end;

end. //######################################################################### ■