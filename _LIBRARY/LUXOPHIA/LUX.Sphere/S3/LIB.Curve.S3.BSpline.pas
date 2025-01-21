unit LIB.Curve.S3.BSpline;

interface //#################################################################### ■

uses LIB.S3,
     LIB.Poins.S3,
     LIB.Curve.S3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSpline

     TCurveBSpline = class( TCurve3S )
     private
     protected
       _DegN :Integer;
       ///// A C C E S S O R
       function GetDegN :Integer; virtual;
       procedure SetDegN( const DegN_:Integer ); virtual;
     public
       constructor Create( const Poins_:TPoins3S );
       ///// P R O P E R T Y
       property DegN :Integer read GetDegN write SetDegN;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSplineREC

     TCurveBSplineREC = class( TCurveBSpline )
     private
     protected
       ///// M E T H O D
       function Segment( const i:Integer; const t:Double ) :TDouble3S; override;
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSplinePOL

     TCurveBSplinePOL = class( TCurveBSpline )
     private
     protected
       ///// M E T H O D
       function Segment( const i:Integer; const t:Double ) :TDouble3S; override;
     public
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses LUX, LUX.Curve.BSpline;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSpline

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TCurveBSpline.GetDegN :Integer;
begin
     Result := _DegN;
end;

procedure TCurveBSpline.SetDegN( const DegN_:Integer );
begin
     _DegN := DegN_;  _OnChange.Run( Self );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

constructor TCurveBSpline.Create( const Poins_:TPoins3S );
begin
     inherited;

     DegN := 3;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSplineREC

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveBSplineREC.Segment( const i:Integer; const t:Double ) :TDouble3S;
var
   Ps :TArray<TDouble3S>;
   N, L :Integer;
   S :Double;
begin
     SetLength( Ps, DegN+1 );
     for N := 0 to DegN do Ps[ N ] := _Poins[ i + N ];

     for L := DegN-1 downto 0 do
     begin
          for N := 0 to L do
          begin
               S := ( t + L - N ) / ( L + 1 );

               Ps[ N ] := Slerp( Ps[ N ], Ps[ N+1 ], S );
          end;
     end;

     Result := Ps[ 0 ];
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSplinePOL

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveBSplinePOL.Segment( const i:Integer; const t:Double ) :TDouble3S;
var
   N :Integer;
   Ps :TArray<TDouble3Sw>;
begin
     SetLength( Ps, DegN+1 );
     for N := 0 to DegN do
     begin
          with Ps[ N ] do
          begin
               v := _Poins[ i+N ];
               w := BSpline( DegN, N, t );
          end;
     end;

     Result := Sum1D( Ps ).v;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■