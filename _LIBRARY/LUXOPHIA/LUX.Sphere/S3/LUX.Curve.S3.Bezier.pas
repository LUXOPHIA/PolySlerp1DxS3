unit LUX.Curve.S3.Bezier;

interface //#################################################################### ■

uses LUX.S3,
     LUX.Poins.S3,
     LUX.Curve.S3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBezier

     TCurveBezier = class( TCurve3S )
     private
     protected
       _DegN :Integer;
       ///// A C C E S S O R
       function GetDegN :Integer; virtual;
       procedure SetDegN( const DegreeN_:Integer ); virtual;
       ///// M E T H O D
       function Segment( const i:Integer; const t:Double ) :TDouble3S; override;
       function Segment2( const i:Integer; const t:Double ) :TDouble3S; virtual; abstract;
     public
       constructor Create( const Poins_:TPoins3S );
       ///// P R O P E R T Y
       property DegN :Integer read GetDegN write SetDegN;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBezierREC

     TCurveBezierREC = class( TCurveBezier )
     private
     protected
       ///// M E T H O D
       function Segment2( const i:Integer; const t:Double ) :TDouble3S; override;
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBezierPOL

     TCurveBezierPOL = class( TCurveBezier )
     private
     protected
       ///// M E T H O D
       function Segment2( const i:Integer; const t:Double ) :TDouble3S; override;
     public
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses LIB.Curve.Bezier;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBezier

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TCurveBezier.GetDegN :Integer;
begin
     Result := _DegN;
end;

procedure TCurveBezier.SetDegN( const DegreeN_:Integer );
begin
     _DegN := DegreeN_;  _OnChange.Run( Self );
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveBezier.Segment( const i:Integer; const t:Double ) :TDouble3S;
var
   j :Integer;
   s :Double;
begin
     j :=   i div DegN       * DegN;
     s := ( i mod DegN + t ) / DegN;

     Result := Segment2( j, s );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

constructor TCurveBezier.Create( const Poins_:TPoins3S );
begin
     inherited;

     DegN := 3;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBezierREC

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveBezierREC.Segment2( const i:Integer; const t:Double ) :TDouble3S;
var
   Ps :TArray<TDouble3S>;
   N, L :Integer;
begin
     SetLength( Ps, DegN+1 );
     for N := 0 to DegN do Ps[ N ] := _Poins[ i + N ];

     for L := DegN-1 downto 0 do
     begin
          for N := 0 to L do Ps[ N ] := Slerp( Ps[ N ], Ps[ N+1 ], t );
     end;

     Result := Ps[ 0 ];
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBezierPOL

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveBezierPOL.Segment2( const i:Integer; const t:Double ) :TDouble3S;
var
   Ps :TArray<TDouble3Sw>;
   N :Integer;
begin
     SetLength( Ps, DegN+1 );
     for N := 0 to DegN do
     begin
          with Ps[ N ] do
          begin
               v := _Poins[ i + N ];
               w := Bezier( DegN, N, t );
          end;
     end;

     Result := Sum1D( Ps ).v;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■