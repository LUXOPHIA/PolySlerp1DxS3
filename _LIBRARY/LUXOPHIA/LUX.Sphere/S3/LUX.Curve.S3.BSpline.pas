unit LUX.Curve.S3.BSpline;

interface //#################################################################### ■

uses LIB.Curve.BSpline,
     LUX.S3,
     LUX.Poins.S3,
     LUX.Curve.S3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     TCurveBSpline3S = TCurveBSpline<TDouble3S>;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSplineREC

     TCurveBSplineREC = class( TCurveBSpline3S )
     private
     protected
       ///// M E T H O D
       function Segment( const i:Integer; const t:Double ) :TDouble3S; override;
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSplineAVE

     TCurveBSplineAVE = class( TCurveBSpline3S )
     private
     protected
       ///// M E T H O D
       function Segment( const i:Integer; const t:Double ) :TDouble3S; override;
     public
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSplineREC

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveBSplineREC.Segment( const i:Integer; const t:Double ) :TDouble3S;
var
   Ps :TArray<TDouble3S>;
   J :Integer;
begin
     SetLength( Ps, DegN+1 );

     for J := 0 to DegN do Ps[ J ] := _Poins[ i + J ];

     Result := CurveREC( Ps, t, Slerp );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSplineAVE

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveBSplineAVE.Segment( const i:Integer; const t:Double ) :TDouble3S;
var
   Ps :TArray<TDouble3Sw>;
   J :Integer;
begin
     SetLength( Ps, DegN+1 );

     for J := 0 to DegN do Ps[ J ] := TDouble3Sw.Create( _Poins[ i+J ], BSpline( DegN, J, t ) );

     Result := TDouble3S( Sum1D( Ps ) );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■