unit LUX.S2;

interface //#################################################################### ■

uses LUX.D3,
     LIB;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     TSingle2S = TSingle3D;
     TDouble2S = TDouble3D;

     TSingleWector2S = TSingleWector<TSingle2S>;
     TDoubleWector2S = TDoubleWector<TDouble2S>;

     TSingleBary2S = TBarycenter<TSingle2S>;
     TDoubleBary2S = TBarycenter<TDouble2S>;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle2Sw

     TSingle2Sw = record
     private
     public
       v :TSingle2S;
       w :Single;
       /////
       constructor Create( const P_:TSingle2S; const W_:Single );
       ///// O P E R A T O R
       class operator Positive( const P_:TSingle2Sw ) :TSingle2Sw;
       class operator Negative( const P_:TSingle2Sw ) :TSingle2Sw;
       class operator Add( const A_,B_:TSingle2Sw ) :TSingle2Sw;
       class operator Subtract( const A_,B_:TSingle2Sw ) :TSingle2Sw;
       class operator Multiply( const A_:Single; const B_:TSingle2Sw ) :TSingle2Sw;
       class operator Multiply( const A_:TSingle2Sw; const B_:Single ) :TSingle2Sw;
       class operator Divide( const A_:TSingle2Sw; const B_:Single ) :TSingle2Sw;
       ///// C A S T
       class operator Implicit( const S_:TSingleWector2S ) :TSingle2Sw;
       class operator Explicit( const S_:TSingle2Sw ) :TSingleWector2S;
       class operator Implicit( const V_:TSingle2S ) :TSingle2Sw;
       class operator Explicit( const S_:TSingle2Sw ) :TSingle2S;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble2Sw

     TDouble2Sw = record
     private
     public
       v :TDouble2S;
       w :Double;
       /////
       constructor Create( const P_:TDouble2S; const W_:Double );
       ///// O P E R A T O R
       class operator Positive( const P_:TDouble2Sw ) :TDouble2Sw;
       class operator Negative( const P_:TDouble2Sw ) :TDouble2Sw;
       class operator Add( const A_,B_:TDouble2Sw ) :TDouble2Sw;
       class operator Subtract( const A_,B_:TDouble2Sw ) :TDouble2Sw;
       class operator Multiply( const A_:Double; const B_:TDouble2Sw ) :TDouble2Sw;
       class operator Multiply( const A_:TDouble2Sw; const B_:Double ) :TDouble2Sw;
       class operator Divide( const A_:TDouble2Sw; const B_:Double ) :TDouble2Sw;
       ///// C A S T
       class operator Implicit( const S_:TDoubleWector2S ) :TDouble2Sw;
       class operator Explicit( const S_:TDouble2Sw ) :TDoubleWector2S;
       class operator Implicit( const V_:TDouble2S ) :TDouble2Sw;
       class operator Explicit( const S_:TDouble2Sw ) :TDouble2S;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBaryGLerp2S

     TBaryGLerp2S = class( TDoubleBary2S )
     private
     protected
     public
       ///// M E T H O D
       function Center( const Ps_:TArray<TDoubleWector2S> ) :TDouble2S; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBaryPolySlerp2S

     TBaryPolySlerp2S = class( TDoubleBary2S )
     private
     protected
     public
       ///// M E T H O D
       function Center( const Ps_:TArray<TDoubleWector2S> ) :TDouble2S; override;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Glerp :Gnomonic Linear Interpolation

function Glerp( const P1_,P2_:TSingle2S ) :TSingle2S; overload;
function Glerp( const P1_,P2_:TDouble2S ) :TDouble2S; overload;

function Glerp( const P1_,P2_:TSingle2S; const T_:Single ) :TSingle2S; overload;
function Glerp( const P1_,P2_:TDouble2S; const T_:Double ) :TDouble2S; overload;

function Glerp( const P1_,P2_:TSingle2S; const W1_,W2_:Single ) :TSingle2S; overload;
function Glerp( const P1_,P2_:TDouble2S; const W1_,W2_:Double ) :TDouble2S; overload;

function Glerp( const P1_,P2_:TSingle2Sw ) :TSingle2Sw; overload;
function Glerp( const P1_,P2_:TDouble2Sw ) :TDouble2Sw; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Slerp :Sherical Linear Interpolation

function Slerp( const P1_,P2_:TSingle2S; const T_:Single ) :TSingle2S; overload;
function Slerp( const P1_,P2_:TDouble2S; const T_:Double ) :TDouble2S; overload;

