unit LIB.Curve.Bezier;

interface //#################################################################### ■

uses LIB.Poins,
     LIB.Curve;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBezier<_TValue_>

     TCurveBezier<_TPoin_> = class( TCurve<_TPoin_> )
     private
     protected
       _DegN :Integer;
       ///// A C C E S S O R
       function GetDegN :Integer; virtual;
       procedure SetDegN( const DegN_:Integer ); virtual;
     public
       constructor Create( const Poins_:TPoins<_TPoin_> );
       ///// P R O P E R T Y
       property DegN :Integer read GetDegN write SetDegN;
       ///// M E T H O D
       function Value( const X_:Double ) :_TPoin_; override;
       function CurveREC( Ps:TArray<_TPoin_>; const t:Double; const Lerp_:TDoubleLerp<_TPoin_> ) :_TPoin_;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Bezier( const N_,I_:Integer; const T_:Single ) :Single; overload;
function Bezier( const N_,I_:Integer; const T_:Double ) :Double; overload;

implementation //############################################################### ■

uses System.Math,
     LUX;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBezier<_TValue_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TCurveBezier<_TPoin_>.GetDegN :Integer;
begin
     Result := _DegN;
end;

procedure TCurveBezier<_TPoin_>.SetDegN( const DegN_:Integer );
begin
     _DegN := DegN_;  _OnChange.Run( Self );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCurveBezier<_TPoin_>.Create( const Poins_:TPoins<_TPoin_> );
begin
     inherited;

     DegN := 3;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveBezier<_TPoin_>.Value( const X_:Double ) :_TPoin_;
var
   i, J :Integer;
   t, s :Double;
begin
     i := Floor( X_ );
     t := X_ - I;

     j :=   i div DegN       * DegN;
     s := ( i mod DegN + t ) / DegN;

     Result := Segment( j, s );
end;

//------------------------------------------------------------------------------

function TCurveBezier<_TPoin_>.CurveREC( Ps:TArray<_TPoin_>; const t:Double; const Lerp_:TDoubleLerp<_TPoin_> ) :_TPoin_;
var
   N, I :Integer;
begin
     for N := DegN-1 downto 0 do
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