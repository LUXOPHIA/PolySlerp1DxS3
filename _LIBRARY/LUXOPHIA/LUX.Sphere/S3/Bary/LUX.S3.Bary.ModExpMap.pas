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

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ModExpSum1D

function ModExpSum1D( const Qs_:TArray<TSingleW3S> ) :TSingleW3S; overload;
function ModExpSum1D( const Qs_:TArray<TDoubleW3S> ) :TDoubleW3S; overload;

implementation //############################################################### ■

uses LUX.Quaternion,
     LUX.S3.Bary.Glerp;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBaryModExpMap3S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TBaryModExpMap3S.Center( const Ps_:TArray<TDoubleW3S> ) :TDouble3S;
begin
     Result := ModExpSum1D( Ps_ ).v;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ModExpSum1D

function ModExpSum1D( const Qs_:TArray<TSingleW3S> ) :TSingleW3S;
var
   G, Gi :TSingle3S;
   Q :TSingleW3S;
begin
     G := GlerpSum( Qs_ ).v;  Gi := G.Inv;

     Result.v := 0;
     Result.w := 0;
     for Q in Qs_ do
     begin
          Result.v := Result.v + Q.w * Ln( Gi * Q.v );
          Result.w := Result.w + Q.w;
     end;
     Result.v := G * Exp( Result.v / Result.w );
end;

function ModExpSum1D( const Qs_:TArray<TDoubleW3S> ) :TDoubleW3S;
var
   G, Gi :TDouble3S;
   Q :TDoubleW3S;
begin
     G := GlerpSum( Qs_ ).v;  Gi := G.Inv;

     Result.v := 0;
     Result.w := 0;
     for Q in Qs_ do
     begin
          Result.v := Result.v + Q.w * Ln( Gi * Q.v );
          Result.w := Result.w + Q.w;
     end;
     Result.v := G * Exp( Result.v / Result.w );
end;

end. //######################################################################### ■