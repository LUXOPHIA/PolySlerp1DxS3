unit LUX.S2.Curve;

interface //#################################################################### ■

uses LUX,
     LUX.Curve,
     LUX.S2;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     TSingleW2S = TSingleWector<TSingle2S>;
     TDoubleW2S = TDoubleWector<TDouble2S>;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleW2S

     HSingleW2S = record helper for TSingleW2S
     private
       ///// A C C E S S O R
       function GetUnitor :TSingleW2S;
     public
       ///// P R O P E R T Y
       property Unitor :TSingleW2S read GetUnitor;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleW2S

     HDoubleW2S = record helper for TDoubleW2S
     private
       ///// A C C E S S O R
       function GetUnitor :TDoubleW2S;
     public
       ///// P R O P E R T Y
       property Unitor :TDoubleW2S read GetUnitor;
     end;

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

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses LUX.S2.Curve.Slerp;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleW2S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function HSingleW2S.GetUnitor :TSingleW2S;
var
   L :Single;
begin
     L := v.Size;

     if Abs( L ) < SINGLE_EPS3 then Result := TSingleW2S.Create( 0, 0 )
                               else Result := TSingleW2S.Create( v / L, w );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleW2S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function HDoubleW2S.GetUnitor :TDoubleW2S;
var
   L :Double;
begin
     L := v.Size;

     if Abs( L ) < DOUBLE_EPS3 then Result := TDoubleW2S.Create( 0, 0 )
                               else Result := TDoubleW2S.Create( v / L, w );
end;

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

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■