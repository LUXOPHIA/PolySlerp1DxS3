unit LUX.S3.Bary.ModExpMap;

// ExpMap :Exponential map

interface //#################################################################### ■

uses LUX.S3,
     LUX.S3.Bary;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBaryModExpMap3S

     TBaryModExpMap3S = class( TDoubleBary3S )
     private
     protected
     public
       ///// M E T H O D
       function Center( const Ps_:TArray<TDoubleW3S> ) :TDouble3S; override;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ModExpMap

function ModExpMap( const Qs_:TArray<TSingleW3S> ) :TSingleW3S; overload;
function ModExpMap( const Qs_:TArray<TDoubleW3S> ) :TDoubleW3S; overload;

implementation //############################################################### ■

uses LUX,
     LUX.Quaternion,
     LUX.S3.Bary.Glerp;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBaryModExpMap3S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TBaryModExpMap3S.Center( const Ps_:TArray<TDoubleW3S> ) :TDouble3S;
begin
     Result := ModExpMap( Ps_ ).v;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ModExpMap

function ModExpMap( const Qs_:TArray<TSingleW3S> ) :TSingleW3S;
var
   G, Gi :TSingle3S;
   Q :TSingleW3S;
begin
     G := Glerp( Qs_ ).v;  Gi := G.Inv;

     Result := TSingleW3S.Create( 0, 0 );

     for Q in Qs_ do Result.w := Result.w + Q.w;

     if Abs( Result.w ) < SINGLE_EPS3 then
     begin
          for Q in Qs_ do Result.v := Result.v + Ln( Gi * Q.v );

          Result.v := G * Exp( Result.v );
     end
     else
     begin
          for Q in Qs_ do Result.v := Result.v + Q.w * Ln( Gi * Q.v );

          Result.v := G * Exp( Result.v / Result.w );
     end;
end;

function ModExpMap( const Qs_:TArray<TDoubleW3S> ) :TDoubleW3S;
var
   G, Gi :TDouble3S;
   Q :TDoubleW3S;
begin
     G := Glerp( Qs_ ).v;  Gi := G.Inv;

     Result := TDoubleW3S.Create( 0, 0 );

     for Q in Qs_ do Result.w := Result.w + Q.w;

     if Abs( Result.w ) < DOUBLE_EPS3 then
     begin
          for Q in Qs_ do Result.v := Result.v + Ln( Gi * Q.v );

          Result.v := G * Exp( Result.v );
     end
     else
     begin
          for Q in Qs_ do Result.v := Result.v + Q.w * Ln( Gi * Q.v );

          Result.v := G * Exp( Result.v / Result.w );
     end;
end;

end. //######################################################################### ■