unit LIB.Curve.BSpline;

interface //#################################################################### ■

uses LUX.Data.Grid.D1,
     LIB.Curve,
     LUX.Curve.BSpline;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSpline<_TPoin_>

     TCurveBSpline<_TPoin_> = class( TCurveAlgo<_TPoin_> )
     private
     protected
       _DegN :Integer;
       ///// A C C E S S O R
       function GetDegN :Integer; virtual;
       procedure SetDegN( const DegN_:Integer ); virtual;
       ///// M E T H O D
       function Algorithm0( const i:Integer; const t:Double ) :_TPoin_;
       function Algorithm1( const i:Integer; const t:Double ) :_TPoin_;
     public
       constructor Create;
       ///// P R O P E R T Y
       property DegN :Integer read GetDegN write SetDegN;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSpline<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TCurveBSpline<_TPoin_>.GetDegN :Integer;
begin
     Result := _DegN;
end;

procedure TCurveBSpline<_TPoin_>.SetDegN( const DegN_:Integer );
begin
     _DegN := DegN_;  _OnChange.Run( Self );
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveBSpline<_TPoin_>.Algorithm0( const i:Integer; const t:Double ) :_TPoin_;
var
   Ps :TArray<TWector>;
   J :Integer;
begin
     SetLength( Ps, DegN+1 );

     for J := 0 to DegN do Ps[ J ] := TWector.Create( Poins[ i+J ], BSpline( DegN, J, t ) );

     Result := Bary.Center( Ps );
end;

function TCurveBSpline<_TPoin_>.Algorithm1( const i:Integer; const t:Double ) :_TPoin_;
var
   Ps :TArray<_TPoin_>;
   J, N :Integer;
   S :Double;
begin
     SetLength( Ps, DegN+1 );

     for J := 0 to DegN do Ps[ J ] := Poins[ i + J ];

     for N := DegN-1 downto 0 do
     begin
          for J := 0 to N do
          begin
               S := ( t + N - J ) / ( N + 1 );

               Ps[ J ] := Bary.Center( Ps[ J ], Ps[ J+1 ], S );
          end;
     end;

     Result := Ps[ 0 ];
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCurveBSpline<_TPoin_>.Create;
begin
     inherited;

     AlgosN := 2;
     _Algos[0] := Algorithm0;
     _Algos[1] := Algorithm1;

     DegN := 3;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■