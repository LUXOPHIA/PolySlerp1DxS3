unit LUX.S3.Bary.PowSlerp;

// Slerp :Sherical Linear Interpolation

interface //#################################################################### ■

uses LUX.S3,
     LUX.S3.Bary;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBaryPowSlerp3S

     TBaryPowSlerp3S = class( TDoubleBary3S )
     private
     protected
     public
       ///// M E T H O D
       function Center( const Ps_:TArray<TDoubleW3S> ) :TDouble3S; override;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PowSlerp

function PowSlerp( const Q0_,Q1_:TSingle3S; const T_:Single ) :TSingle3S; overload;
function PowSlerp( const Q0_,Q1_:TDouble3S; const T_:Double ) :TDouble3S; overload;

function PowSlerp( const P1_,P2_:TSingleW3S ) :TSingleW3S; overload;
function PowSlerp( const P1_,P2_:TDoubleW3S ) :TDoubleW3S; overload;

implementation //############################################################### ■

uses System.Math,
     LUX,
     LUX.Quaternion,
     LUX.S3.Bary.Glerp;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBaryPowSlerp3S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TBaryPowSlerp3S.Center( const Ps_:TArray<TDoubleW3S> ) :TDouble3S;
var
   PsN, I :Integer;
   P :TDoubleW3S;
begin
     PsN := Length( Ps_ );

     P := Ps_[0];

     for I := 1 to PsN-1 do P := PowSlerp( P, Ps_[ I ] );

     Result := P.v;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PowSlerp

function PowSlerp( const Q0_,Q1_:TSingle3S; const T_:Single ) :TSingle3S;
begin
     Result := Q0_ * Pow( Q0_.Inv * Q1_, T_ );
end;

function PowSlerp( const Q0_,Q1_:TDouble3S; const T_:Double ) :TDouble3S;
begin
     Result := Q0_ * Pow( Q0_.Inv * Q1_, T_ );
end;

//------------------------------------------------------------------------------

function PowSlerp( const P1_,P2_:TSingleW3S ) :TSingleW3S;
var
   C :Single;
begin
     Result.w := P1_.w + P2_.w;

     if Abs( Result.w ) < SINGLE_EPS3 then Result.v := GLerp( P1_.v, P2_.v )
     else
     begin
          C := DotProduct( P1_.v, P2_.v );

          if 1-SINGLE_EPS3 < C then Result.v := GLerp( P1_.v, P2_.v, P1_.w, P2_.w )
                               else Result.v := PowSlerp( P1_.v, P2_.v, P2_.w / Result.w );
     end;
end;

function PowSlerp( const P1_,P2_:TDoubleW3S ) :TDoubleW3S;
var
   C :Double;
begin
     Result.w := P1_.w + P2_.w;

     if Abs( Result.w ) < DOUBLE_EPS3 then Result.v := GLerp( P1_.v, P2_.v )
     else
     begin
          C := DotProduct( P1_.v, P2_.v );

          if 1-DOUBLE_EPS3 < C then Result.v := GLerp( P1_.v, P2_.v, P1_.w, P2_.w )
                               else Result.v := PowSlerp( P1_.v, P2_.v, P2_.w / Result.w );
     end;
end;

end. //######################################################################### ■