function Slerp( const P1_,P2_:TSingle2S; const W1_,W2_:Single ) :TSingle2S; overload;
function Slerp( const P1_,P2_:TDouble2S; const W1_,W2_:Double ) :TDouble2S; overload;

function Slerp( const P1_,P2_:TSingle2Sw ) :TSingle2Sw; overload;
function Slerp( const P1_,P2_:TDouble2Sw ) :TDouble2Sw; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sum1D

function Sum1D( Ps_:TArray<TSingle2Sw> ) :TSingle2Sw; overload;
function Sum1D( Ps_:TArray<TDouble2Sw> ) :TDouble2Sw; overload;

implementation //############################################################### ■

uses System.Math,
     LUX,
     LIB.D3;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle2Sw

constructor TSingle2Sw.Create( const P_:TSingle2S; const W_:Single );
begin
     v := P_;
     w := W_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TSingle2Sw.Positive( const P_:TSingle2Sw ) :TSingle2Sw;
begin
     Result.v :=  P_.v;
     Result.w := +P_.w;
end;

class operator TSingle2Sw.Negative( const P_:TSingle2Sw ) :TSingle2Sw;
begin
     Result.v :=  P_.v;
     Result.w := -P_.w;
end;

class operator TSingle2Sw.Add( const A_,B_:TSingle2Sw ) :TSingle2Sw;
begin
     Result := Slerp( A_, +B_ );
end;

class operator TSingle2Sw.Subtract( const A_,B_:TSingle2Sw ) :TSingle2Sw;
begin
     Result := Slerp( A_, -B_ );
end;

class operator TSingle2Sw.Multiply( const A_:Single; const B_:TSingle2Sw ) :TSingle2Sw;
begin
     Result.v :=      B_.v;
     Result.w := A_ * B_.w;
end;

class operator TSingle2Sw.Multiply( const A_:TSingle2Sw; const B_:Single ) :TSingle2Sw;
begin
     Result.v := A_.v     ;
     Result.w := A_.w * B_;
end;

class operator TSingle2Sw.Divide( const A_:TSingle2Sw; const B_:Single ) :TSingle2Sw;
begin
     Result.v := A_.v     ;
     Result.w := A_.w / B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TSingle2Sw.Implicit( const S_:TSingleWector2S ) :TSingle2Sw;
begin
     Result.v := S_.v;
     Result.w := S_.w;
end;

class operator TSingle2Sw.Explicit( const S_:TSingle2Sw ) :TSingleWector2S;
begin
     Result.v := S_.v;
     Result.w := S_.w;
end;

//------------------------------------------------------------------------------

class operator TSingle2Sw.Implicit( const V_:TSingle2S ) :TSingle2Sw;
begin
     Result.v := V_;
     Result.w := 1 ;
end;

class operator TSingle2Sw.Explicit( const S_:TSingle2Sw ) :TSingle2S;
begin
     Result := S_.v;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble2Sw

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDouble2Sw.Create( const P_:TDouble2S; const W_:Double );
begin
     v := P_;
     w := W_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TDouble2Sw.Positive( const P_:TDouble2Sw ) :TDouble2Sw;
begin
     Result.v :=  P_.v;
     Result.w := +P_.w;
end;

class operator TDouble2Sw.Negative( const P_:TDouble2Sw ) :TDouble2Sw;
begin
     Result.v :=  P_.v;
     Result.w := -P_.w;
end;

class operator TDouble2Sw.Add( const A_,B_:TDouble2Sw ) :TDouble2Sw;
begin
     Result := Slerp( A_, +B_ );
end;

class operator TDouble2Sw.Subtract( const A_,B_:TDouble2Sw ) :TDouble2Sw;
begin
     Result := Slerp( A_, -B_ );
end;

class operator TDouble2Sw.Multiply( const A_:Double; const B_:TDouble2Sw ) :TDouble2Sw;
begin
     Result.v :=      B_.v;
     Result.w := A_ * B_.w;
end;

class operator TDouble2Sw.Multiply( const A_:TDouble2Sw; const B_:Double ) :TDouble2Sw;
begin
     Result.v := A_.v     ;
     Result.w := A_.w * B_;
end;

class operator TDouble2Sw.Divide( const A_:TDouble2Sw; const B_:Double ) :TDouble2Sw;
begin
     Result.v := A_.v     ;
     Result.w := A_.w / B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TDouble2Sw.Implicit( const S_:TDoubleWector2S ) :TDouble2Sw;
begin
     Result.v := S_.v;
     Result.w := S_.w;
end;

