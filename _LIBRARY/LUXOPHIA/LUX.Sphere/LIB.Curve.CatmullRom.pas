unit LIB.Curve.CatmullRom;

interface //#################################################################### ■

uses LUX.D4,
     LIB.Curve;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRom<_TValue_>

     TCurveCatmullRom<_TPoin_> = class( TCurve<_TPoin_> )
     public
       ///// M E T H O D
       function CurveREC( Ps:TArray<_TPoin_>; const t:Double; const Lerp_:TDoubleLerp<_TPoin_> ) :_TPoin_;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function CatmullRom( const t:Single ) :TSingle4D; overload;
function CatmullRom( const t:Double ) :TDouble4D; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRom<_TValue_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveCatmullRom<_TPoin_>.CurveREC( Ps:TArray<_TPoin_>; const t:Double; const Lerp_:TDoubleLerp<_TPoin_> ) :_TPoin_;
begin
     Ps[0] := Lerp_( Ps[0], Ps[1],   t + 1       );
     Ps[1] := Lerp_( Ps[1], Ps[2],   t           );
     Ps[2] := Lerp_( Ps[2], Ps[3],   t - 1       );

     Ps[0] := Lerp_( Ps[0], Ps[1], ( t + 1 ) / 2 );
     Ps[1] := Lerp_( Ps[1], Ps[2],   t       / 2 );

     Ps[0] := Lerp_( Ps[0], Ps[1],   t           );

     Result := Ps[0];
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function CatmullRom( const t:Single ) :TSingle4D;
begin
     Result[1] := ( ( -0.5 * t + 1.0 ) * t - 0.5 ) * t      ;
     Result[2] := ( ( +1.5 * t - 2.5 ) * t       ) * t + 1.0;
     Result[3] := ( ( -1.5 * t + 2.0 ) * t + 0.5 ) * t      ;
     Result[4] := ( ( +0.5 * t - 0.5 ) * t       ) * t      ;
end;

function CatmullRom( const t:Double ) :TDouble4D;
begin
     Result[1] := ( ( -0.5 * t + 1.0 ) * t - 0.5 ) * t      ;
     Result[2] := ( ( +1.5 * t - 2.5 ) * t       ) * t + 1.0;
     Result[3] := ( ( -1.5 * t + 2.0 ) * t + 0.5 ) * t      ;
     Result[4] := ( ( +0.5 * t - 0.5 ) * t       ) * t      ;
end;

end. //######################################################################### ■