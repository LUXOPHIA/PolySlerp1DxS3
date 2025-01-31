unit LUX.S3.Bary.PolySlerp;

// Slerp :Sherical Linear Interpolation

interface //#################################################################### ■

uses LUX,
     LUX.S3,
     LUX.S3.Bary;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle3Sw

     TSingle3Sw = record
     private
     public
       v :TSingle3S;
       w :Single;
       /////
       constructor Create( const V_:TSingle3S; const W_:Single );
       ///// O P E R A T O R
       class operator Positive( const P_:TSingle3Sw ) :TSingle3Sw;
       class operator Negative( const P_:TSingle3Sw ) :TSingle3Sw;
       class operator Add( const A_,B_:TSingle3Sw ) :TSingle3Sw;
       class operator Subtract( const A_,B_:TSingle3Sw ) :TSingle3Sw;
       class operator Multiply( const A_:Single; const B_:TSingle3Sw ) :TSingle3Sw;
       class operator Multiply( const A_:TSingle3Sw; const B_:Single ) :TSingle3Sw;
       class operator Divide( const A_:TSingle3Sw; const B_:Single ) :TSingle3Sw;
       ///// C A S T
       class operator Implicit( const S_:TSingleW3S ) :TSingle3Sw;
       class operator Explicit( const S_:TSingle3Sw ) :TSingleW3S;
       class operator Implicit( const V_:TSingle3S ) :TSingle3Sw;
       class operator Explicit( const S_:TSingle3Sw ) :TSingle3S;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble3Sw

     TDouble3Sw = record
     private
     public
       v :TDouble3S;
       w :Double;
       /////
       constructor Create( const V_:TDouble3S; const W_:Double );
       ///// O P E R A T O R
       class operator Positive( const P_:TDouble3Sw ) :TDouble3Sw;
       class operator Negative( const P_:TDouble3Sw ) :TDouble3Sw;
       class operator Add( const A_,B_:TDouble3Sw ) :TDouble3Sw;
       class operator Subtract( const A_,B_:TDouble3Sw ) :TDouble3Sw;
       class operator Multiply( const A_:Double; const B_:TDouble3Sw ) :TDouble3Sw;
       class operator Multiply( const A_:TDouble3Sw; const B_:Double ) :TDouble3Sw;
       class operator Divide( const A_:TDouble3Sw; const B_:Double ) :TDouble3Sw;
       ///// C A S T
       class operator Implicit( const S_:TDoubleW3S ) :TDouble3Sw;
       class operator Explicit( const S_:TDouble3Sw ) :TDoubleW3S;
       class operator Implicit( const V_:TDouble3S ) :TDouble3Sw;
       class operator Explicit( const S_:TDouble3Sw ) :TDouble3S;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBaryPolySlerp3S

     TBaryPolySlerp3S = class( TDoubleBary3S )
     private
     protected
     public
       ///// M E T H O D
       function Center( const Ps_:TArray<TDoubleW3S> ) :TDouble3S; override;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Glerp

function Glerp( const P1_,P2_:TSingle3Sw ) :TSingle3Sw; overload;
function Glerp( const P1_,P2_:TDouble3Sw ) :TDouble3Sw; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Slerp

function Slerp( const P1_,P2_:TSingle3Sw ) :TSingle3Sw; overload;
function Slerp( const P1_,P2_:TDouble3Sw ) :TDouble3Sw; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PolySlerp1D

function PolySlerp1D( Ps_:TArray<TSingle3Sw> ) :TSingle3Sw; overload;
function PolySlerp1D( Ps_:TArray<TDouble3Sw> ) :TDouble3Sw; overload;

implementation //############################################################### ■

uses System.Math,
     LUX.Quaternion,
     LUX.S3.Bary.Glerp;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle3Sw

constructor TSingle3Sw.Create( const V_:TSingle3S; const W_:Single );
begin
     v := V_;
     w := W_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TSingle3Sw.Positive( const P_:TSingle3Sw ) :TSingle3Sw;
begin
     Result.v :=  P_.v;
     Result.w := +P_.w;
end;

class operator TSingle3Sw.Negative( const P_:TSingle3Sw ) :TSingle3Sw;
begin
     Result.v :=  P_.v;
     Result.w := -P_.w;
end;

class operator TSingle3Sw.Add( const A_,B_:TSingle3Sw ) :TSingle3Sw;
begin
     Result := Slerp( A_, +B_ );
end;

class operator TSingle3Sw.Subtract( const A_,B_:TSingle3Sw ) :TSingle3Sw;
begin
     Result := Slerp( A_, -B_ );
end;

class operator TSingle3Sw.Multiply( const A_:Single; const B_:TSingle3Sw ) :TSingle3Sw;
begin
     Result.v :=      B_.v;
     Result.w := A_ * B_.w;