class operator TDouble2Sw.Explicit( const S_:TDouble2Sw ) :TDoubleWector2S;
begin
     Result.v := S_.v;
     Result.w := S_.w;
end;

//------------------------------------------------------------------------------

class operator TDouble2Sw.Implicit( const V_:TDouble2S ) :TDouble2Sw;
begin
     Result.v := V_;
     Result.w := 1 ;
end;

class operator TDouble2Sw.Explicit( const S_:TDouble2Sw ) :TDouble2S;
begin
     Result := S_.v;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBaryGLerp2S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TBaryGLerp2S.Center( const Ps_:TArray<TDoubleWector2S> ) :TDouble2S;
var
   P :TDoubleWector2S;
begin
     Result := 0;

     for P in Ps_ do Result := Result + P.w * P.v;

     Result := Result.Unitor;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBaryPolySlerp2S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TBaryPolySlerp2S.Center( const Ps_:TArray<TDoubleWector2S> ) :TDouble2S;
var
   PsN, I :Integer;
   Ps :TArray<TDouble2Sw>;
begin
     PsN := Length( Ps_ );

     SetLength( Ps, PsN );

     for I := 0 to PsN-1 do Ps[ I ] := Ps_[ I ];

     Result := TDouble2S( Sum1D( Ps ) );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SlerpG

function Glerp( const P1_,P2_:TSingle2S ) :TSingle2S;
begin
     Result := Lerp( P1_, P2_ ).Unitor;
end;

function Glerp( const P1_,P2_:TDouble2S ) :TDouble2S;
begin
     Result := Lerp( P1_, P2_ ).Unitor;
end;

//------------------------------------------------------------------------------

function Glerp( const P1_,P2_:TSingle2S; const T_:Single ) :TSingle2S;
begin
     Result := Lerp( P1_, P2_, T_ ).Unitor;
end;

function Glerp( const P1_,P2_:TDouble2S; const T_:Double ) :TDouble2S;
begin
     Result := Lerp( P1_, P2_, T_ ).Unitor;
end;

//------------------------------------------------------------------------------

function Glerp( const P1_,P2_:TSingle2S; const W1_,W2_:Single ) :TSingle2S;
begin
     Result := Lerp( P1_, P2_, W1_, W2_ ).Unitor;
end;

function Glerp( const P1_,P2_:TDouble2S; const W1_,W2_:Double ) :TDouble2S;
begin
     Result := Lerp( P1_, P2_, W1_, W2_ ).Unitor;
end;

//------------------------------------------------------------------------------

function Glerp( const P1_,P2_:TSingle2Sw ) :TSingle2Sw;
begin
     Result.v := Lerp( P1_.v, P2_.v, P1_.w, P2_.w ).Unitor;
     Result.w := P1_.w + P2_.w;
end;

function Glerp( const P1_,P2_:TDouble2Sw ) :TDouble2Sw;
begin
     Result.v := Lerp( P1_.v, P2_.v, P1_.w, P2_.w ).Unitor;
     Result.w := P1_.w + P2_.w;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Slerp

function Slerp( const P1_,P2_:TSingle2S; const T_:Single ) :TSingle2S;
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

function Slerp( const P1_,P2_:TDouble2S; const T_:Double ) :TDouble2S;
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

function Slerp( const P1_,P2_:TSingle2S; const W1_,W2_:Single ) :TSingle2S;
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

function Slerp( const P1_,P2_:TDouble2S; const W1_,W2_:Double ) :TDouble2S;
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

function Slerp( const P1_,P2_:TSingle2Sw ) :TSingle2Sw;
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

function Slerp( const P1_,P2_:TDouble2Sw ) :TDouble2Sw;
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

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sum1D

function Sum1D( Ps_:TArray<TSingle2Sw> ) :TSingle2Sw;
var
   N, I, L :Integer;
begin
     N := High( Ps_ );

     for I := 0 to N do Ps_[ I ] := Ps_[ I ] / Binomial( N, I );

     for L := N-1 downto 0 do
     for I := 0 to L do Ps_[ I ] := Ps_[ I ] + Ps_[ I+1 ];

     Result := Ps_[ 0 ];
end;

function Sum1D( Ps_:TArray<TDouble2Sw> ) :TDouble2Sw;
var
   N, I, L :Integer;
begin
     N := High( Ps_ );

     for I := 0 to N do Ps_[ I ] := Ps_[ I ] / Binomial( N, I );

     for L := N-1 downto 0 do
     for I := 0 to L do Ps_[ I ] := Ps_[ I ] + Ps_[ I+1 ];

     Result := Ps_[ 0 ];
end;

end. //######################################################################### ■