unit LUX.S3.Curve.ExpMap;

// ExpMap :Exponential map

interface //#################################################################### ■

uses LUX,
     LUX.S3,
     LUX.S3.Curve;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ExpMap

function ExpMap( const Qs_:TArray<TSingleW3S> ) :TSingleW3S; overload;
function ExpMap( const Qs_:TArray<TDoubleW3S> ) :TDoubleW3S; overload;

implementation //############################################################### ■

uses LUX.Quaternion;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ExpMap

function ExpMap( const Qs_:TArray<TSingleW3S> ) :TSingleW3S;
var
   Q :TSingleW3S;
begin
     Result := TSingleW3S.Create( 0, 0 );

     for Q in Qs_ do Result.w := Result.w + Q.w;

     if Abs( Result.w ) < SINGLE_EPS3 then
     begin
          for Q in Qs_ do Result.v := Result.v + Ln( Q.v );

          Result.v := Exp( Result.v );
     end
     else
     begin
          for Q in Qs_ do Result.v := Result.v + Q.w * Ln( Q.v );

          Result.v := Exp( Result.v / Result.w );
     end;
end;

function ExpMap( const Qs_:TArray<TDoubleW3S> ) :TDoubleW3S;
var
   Q :TDoubleW3S;
begin
     Result := TDoubleW3S.Create( 0, 0 );

     for Q in Qs_ do Result.w := Result.w + Q.w;

     if Abs( Result.w ) < DOUBLE_EPS3 then
     begin
          for Q in Qs_ do Result.v := Result.v + Ln( Q.v );

          Result.v := Exp( Result.v );
     end
     else
     begin
          for Q in Qs_ do Result.v := Result.v + Q.w * Ln( Q.v );

          Result.v := Exp( Result.v / Result.w );
     end;
end;

end. //######################################################################### ■