end;

class operator TSingle3Sw.Multiply( const A_:TSingle3Sw; const B_:Single ) :TSingle3Sw;
begin
     Result.v := A_.v     ;
     Result.w := A_.w * B_;
end;

class operator TSingle3Sw.Divide( const A_:TSingle3Sw; const B_:Single ) :TSingle3Sw;
begin
     Result.v := A_.v     ;
     Result.w := A_.w / B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TSingle3Sw.Implicit( const S_:TSingleW3S ) :TSingle3Sw;
begin
     Result.v := S_.v;
     Result.w := S_.w;
end;

class operator TSingle3Sw.Explicit( const S_:TSingle3Sw ) :TSingleW3S;
begin
     Result.v := S_.v;
     Result.w := S_.w;
end;

//------------------------------------------------------------------------------

class operator TSingle3Sw.Implicit( const V_:TSingle3S ) :TSingle3Sw;
begin
     Result.v := V_;
     Result.w := 1 ;
end;

class operator TSingle3Sw.Explicit( const S_:TSingle3Sw ) :TSingle3S;
begin
     Result := S_.v;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble3Sw

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDouble3Sw.Create( const V_:TDouble3S; const W_:Double );
begin
     v := V_;
     w := W_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TDouble3Sw.Positive( const P_:TDouble3Sw ) :TDouble3Sw;
begin
     Result.v :=  P_.v;
     Result.w := +P_.w;
end;

class operator TDouble3Sw.Negative( const P_:TDouble3Sw ) :TDouble3Sw;
begin
     Result.v :=  P_.v;
     Result.w := -P_.w;
end;

class operator TDouble3Sw.Add( const A_,B_:TDouble3Sw ) :TDouble3Sw;
begin
     Result := Slerp( A_, +B_ );
end;

class operator TDouble3Sw.Subtract( const A_,B_:TDouble3Sw ) :TDouble3Sw;
begin
     Result := Slerp( A_, -B_ );
end;

class operator TDouble3Sw.Multiply( const A_:Double; const B_:TDouble3Sw ) :TDouble3Sw;
begin
     Result.v :=      B_.v;
     Result.w := A_ * B_.w;
end;

class operator TDouble3Sw.Multiply( const A_:TDouble3Sw; const B_:Double ) :TDouble3Sw;
begin
     Result.v := A_.v     ;
     Result.w := A_.w * B_;
end;

class operator TDouble3Sw.Divide( const A_:TDouble3Sw; const B_:Double ) :TDouble3Sw;
begin
     Result.v := A_.v     ;
     Result.w := A_.w / B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TDouble3Sw.Implicit( const S_:TDoubleW3S ) :TDouble3Sw;
begin
     Result.v := S_.v;
     Result.w := S_.w;
end;

class operator TDouble3Sw.Explicit( const S_:TDouble3Sw ) :TDoubleW3S;
begin
     Result.v := S_.v;
     Result.w := S_.w;
end;

//------------------------------------------------------------------------------

class operator TDouble3Sw.Implicit( const V_:TDouble3S ) :TDouble3Sw;
begin
     Result.v := V_;
     Result.w := 1 ;
end;

class operator TDouble3Sw.Explicit( const S_:TDouble3Sw ) :TDouble3S;
begin
     Result := S_.v;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBaryPolySlerp3S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TBaryPolySlerp3S.Center( const Ps_:TArray<TDoubleW3S> ) :TDouble3S;
var
   PsN, I :Integer;
   Ps :TArray<TDouble3Sw>;
begin
     PsN := Length( Ps_ );
     SetLength( Ps, PsN );
     for I := 0 to PsN-1 do Ps[ I ] := Ps_[ I ];

     Result := PolySlerp1D( Ps ).v;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Glerp

function Glerp( const P1_,P2_:TSingle3Sw ) :TSingle3Sw;
begin
     Result.v := Glerp( P1_.v, P2_.v, P1_.w, P2_.w );
     Result.w := P1_.w + P2_.w;
end;

function Glerp( const P1_,P2_:TDouble3Sw ) :TDouble3Sw;
begin
     Result.v := Glerp( P1_.v, P2_.v, P1_.w, P2_.w );
     Result.w := P1_.w + P2_.w;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Slerp

function Slerp( const P1_,P2_:TSingle3Sw ) :TSingle3Sw;
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

function Slerp( const P1_,P2_:TDouble3Sw ) :TDouble3Sw;
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

function PolySlerp1D( Ps_:TArray<TSingle3Sw> ) :TSingle3Sw;
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

function PolySlerp1D( Ps_:TArray<TDouble3Sw> ) :TDouble3Sw;
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