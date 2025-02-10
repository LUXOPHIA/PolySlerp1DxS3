unit LUX.S2.Curve.Lerp;

// Glerp :Gnomonic Linear Interpolation

interface //#################################################################### ■

uses LUX,
     LUX.S2,
     LUX.S2.Curve;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Lerp

function Lerp( const P1_,P2_:TSingle2S ) :TSingle2S; overload;
function Lerp( const P1_,P2_:TDouble2S ) :TDouble2S; overload;

function Lerp( const P1_,P2_,P3_:TSingle2S ) :TSingle2S; overload;
function Lerp( const P1_,P2_,P3_:TDouble2S ) :TDouble2S; overload;

function Lerp( const P1_,P2_:TSingle2S; const T_:Single ) :TSingle2S; overload;
function Lerp( const P1_,P2_:TDouble2S; const T_:Double ) :TDouble2S; overload;

function Lerp( const P1_,P2_:TSingle2S; const W1_,W2_:Single ) :TSingle2S; overload;
function Lerp( const P1_,P2_:TDouble2S; const W1_,W2_:Double ) :TDouble2S; overload;

function Lerp( const P1_,P2_,P3_:TSingle2S; const W1_,W2_,W3_:Single ) :TSingle2S; overload;
function Lerp( const P1_,P2_,P3_:TDouble2S; const W1_,W2_,W3_:Double ) :TDouble2S; overload;

function Lerp( const P1_,P2_:TSingleW2S ) :TSingleW2S; overload;
function Lerp( const P1_,P2_:TDoubleW2S ) :TDoubleW2S; overload;

function Lerp( const P1_,P2_,P3_:TSingle2Sw ) :TSingle2Sw; overload;
function Lerp( const P1_,P2_,P3_:TDouble2Sw ) :TDouble2Sw; overload;

function Lerp( const Ps_:TArray<TSingle2S> ) :TSingle2S; overload;
function Lerp( const Ps_:TArray<TDouble2S> ) :TDouble2S; overload;

function Lerp( const Ps_:TArray<TSingleW2S> ) :TSingleW2S; overload;
function Lerp( const Ps_:TArray<TDoubleW2S> ) :TDoubleW2S; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Lerp

function Lerp( const P1_,P2_:TSingle2S ) :TSingle2S;
begin
     Result := ( P1_ + P2_ ) / 2;
end;

function Lerp( const P1_,P2_:TDouble2S ) :TDouble2S;
begin
     Result := ( P1_ + P2_ ) / 2;
end;

//------------------------------------------------------------------------------

function Lerp( const P1_,P2_,P3_:TSingle2S ) :TSingle2S;
begin
     Result := ( P1_ + P2_ + P3_ ) / 3;
end;

function Lerp( const P1_,P2_,P3_:TDouble2S ) :TDouble2S;
begin
     Result := ( P1_ + P2_ + P3_ ) / 3;
end;

//------------------------------------------------------------------------------

function Lerp( const P1_,P2_:TSingle2S; const T_:Single ) :TSingle2S;
begin
     Result := ( P2_ - P1_ ) * T_ + P1_;
end;

function Lerp( const P1_,P2_:TDouble2S; const T_:Double ) :TDouble2S;
begin
     Result := ( P2_ - P1_ ) * T_ + P1_;
end;

//------------------------------------------------------------------------------

function Lerp( const P1_,P2_:TSingle2S; const W1_,W2_:Single ) :TSingle2S;
begin
     Result := ( W1_ * P1_ + W2_ * P2_ ) / ( W1_ + W2_ );
end;

function Lerp( const P1_,P2_:TDouble2S; const W1_,W2_:Double ) :TDouble2S;
begin
     Result := ( W1_ * P1_ + W2_ * P2_ ) / ( W1_ + W2_ );
end;

//------------------------------------------------------------------------------

function Lerp( const P1_,P2_,P3_:TSingle2S; const W1_,W2_,W3_:Single ) :TSingle2S;
begin
     Result := ( W1_ * P1_ + W2_ * P2_ + W3_ * P3_ ) / ( W1_ + W2_ + W3_ );
end;

function Lerp( const P1_,P2_,P3_:TDouble2S; const W1_,W2_,W3_:Double ) :TDouble2S;
begin
     Result := ( W1_ * P1_ + W2_ * P2_ + W3_ * P3_ ) / ( W1_ + W2_ + W3_ );
end;

//------------------------------------------------------------------------------

function Lerp( const P1_,P2_:TSingleW2S ) :TSingleW2S;
begin
     Result.w := P1_.w + P2_.w;
     Result.v := ( P1_.w * P1_.v + P2_.w * P2_.v ) / Result.w;
end;

function Lerp( const P1_,P2_:TDoubleW2S ) :TDoubleW2S;
begin
     Result.w := P1_.w + P2_.w;
     Result.v := ( P1_.w * P1_.v + P2_.w * P2_.v ) / Result.w;
end;

//------------------------------------------------------------------------------

function Lerp( const P1_,P2_,P3_:TSingle2Sw ) :TSingle2Sw;
begin
     Result.w := P1_.w + P2_.w + P3_.w;
     Result.v := ( P1_.w * P1_.v + P2_.w * P2_.v + P3_.w * P3_.v ) / Result.w;
end;

function Lerp( const P1_,P2_,P3_:TDouble2Sw ) :TDouble2Sw;
begin
     Result.w := P1_.w + P2_.w + P3_.w;
     Result.v := ( P1_.w * P1_.v + P2_.w * P2_.v + P3_.w * P3_.v ) / Result.w;
end;

//------------------------------------------------------------------------------

function Lerp( const Ps_:TArray<TSingle2S> ) :TSingle2S;
var
   P :TSingle2S;
begin
     Result := 0;

     for P in Ps_ do Result := Result + P;

     Result := Result / Length( Ps_ );
end;

function Lerp( const Ps_:TArray<TDouble2S> ) :TDouble2S;
var
   P :TDouble2S;
begin
     Result := 0;

     for P in Ps_ do Result := Result + P;

     Result := Result / Length( Ps_ );
end;

//------------------------------------------------------------------------------

function Lerp( const Ps_:TArray<TSingleW2S> ) :TSingleW2S;
var
   P :TSingleW2S;
begin
     Result := TSingleW2S.Create( 0, 0 );

     for P in Ps_ do Result.w := Result.w + P.w;

     if Abs( Result.w ) < SINGLE_EPS3 then
     begin
          for P in Ps_ do Result.v := Result.v + P.v;

          Result.v := Result.v / Length( Ps_ );
     end
     else
     begin
          for P in Ps_ do Result.v := Result.v + P.w * P.v;

          Result.v := Result.v / Result.w;
     end;
end;

function Lerp( const Ps_:TArray<TDoubleW2S> ) :TDoubleW2S;
var
   P :TDoubleW2S;
begin
     Result := TDoubleW2S.Create( 0, 0 );

     for P in Ps_ do Result.w := Result.w + P.w;

     if Abs( Result.w ) < DOUBLE_EPS3 then
     begin
          for P in Ps_ do Result.v := Result.v + P.v;

          Result.v := Result.v / Length( Ps_ );
     end
     else
     begin
          for P in Ps_ do Result.v := Result.v + P.w * P.v;

          Result.v := Result.v / Result.w;
     end;
end;

end. //######################################################################### ■