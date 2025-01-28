unit LUX.S3.Bary.ExpMap;

// ExpMap :Exponential map

interface //#################################################################### ■

uses LUX.S3,
     LUX.S3.Bary;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBaryExpMap3S

     TBaryExpMap3S = class( TDoubleBary3S )
     private
     protected
     public
       ///// M E T H O D
       function Center( const Ps_:TArray<TDoubleW3S> ) :TDouble3S; override;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ExpMap

function ExpMap( const Qs_:TArray<TSingleW3S> ) :TSingleW3S; overload;
function ExpMap( const Qs_:TArray<TDoubleW3S> ) :TDoubleW3S; overload;

implementation //############################################################### ■

uses LUX.Quaternion;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBaryExpMap3S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TBaryExpMap3S.Center( const Ps_:TArray<TDoubleW3S> ) :TDouble3S;
begin
     Result := ExpMap( Ps_ ).v;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ExpMap

function ExpMap( const Qs_:TArray<TSingleW3S> ) :TSingleW3S;
var
   Q :TSingleW3S;
begin
     Result.v := 0;
     Result.w := 0;
     for Q in Qs_ do
     begin
          Result.v := Result.v + Q.w * Ln( Q.v );
          Result.w := Result.w + Q.w;
     end;
     Result.v := Exp( Result.v / Result.w );
end;

function ExpMap( const Qs_:TArray<TDoubleW3S> ) :TDoubleW3S;
var
   Q :TDoubleW3S;
begin
     Result.v := 0;
     Result.w := 0;
     for Q in Qs_ do
     begin
          Result.v := Result.v + Q.w * Ln( Q.v );
          Result.w := Result.w + Q.w;
     end;
     Result.v := Exp( Result.v / Result.w );
end;

end. //######################################################################### ■