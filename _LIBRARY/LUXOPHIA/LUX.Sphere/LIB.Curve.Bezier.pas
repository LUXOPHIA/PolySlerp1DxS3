unit LIB.Curve.Bezier;

interface //#################################################################### ■

uses LIB.Curve;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleBezier<_TValue_>

     TSingleBezier<_TValue_> = class
     public
       ///// M E T H O D
       class function CurveREC( Ps:TArray<_TValue_>; const t:Single; const DegN_:Integer; const Lerp_:TSingleLerp<_TValue_> ) :_TValue_;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleBezier<_TValue_>

     TDoubleBezier<_TValue_> = class
     public
       ///// M E T H O D
       class function CurveREC( Ps:TArray<_TValue_>; const t:Double; const DegN_:Integer; const Lerp_:TDoubleLerp<_TValue_> ) :_TValue_;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Bezier( const N_,I_:Integer; const T_:Double ) :Double;

implementation //############################################################### ■

uses System.Math,
     LUX;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleBezier<_TValue_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

class function TSingleBezier<_TValue_>.CurveREC( Ps:TArray<_TValue_>; const t:Single; const DegN_:Integer; const Lerp_:TSingleLerp<_TValue_> ) :_TValue_;
var
   N, I :Integer;
begin
     for N := DegN_-1 downto 0 do
     begin
          for I := 0 to N do Ps[ I ] := Lerp_( Ps[ I ], Ps[ I+1 ], t );
     end;

     Result := Ps[ 0 ];
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleBezier<_TValue_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

class function TDoubleBezier<_TValue_>.CurveREC( Ps:TArray<_TValue_>; const t:Double; const DegN_:Integer; const Lerp_:TDoubleLerp<_TValue_> ) :_TValue_;
var
   N, I :Integer;
begin
     for N := DegN_-1 downto 0 do
     begin
          for I := 0 to N do Ps[ I ] := Lerp_( Ps[ I ], Ps[ I+1 ], t );
     end;

     Result := Ps[ 0 ];
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Bezier( const N_,I_:Integer; const T_:Double ) :Double;
begin
     Result := Binomial( N_, I_ ) * IntPower( 1 - T_, N_ - I_ )
                                  * IntPower(     T_,      I_ );
end;

end. //######################################################################### ■