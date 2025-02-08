unit LUX.S2.Bary.PolySlerp;

// Slerp :Sherical Linear Interpolation

interface //#################################################################### ■

uses LUX,
     LUX.S2,
     LUX.S2.Bary;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle2Sw

     TSingle2Sw = record
     private
     public
       v :TSingle2S;
       w :Single;
       /////
       constructor Create( const V_:TSingle2S; const W_:Single );
       ///// O P E R A T O R
       class operator Positive( const P_:TSingle2Sw ) :TSingle2Sw;
       class operator Negative( const P_:TSingle2Sw ) :TSingle2Sw;
       class operator Add( const A_,B_:TSingle2Sw ) :TSingle2Sw;
       class operator Subtract( const A_,B_:TSingle2Sw ) :TSingle2Sw;
       class operator Multiply( const A_:Single; const B_:TSingle2Sw ) :TSingle2Sw;
       class operator Multiply( const A_:TSingle2Sw; const B_:Single ) :TSingle2Sw;
       class operator Divide( const A_:TSingle2Sw; const B_:Single ) :TSingle2Sw;
       ///// C A S T
       class operator Implicit( const S_:TSingleW2S ) :TSingle2Sw;
       class operator Explicit( const S_:TSingle2Sw ) :TSingleW2S;
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
       constructor Create( const V_:TDouble2S; const W_:Double );
       ///// O P E R A T O R
       class operator Positive( const P_:TDouble2Sw ) :TDouble2Sw;
       class operator Negative( const P_:TDouble2Sw ) :TDouble2Sw;
       class operator Add( const A_,B_:TDouble2Sw ) :TDouble2Sw;
       class operator Subtract( const A_,B_:TDouble2Sw ) :TDouble2Sw;
       class operator Multiply( const A_:Double; const B_:TDouble2Sw ) :TDouble2Sw;
       class operator Multiply( const A_:TDouble2Sw; const B_:Double ) :TDouble2Sw;
       class operator Divide( const A_:TDouble2Sw; const B_:Double ) :TDouble2Sw;
       ///// C A S T
       class operator Implicit( const S_:TDoubleW2S ) :TDouble2Sw;
       class operator Explicit( const S_:TDouble2Sw ) :TDoubleW2S;
       class operator Implicit( const V_:TDouble2S ) :TDouble2Sw;
       class operator Explicit( const S_:TDouble2Sw ) :TDouble2S;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBaryPolySlerp2S

     TBaryPolySlerp2S = class( TDoubleBary2S )
     private
     protected
     public
       ///// M E T H O D
       function Center( const Ps_:TArray<TDoubleW2S> ) :TDouble2S; override;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Glerp

function Glerp( const P1_,P2_:TSingle2Sw ) :TSingle2Sw; overload;
function Glerp( const P1_,P2_:TDouble2Sw ) :TDouble2Sw; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Slerp

function Slerp( const P1_,P2_:TSingle2Sw ) :TSingle2Sw; overload;
function Slerp( const P1_,P2_:TDouble2Sw ) :TDouble2Sw; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PolySlerp1D

function PolySlerp1D( Ps_:TArray<TSingle2Sw> ) :TSingle2Sw; overload;
function PolySlerp1D( Ps_:TArray<TDouble2Sw> ) :TDouble2Sw; overload;

implementation //############################################################### ■

uses System.Math,
     LUX.D3,
     LUX.Curve,
     LUX.S2.Bary.Glerp;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle2Sw

constructor TSingle2Sw.Create( const V_:TSingle2S; const W_:Single );
begin
     v := V_;
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

class operator TSingle2Sw.Implicit( const S_:TSingleW2S ) :TSingle2Sw;
begin
     Result.v := S_.v;
     Result.w := S_.w;
end;

class operator TSingle2Sw.Explicit( const S_:TSingle2Sw ) :TSingleW2S;
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

constructor TDouble2Sw.Create( const V_:TDouble2S; const W_:Double );
begin
     v := V_;
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

class operator TDouble2Sw.Implicit( const S_:TDoubleW2S ) :TDouble2Sw;
begin
     Result.v := S_.v;
     Result.w := S_.w;
end;

class operator TDouble2Sw.Explicit( const S_:TDouble2Sw ) :TDoubleW2S;
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

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBaryPolySlerp2S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TBaryPolySlerp2S.Center( const Ps_:TArray<TDoubleW2S> ) :TDouble2S;
var
   PsN, I :Integer;
   Ps :TArray<TDouble2Sw>;
begin
     PsN := Length( Ps_ );
     SetLength( Ps, PsN );
     for I := 0 to PsN-1 do Ps[ I ] := Ps_[ I ];

     Result := PolySlerp1D( Ps ).v;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Glerp

function Glerp( const P1_,P2_:TSingle2Sw ) :TSingle2Sw;
begin
     Result.v := Glerp( P1_.v, P2_.v, P1_.w, P2_.w );
     Result.w := P1_.w + P2_.w;
end;

function Glerp( const P1_,P2_:TDouble2Sw ) :TDouble2Sw;
begin
     Result.v := Glerp( P1_.v, P2_.v, P1_.w, P2_.w );
     Result.w := P1_.w + P2_.w;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Slerp

function Slerp( const P1_,P2_:TSingle2Sw ) :TSingle2Sw;
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

function Slerp( const P1_,P2_:TDouble2Sw ) :TDouble2Sw;
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

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PolySlerp1D

//  4A /1-+
//        |- 4A+2B /1-+
//  4B /2-+           |- 4A+3B+1C /1-+
//        |- 2B+2C /2-+              |- 4A+4B+4C+4D
//  4C /2-+           |- 1B+3C+4D /1-+
//        |- 2C+4D /1-+
//  4D /1-+

function PolySlerp1D( Ps_:TArray<TSingle2Sw> ) :TSingle2Sw;
var
   N, L, I :Integer;
begin
     N := High( Ps_ );

     for L := N-1 downto 0 do
     begin
           for I := 1 to L do Ps_[ I ] := Ps_[ I ] / 2;

           for I := 0 to L do Ps_[ I ] := Ps_[ I ] + Ps_[ I+1 ];
     end;

     Result := Ps_[ 0 ];
end;

function PolySlerp1D( Ps_:TArray<TDouble2Sw> ) :TDouble2Sw;
var
   N, L, I :Integer;
begin
     N := High( Ps_ );

     for L := N-1 downto 0 do
     begin
           for I := 1 to L do Ps_[ I ] := Ps_[ I ] / 2;

           for I := 0 to L do Ps_[ I ] := Ps_[ I ] + Ps_[ I+1 ];
     end;

     Result := Ps_[ 0 ];
end;

end. //######################################################################### ■