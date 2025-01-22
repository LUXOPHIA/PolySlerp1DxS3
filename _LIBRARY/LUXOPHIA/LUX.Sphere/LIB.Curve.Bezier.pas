unit LIB.Curve.Bezier;

interface //#################################################################### ■

uses LIB.Curve;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleBezier<_TValue_>

     TSingleBezier<_TPoin_> = class
     public
       ///// M E T H O D
       class function CurveREC( Ps:TArray<_TPoin_>; const t:Single; const Lerp_:TSingleLerp<_TPoin_> ) :_TPoin_;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleBezier<_TValue_>

     TDoubleBezier<_TPoin_> = class
     public
       ///// M E T H O D
       class function CurveREC( Ps:TArray<_TPoin_>; const t:Double; const Lerp_:TDoubleLerp<_TPoin_> ) :_TPoin_;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Bezier( const N_,I_:Integer; const T_:Single ) :Single; overload;
function Bezier( const N_,I_:Integer; const T_:Double ) :Double; overload;

implementation //############################################################### ■

uses System.Math,
     LUX;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleBezier<_TValue_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

class function TSingleBezier<_TPoin_>.CurveREC( Ps:TArray<_TPoin_>; const t:Single; const Lerp_:TSingleLerp<_TPoin_> ) :_TPoin_;
var
   N, I :Integer;
begin
     for N := Length( Ps )-1 downto 0 do
     begin
          for I := 0 to N do Ps[ I ] := Lerp_( Ps[ I ], Ps[ I+1 ], t );
     end;

     Result := Ps[ 0 ];
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleBezier<_TValue_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

class function TDoubleBezier<_TPoin_>.CurveREC( Ps:TArray<_TPoin_>; const t:Double; const Lerp_:TDoubleLerp<_TPoin_> ) :_TPoin_;
var
   N, I :Integer;
begin
     for N := Length( Ps )-1 downto 0 do
     begin
          for I := 0 to N do Ps[ I ] := Lerp_( Ps[ I ], Ps[ I+1 ], t );
     end;

     Result := Ps[ 0 ];
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Bezier( const N_,I_:Integer; const T_:Single ) :Single;
begin
     Result := Binomial( N_, I_ ) * IntPower( 1 - T_, N_ - I_ )
                                  * IntPower(     T_,      I_ );
end;

function Bezier( const N_,I_:Integer; const T_:Double ) :Double;
begin
     Result := Binomial( N_, I_ ) * IntPower( 1 - T_, N_ - I_ )
                                  * IntPower(     T_,      I_ );
end;

end. //######################################################################### ■