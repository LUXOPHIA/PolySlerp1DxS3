unit LUX.S2.Curve.D2.AveVecs;

interface //#################################################################### ■

uses LUX,
     LUX.S2,
     LUX.S2.Curve;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 V A R I A B L E 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function AveVecs( const V1_, V2_, V3_:TSingle2Sw ) :TSingle2Sw; overload;
function AveVecs( const V1_, V2_, V3_:TDouble2Sw ) :TDouble2Sw; overload;

implementation //############################################################### ■

uses LUX.D3,
     LUX.S2.Curve.Lerp,
     LUX.S2.Curve.Glerp;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PolySlerp

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AveVecs

function AveVecs( const V1_,V2_,V3_:TSingle2Sw ) :TSingle2Sw;
var
   N :Integer;
   P1, P2, P3 :TSingle2S;
   Vd :TSingle2S;
begin
     Result := Glerp( V1_, V2_, V3_ );

     for N := 1 to 10000 do
     begin
          P1 := V1_.v - DotProduct( Result.v, V1_.v ) * Result.v;
          P2 := V2_.v - DotProduct( Result.v, V2_.v ) * Result.v;
          P3 := V3_.v - DotProduct( Result.v, V3_.v ) * Result.v;

          Vd := Lerp( P1, P2, P3, V1_.w, V2_.w, V3_.w );

          if Vd.Size2 < SINGLE_EPS3 then Break;

          Result.v := ( Result.v + Vd ).Unitor;
     end;
end;

function AveVecs( const V1_,V2_,V3_:TDouble2Sw ) :TDouble2Sw;
const
     DOUBLE_EPS9 = DOUBLE_EPS * 1E9;
var
   N :Integer;
   P1, P2, P3 :TDouble2S;
   Vd :TDouble2S;
begin
     Result := Glerp( V1_, V2_, V3_ );

     for N := 1 to 10000 do
     begin
          P1 := V1_.v - DotProduct( Result.v, V1_.v ) * Result.v;
          P2 := V2_.v - DotProduct( Result.v, V2_.v ) * Result.v;
          P3 := V3_.v - DotProduct( Result.v, V3_.v ) * Result.v;

          Vd := Lerp( P1, P2, P3, V1_.w, V2_.w, V3_.w );

          if Vd.Size2 < DOUBLE_EPS9 then Break;

          Result.v := ( Result.v + Vd ).Unitor;
     end;
end;

end. //######################################################################### ■