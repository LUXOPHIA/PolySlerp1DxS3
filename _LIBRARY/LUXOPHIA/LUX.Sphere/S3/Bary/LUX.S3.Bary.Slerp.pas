unit LUX.S3.Bary.Slerp;

// Slerp :Sherical Linear Interpolation

interface //#################################################################### ■

uses LUX.S3,
     LUX.S3.Bary;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBarySlerp3S

     TBarySlerp3S = class( TDoubleBary3S )
     private
     protected
     public
       ///// M E T H O D
       function Center( const Ps_:TArray<TDoubleW3S> ) :TDouble3S; override;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Slerp

function Slerp( const P1_,P2_:TSingle3S; const T_:Single ) :TSingle3S; overload;
function Slerp( const P1_,P2_:TDouble3S; const T_:Double ) :TDouble3S; overload;

function Slerp( const P1_,P2_:TSingle3S; const W1_,W2_:Single ) :TSingle3S; overload;
function Slerp( const P1_,P2_:TDouble3S; const W1_,W2_:Double ) :TDouble3S; overload;

function Slerp( const P1_,P2_:TSingleW3S ) :TSingleW3S; overload;
function Slerp( const P1_,P2_:TDoubleW3S ) :TDoubleW3S; overload;

implementation //############################################################### ■

uses System.Math,
     LUX,
     LUX.Quaternion,
     LUX.S3.Bary.Glerp;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBarySlerp3S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TBarySlerp3S.Center( const Ps_:TArray<TDoubleW3S> ) :TDouble3S;
var
   PsN, I :Integer;
   P :TDoubleW3S;
begin
     PsN := Length( Ps_ );

     P := Ps_[0];

     for I := 1 to PsN-1 do P := Slerp( P, Ps_[ I ] );

     Result := P.v;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Slerp

function Slerp( const P1_,P2_:TSingle3S; const T_:Single ) :TSingle3S;
var
   C, A, S :Single;
begin
     C := DotProduct( P1_, P2_ );

     if 1-SINGLE_EPS3 < C then Result := GLerp( P1_, P2_, T_ )
     else
     begin
          A := ArcCos( C );
          S := Sqrt( 1 - Sqr( C ) );  //= Sin( A )

          Result := ( Sin( ( 1 - T_ ) * A ) * P1_
                    + Sin( (     T_ ) * A ) * P2_ ) / S;
     end;
end;

function Slerp( const P1_,P2_:TDouble3S; const T_:Double ) :TDouble3S;
var
   C, A, S :Double;
begin
     C := DotProduct( P1_, P2_ );

     if 1-DOUBLE_EPS3 < C then Result := GLerp( P1_, P2_, T_ )
     else
     begin
          A := ArcCos( C );
          S := Sqrt( 1 - Sqr( C ) );  //= Sin( A )

          Result := ( Sin( ( 1 - T_ ) * A ) * P1_
                    + Sin( (     T_ ) * A ) * P2_ ) / S;
     end;
end;

//------------------------------------------------------------------------------

function Slerp( const P1_,P2_:TSingle3S; const W1_,W2_:Single ) :TSingle3S;
var
   W, C, A, S :Single;
begin
     W := W1_ + W2_;

     if Abs( W ) < SINGLE_EPS3 then Result := GLerp( P1_, P2_ )
     else
     begin
          C := DotProduct( P1_, P2_ );

          if 1-SINGLE_EPS3 < C then Result := GLerp( P1_, P2_, W1_, W2_ )
          else
          begin
               A := ArcCos( C ) / W;
               S := Sqrt( 1 - Sqr( C ) );  //= Sin( A )

               Result := ( Sin( A * W1_ ) * P1_
                         + Sin( A * W2_ ) * P2_ ) / S;
          end;
     end;
end;

function Slerp( const P1_,P2_:TDouble3S; const W1_,W2_:Double ) :TDouble3S;
var
   W, C, A, S :Double;
begin
     W := W1_ + W2_;

     if Abs( W ) < DOUBLE_EPS3 then Result := GLerp( P1_, P2_ )
     else
     begin
          C := DotProduct( P1_, P2_ );

          if 1-DOUBLE_EPS3 < C then Result := GLerp( P1_, P2_, W1_, W2_ )
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

function Slerp( const P1_,P2_:TSingleW3S ) :TSingleW3S;
var
   C, A, S :Single;
begin
     Result.w := P1_.w + P2_.w;

     if Abs( Result.w ) < SINGLE_EPS3 then Result.v := GLerp( P1_.v, P2_.v )
     else
     begin
          C := DotProduct( P1_.v, P2_.v );

          if 1-SINGLE_EPS3 < C then Result.v := GLerp( P1_.v, P2_.v, P1_.w, P2_.w )
          else
          begin
               A := ArcCos( C ) / Result.w;
               S := Sqrt( 1 - Sqr( C ) );  //= Sin( A )

               Result.v := ( Sin( A * P1_.w ) * P1_.v
                           + Sin( A * P2_.w ) * P2_.v ) / S;
          end;
     end;
end;

function Slerp( const P1_,P2_:TDoubleW3S ) :TDoubleW3S;
var
   C, A, S :Double;
begin
     Result.w := P1_.w + P2_.w;

     if Abs( Result.w ) < DOUBLE_EPS3 then Result.v := GLerp( P1_.v, P2_.v )
     else
     begin
          C := DotProduct( P1_.v, P2_.v );

          if 1-DOUBLE_EPS3 < C then Result.v := GLerp( P1_.v, P2_.v, P1_.w, P2_.w )
          else
          begin
               A := ArcCos( C ) / Result.w;
               S := Sqrt( 1 - Sqr( C ) );  //= Sin( A )

               Result.v := ( Sin( A * P1_.w ) * P1_.v
                           + Sin( A * P2_.w ) * P2_.v ) / S;
          end;
     end;
end;

end. //######################################################################### ■