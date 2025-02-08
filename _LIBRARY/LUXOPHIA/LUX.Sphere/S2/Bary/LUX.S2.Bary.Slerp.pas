unit LUX.S2.Bary.Slerp;

// Slerp :Sherical Linear Interpolation

interface //#################################################################### ■

uses LUX.S2,
     LUX.S2.Bary;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBarySlerp2S

     TBarySlerp2S = class( TDoubleBary2S )
     private
     protected
     public
       ///// M E T H O D
       function Center( const Ps_:TArray<TDoubleW2S> ) :TDouble2S; override;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Slerp

function Slerp( const P1_,P2_:TSingle2S; const T_:Single ) :TSingle2S; overload;
function Slerp( const P1_,P2_:TDouble2S; const T_:Double ) :TDouble2S; overload;

function Slerp( const P1_,P2_:TSingle2S; const W1_,W2_:Single ) :TSingle2S; overload;
function Slerp( const P1_,P2_:TDouble2S; const W1_,W2_:Double ) :TDouble2S; overload;

function Slerp( const P1_,P2_:TSingleW2S ) :TSingleW2S; overload;
function Slerp( const P1_,P2_:TDoubleW2S ) :TDoubleW2S; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ChainSlerp

function ChainSlerp( const Ps_:TArray<TSingleW2S> ) :TSingleW2S; overload;
function ChainSlerp( const Ps_:TArray<TDoubleW2S> ) :TDoubleW2S; overload;

implementation //############################################################### ■

uses System.Math,
     LUX,
     LUX.D3,
     LUX.Curve,
     LUX.S2.Bary.Glerp;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBarySlerp2S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TBarySlerp2S.Center( const Ps_:TArray<TDoubleW2S> ) :TDouble2S;
begin
     Result := ChainSlerp( Ps_ ).v;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Slerp

function Slerp( const P1_,P2_:TSingle2S; const T_:Single ) :TSingle2S;
var
   C, A, S :Single;
begin
     C := DotProduct( P1_, P2_ );

     if 1-SINGLE_EPS3 < Abs( C ) then Result := GLerp( P1_, P2_, T_ )
     else
     begin
          A := ArcCos( C );
          S := Sqrt( 1 - Sqr( C ) );  //= Sin( A )

          Result := ( Sin( ( 1 - T_ ) * A ) * P1_
                    + Sin( (     T_ ) * A ) * P2_ ) / S;
     end;
end;

function Slerp( const P1_,P2_:TDouble2S; const T_:Double ) :TDouble2S;
var
   C, A, S :Double;
begin
     C := DotProduct( P1_, P2_ );

     if 1-DOUBLE_EPS3 < Abs( C ) then Result := GLerp( P1_, P2_, T_ )
     else
     begin
          A := ArcCos( C );
          S := Sqrt( 1 - Sqr( C ) );  //= Sin( A )

          Result := ( Sin( ( 1 - T_ ) * A ) * P1_
                    + Sin( (     T_ ) * A ) * P2_ ) / S;
     end;
end;

//------------------------------------------------------------------------------

function Slerp( const P1_,P2_:TSingle2S; const W1_,W2_:Single ) :TSingle2S;
var
   W, C, A, S :Single;
begin
     C := DotProduct( P1_, P2_ );

     if 1-SINGLE_EPS3 < Abs( C ) then Result := GLerp( P1_, P2_, W1_, W2_ )
     else
     begin
          W := W1_ + W2_;

          if Abs( W ) < SINGLE_EPS3 then Result := 0
          else
          begin
               A := ArcCos( C ) / W;
               S := Sqrt( 1 - Sqr( C ) );  //= Sin( A )

               Result := ( Sin( A * W1_ ) * P1_
                         + Sin( A * W2_ ) * P2_ ) / S;
          end;
     end;
end;

function Slerp( const P1_,P2_:TDouble2S; const W1_,W2_:Double ) :TDouble2S;
var
   W, C, A, S :Double;
begin
     C := DotProduct( P1_, P2_ );

     if 1-DOUBLE_EPS3 < Abs( C ) then Result := GLerp( P1_, P2_, W1_, W2_ )
     else
     begin
          W := W1_ + W2_;

          if Abs( W ) < DOUBLE_EPS3 then Result := 0
          else
          begin
               A := ArcCos( C ) / W;
               S := Sqrt( 1 - Sqr( C ) );  //= Sin( A )

               Result := ( Sin( A * W1_ ) * P1_
                         + Sin( A * W2_ ) * P2_ ) / S;
          end;
     end;
end;

//------------------------------------------------------------------------------

function Slerp( const P1_,P2_:TSingleW2S ) :TSingleW2S;
var
   C, A, S :Single;
begin
     C := DotProduct( P1_.v, P2_.v );

     if 1-SINGLE_EPS3 < Abs( C ) then Result := GLerp( P1_, P2_ )
     else
     begin
          Result.w := P1_.w + P2_.w;

          if Abs( Result.w ) < SINGLE_EPS3 then Result.v := 0
          else
          begin
               A := ArcCos( C ) / Result.w;
               S := Sqrt( 1 - Sqr( C ) );  //= Sin( A )

               Result.v := ( Sin( A * P1_.w ) * P1_.v
                           + Sin( A * P2_.w ) * P2_.v ) / S;
          end;
     end;
end;

function Slerp( const P1_,P2_:TDoubleW2S ) :TDoubleW2S;
var
   C, A, S :Double;
begin
     C := DotProduct( P1_.v, P2_.v );

     if 1-DOUBLE_EPS3 < Abs( C ) then Result := GLerp( P1_, P2_ )
     else
     begin
          Result.w := P1_.w + P2_.w;

          if Abs( Result.w ) < DOUBLE_EPS3 then Result.v := 0
          else
          begin
               A := ArcCos( C ) / Result.w;
               S := Sqrt( 1 - Sqr( C ) );  //= Sin( A )

               Result.v := ( Sin( A * P1_.w ) * P1_.v
                           + Sin( A * P2_.w ) * P2_.v ) / S;
          end;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ChainSlerp

function ChainSlerp( const Ps_:TArray<TSingleW2S> ) :TSingleW2S;
var
   I :Integer;
begin
     Result := Ps_[0];

     for I := 1 to High( Ps_ ) do Result := Slerp( Result, Ps_[ I ] );
end;

function ChainSlerp( const Ps_:TArray<TDoubleW2S> ) :TDoubleW2S;
var
   I :Integer;
begin
     Result := Ps_[0];

     for I := 1 to High( Ps_ ) do Result := Slerp( Result, Ps_[ I ] );
end;

end. //######################################################################### ■