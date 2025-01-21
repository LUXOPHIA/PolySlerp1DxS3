unit LIB.Curve.CatmullRom;

interface //#################################################################### ■

uses LUX.D4,
     LIB.Curve;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleCatmullRom<_TValue_>

     TSingleCatmullRom<_TValue_> = class
     public
       ///// M E T H O D
       class function CurveREC( P0,P1,P2,P3:_TValue_; const t:Single; const Lerp_:TSingleLerp<_TValue_> ) :_TValue_;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleCatmullRom<_TValue_>

     TDoubleCatmullRom<_TValue_> = class
     public
       ///// M E T H O D
       class function CurveREC( P0,P1,P2,P3:_TValue_; const t:Double; const Lerp_:TDoubleLerp<_TValue_> ) :_TValue_;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function CatmullRom( const t:Single ) :TSingle4D; overload;
function CatmullRom( const t:Double ) :TDouble4D; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleCatmullRom<_TValue_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

class function TSingleCatmullRom<_TValue_>.CurveREC( P0,P1,P2,P3:_TValue_; const t:Single; const Lerp_:TSingleLerp<_TValue_> ) :_TValue_;
begin
     P0 := Lerp_( P0, P1,   t + 1       );
     P1 := Lerp_( P1, P2,   t           );
     P2 := Lerp_( P2, P3,   t - 1       );

     P0 := Lerp_( P0, P1, ( t + 1 ) / 2 );
     P1 := Lerp_( P1, P2,   t       / 2 );

     P0 := Lerp_( P0, P1,   t           );

     Result := P0;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleCatmullRom<_TValue_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

class function TDoubleCatmullRom<_TValue_>.CurveREC( P0,P1,P2,P3:_TValue_; const t:Double; const Lerp_:TDoubleLerp<_TValue_> ) :_TValue_;
begin
     P0 := Lerp_( P0, P1,   t + 1       );
     P1 := Lerp_( P1, P2,   t           );
     P2 := Lerp_( P2, P3,   t - 1       );

     P0 := Lerp_( P0, P1, ( t + 1 ) / 2 );
     P1 := Lerp_( P1, P2,   t       / 2 );

     P0 := Lerp_( P0, P1,   t           );

     Result := P0;
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