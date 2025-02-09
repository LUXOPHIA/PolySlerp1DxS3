unit LUX.S3.Bary.Glerp;

// Glerp :Gnomonic Linear Interpolation

interface //#################################################################### ■

uses LUX.S3,
     LUX.S3.Bary;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBaryGLerp3S

     TBaryGLerp3S = class( TDoubleBary3S )
     private
     protected
     public
       ///// M E T H O D
       function Center( const Ps_:TArray<TDoubleW3S> ) :TDouble3S; override;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Glerp

function Glerp( const P1_,P2_:TSingle3S ) :TSingle3S; overload;
function Glerp( const P1_,P2_:TDouble3S ) :TDouble3S; overload;

function Glerp( const P1_,P2_:TSingle3S; const T_:Single ) :TSingle3S; overload;
function Glerp( const P1_,P2_:TDouble3S; const T_:Double ) :TDouble3S; overload;

function Glerp( const P1_,P2_:TSingle3S; const W1_,W2_:Single ) :TSingle3S; overload;
function Glerp( const P1_,P2_:TDouble3S; const W1_,W2_:Double ) :TDouble3S; overload;

function Glerp( const P1_,P2_:TSingleW3S ) :TSingleW3S; overload;
function Glerp( const P1_,P2_:TDoubleW3S ) :TDoubleW3S; overload;

function Glerp( const Ps_:TArray<TSingle3S> ) :TSingle3S; overload;
function Glerp( const Ps_:TArray<TDouble3S> ) :TDouble3S; overload;

function Glerp( const Ps_:TArray<TSingleW3S> ) :TSingleW3S; overload;
function Glerp( const Ps_:TArray<TDoubleW3S> ) :TDoubleW3S; overload;

implementation //############################################################### ■

uses LUX, LUX.Curve.Linear.Q4;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBaryGLerp3S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TBaryGLerp3S.Center( const Ps_:TArray<TDoubleW3S> ) :TDouble3S;
begin
     Result := Glerp( Ps_ ).v;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Glerp

function Glerp( const P1_,P2_:TSingle3S ) :TSingle3S;
begin
     Result := Lerp( P1_, P2_ ).Unitor;
end;

function Glerp( const P1_,P2_:TDouble3S ) :TDouble3S;
begin
     Result := Lerp( P1_, P2_ ).Unitor;
end;

//------------------------------------------------------------------------------

function Glerp( const P1_,P2_:TSingle3S; const T_:Single ) :TSingle3S;
begin
     Result := Lerp( P1_, P2_, T_ ).Unitor;
end;

function Glerp( const P1_,P2_:TDouble3S; const T_:Double ) :TDouble3S;
begin
     Result := Lerp( P1_, P2_, T_ ).Unitor;
end;

//------------------------------------------------------------------------------

function Glerp( const P1_,P2_:TSingle3S; const W1_,W2_:Single ) :TSingle3S;
begin
     Result := Lerp( P1_, P2_, W1_, W2_ ).Unitor;
end;

function Glerp( const P1_,P2_:TDouble3S; const W1_,W2_:Double ) :TDouble3S;
begin
     Result := Lerp( P1_, P2_, W1_, W2_ ).Unitor;
end;

//------------------------------------------------------------------------------

function Glerp( const P1_,P2_:TSingleW3S ) :TSingleW3S;
begin
     Result.v := Glerp( P1_.v, P2_.v, P1_.w, P2_.w );
     Result.w := P1_.w + P2_.w;
end;

function Glerp( const P1_,P2_:TDoubleW3S ) :TDoubleW3S;
begin
     Result.v := Glerp( P1_.v, P2_.v, P1_.w, P2_.w );
     Result.w := P1_.w + P2_.w;
end;

//------------------------------------------------------------------------------

function Glerp( const Ps_:TArray<TSingle3S> ) :TSingle3S;
var
   P :TSingle3S;
begin
     Result := 0;

     for P in Ps_ do Result := Result + P;

     Result := Result.Unitor;
end;

function Glerp( const Ps_:TArray<TDouble3S> ) :TDouble3S;
var
   P :TDouble3S;
begin
     Result := 0;

     for P in Ps_ do Result := Result + P;

     Result := Result.Unitor;
end;

//------------------------------------------------------------------------------

function Glerp( const Ps_:TArray<TSingleW3S> ) :TSingleW3S;
var
   P :TSingleW3S;
begin
     Result := TSingleW3S.Create( 0, 0 );

     for P in Ps_ do Result.w := Result.w + P.w;

     if Abs( Result.w ) < SINGLE_EPS3 then
     begin
          for P in Ps_ do Result.v := Result.v + P.v;
     end
     else
     begin
          for P in Ps_ do Result.v := Result.v + P.w * P.v;

          Result.v := Result.v / Result.w;
     end;

     Result := Result.Unitor;
end;

function Glerp( const Ps_:TArray<TDoubleW3S> ) :TDoubleW3S;
var
   P :TDoubleW3S;
begin
     Result := TDoubleW3S.Create( 0, 0 );

     for P in Ps_ do Result.w := Result.w + P.w;

     if Abs( Result.w ) < DOUBLE_EPS3 then
     begin
          for P in Ps_ do Result.v := Result.v + P.v;
     end
     else
     begin
          for P in Ps_ do Result.v := Result.v + P.w * P.v;

          Result.v := Result.v / Result.w;
     end;

     Result := Result.Unitor;
end;

end. //######################################################################### ■