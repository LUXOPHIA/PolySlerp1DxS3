unit LUX.S3.Curve;

interface //#################################################################### ■

uses LUX,
     LUX.Curve,
     LUX.S3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     TSingleW3S = TSingleWector<TSingle3S>;
     TDoubleW3S = TDoubleWector<TDouble3S>;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleW3S

     HSingleW3S = record helper for TSingleW3S
     private
       ///// A C C E S S O R
       function GetUnitor :TSingleW3S;
     public
       ///// P R O P E R T Y
       property Unitor :TSingleW3S read GetUnitor;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleW3S

     HDoubleW3S = record helper for TDoubleW3S
     private
       ///// A C C E S S O R
       function GetUnitor :TDoubleW3S;
     public
       ///// P R O P E R T Y
       property Unitor :TDoubleW3S read GetUnitor;
     end;

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

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses LUX.S3.Curve.Slerp;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleW3S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function HSingleW3S.GetUnitor :TSingleW3S;
var
   L :Single;
begin
     L := v.Size;

     if L < SINGLE_EPS3 then Result := TSingleW3S.Create( 0, 0 )
                        else Result := TSingleW3S.Create( v / L, w );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleW3S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function HDoubleW3S.GetUnitor :TDoubleW3S;
var
   L :Double;
begin
     L := v.Size;

     if L < DOUBLE_EPS3 then Result := TDoubleW3S.Create( 0, 0 )
                        else Result := TDoubleW3S.Create( v / L, w );
end;

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

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■