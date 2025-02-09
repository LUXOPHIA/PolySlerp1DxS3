unit LUX.S3.Curve.PowSlerp;

// Slerp :Sherical Linear Interpolation

interface //#################################################################### ■

uses LUX,
     LUX.S3;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PowSlerp

function PowSlerp( const Q0_,Q1_:TSingle3S; const T_:Single ) :TSingle3S; overload;
function PowSlerp( const Q0_,Q1_:TDouble3S; const T_:Double ) :TDouble3S; overload;

function PowSlerp( const P1_,P2_:TSingleW3S ) :TSingleW3S; overload;
function PowSlerp( const P1_,P2_:TDoubleW3S ) :TDoubleW3S; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ChainPowSlerp

function ChainPowSlerp( const Ps_:TArray<TSingleW3S> ) :TSingleW3S; overload;
function ChainPowSlerp( const Ps_:TArray<TDoubleW3S> ) :TDoubleW3S; overload;

implementation //############################################################### ■

uses LUX.Quaternion,
     LUX.S3.Curve.Glerp;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PowSlerp

function PowSlerp( const Q0_,Q1_:TSingle3S; const T_:Single ) :TSingle3S;
var
   C :Single;
begin
     C := DotProduct( Q0_, Q1_ );

     if ( 1-SINGLE_EPS3 < Abs( C ) ) or ( Q0_.Siz2 < SINGLE_EPS3 ) or ( Q1_.Siz2 < SINGLE_EPS3 )
     then Result := GLerp( Q0_, Q1_, T_ )
     else Result := Q0_ * Pow( Q0_.Inv * Q1_, T_ );
end;

function PowSlerp( const Q0_,Q1_:TDouble3S; const T_:Double ) :TDouble3S;
var
   C :Double;
begin
     C := DotProduct( Q0_, Q1_ );

     if ( 1-DOUBLE_EPS3 < Abs( C ) ) or ( Q0_.Siz2 < DOUBLE_EPS3 ) or ( Q1_.Siz2 < DOUBLE_EPS3 )
     then Result := GLerp( Q0_, Q1_, T_ )
     else Result := Q0_ * Pow( Q0_.Inv * Q1_, T_ );
end;

//------------------------------------------------------------------------------

function PowSlerp( const P1_,P2_:TSingleW3S ) :TSingleW3S;
begin
     Result.w := P1_.w + P2_.w;

     if Abs( Result.w ) < SINGLE_EPS3
     then Result.v := 0
     else Result.v := PowSlerp( P1_.v, P2_.v, P2_.w / Result.w );
end;

function PowSlerp( const P1_,P2_:TDoubleW3S ) :TDoubleW3S;
begin
     Result.w := P1_.w + P2_.w;

     if Abs( Result.w ) < DOUBLE_EPS3
     then Result.v := 0
     else Result.v := PowSlerp( P1_.v, P2_.v, P2_.w / Result.w );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ChainPowSlerp

function ChainPowSlerp( const Ps_:TArray<TSingleW3S> ) :TSingleW3S;
var
   I :Integer;
begin
     Result := Ps_[0];

     for I := 1 to High( Ps_ ) do Result := PowSlerp( Result, Ps_[ I ] );
end;

function ChainPowSlerp( const Ps_:TArray<TDoubleW3S> ) :TDoubleW3S;
var
   I :Integer;
begin
     Result := Ps_[0];

     for I := 1 to High( Ps_ ) do Result := PowSlerp( Result, Ps_[ I ] );
end;

end. //######################################################################### ■