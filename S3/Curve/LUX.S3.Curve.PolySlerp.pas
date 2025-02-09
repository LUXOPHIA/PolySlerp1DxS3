unit LUX.S3.Curve.PolySlerp;

// Slerp :Sherical Linear Interpolation

interface //#################################################################### ■

uses LUX,
     LUX.S3.Curve;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

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
     LUX.S3.Curve.Glerp;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

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