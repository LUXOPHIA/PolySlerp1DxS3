unit LIB.Curve.S2.BSpline;

interface //#################################################################### ■

uses LIB.S2,
     LIB.Poins.S2,
     LIB.Curve.S2;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSpline

     TCurveBSpline = class( TCurve2S )
     private
     protected
       _DegreeN :Integer;
       ///// A C C E S S O R
       function GetDegreeN :Integer; virtual;
       procedure SetDegreeN( const DegreeN_:Integer ); virtual;
     public
       constructor Create( const Poins_:TPoins2S );
       ///// P R O P E R T Y
       property DegreeN :Integer read GetDegreeN write SetDegreeN;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSplineREC

     TCurveBSplineREC = class( TCurveBSpline )
     private
     protected
       ///// M E T H O D
       function Segment( const i:Integer; const t:Double ) :TDouble2S; override;
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSplinePOL

     TCurveBSplinePOL = class( TCurveBSpline )
     private
     protected
       ///// M E T H O D
       function Segment( const i:Integer; const t:Double ) :TDouble2S; override;
     public
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 V A R I A B L E 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function BSplineREC( const N,I:Integer; const T:Double; const Ks:TArray<Double> ) :Double; overload;
function BSplineREC( const N,I:Integer; const T:Double ) :Double; overload;

function BSpline( const N,I:Integer; const T:Double; const Ks:TArray<Double> ) :Double; overload;
function BSpline( const N,I:Integer; const T:Double ) :Double; overload;

implementation //############################################################### ■

uses LUX;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSpline

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TCurveBSpline.GetDegreeN :Integer;
begin
     Result := _DegreeN;
end;

procedure TCurveBSpline.SetDegreeN( const DegreeN_:Integer );
begin
     _DegreeN := DegreeN_;  _OnChange.Run( Self );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

constructor TCurveBSpline.Create( const Poins_:TPoins2S );
begin
     inherited;

     DegreeN := 3;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSplineREC

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveBSplineREC.Segment( const i:Integer; const t:Double ) :TDouble2S;
var
   Ps :TArray<TDouble2S>;
   N, L :Integer;
   S :Double;
begin
     SetLength( Ps, DegreeN+1 );
     for N := 0 to DegreeN do Ps[ N ] := _Poins[ i + N ];

     for L := DegreeN-1 downto 0 do
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

function TCurveBSplinePOL.Segment( const i:Integer; const t:Double ) :TDouble2S;
var
   N :Integer;
   Ps :TArray<TDouble2Sw>;
begin
     SetLength( Ps, DegreeN+1 );
     for N := 0 to DegreeN do
     begin
          with Ps[ N ] do
          begin
               v := _Poins[ i+N ];
               w := BSpline( DegreeN, N, t );
          end;
     end;

     Result := Sum1D( Ps ).v;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//  0    1    2    3    4    5    6    7 = i
//  +----+----+----+====+----+----+----+
// -3   -2   -1    0    1    2    3    4 = Ks[ i ]
//  |                                  |
// -N                                  N+1

function BSplineREC( const N,I:Integer; const T:Double; const Ks:TArray<Double> ) :Double;
begin
     if N = 0 then
     begin
          if ( Ks[ I ] <= T ) and ( T < Ks[ I+1 ] ) then Result := 1
                                                    else Result := 0;
     end
     else Result := ( T - Ks[ I     ]     ) / ( Ks[ I+N   ] - Ks[ I   ] ) * BSplineREC( N-1, I  , T, Ks )
                  + (     Ks[ I+N+1 ] - T ) / ( Ks[ I+N+1 ] - Ks[ I+1 ] ) * BSplineREC( N-1, I+1, T, Ks );
end;

function BSplineREC( const N,I:Integer; const T:Double ) :Double;
// - - - - - - - - - - - - - - - - - - -
     function BSplineREC( const N,L,I:Integer; const T:Double ) :Double;
     begin
          if L = 0 then
          begin
               if ( I-N <= T ) and ( T < I-N+1 ) then Result := 1
                                                 else Result := 0;
          end
          else Result := ( ( T - (I-N    )     ) * BSplineREC( N, L-1, I  , T )
                         + (     (I-N+L+1) - T ) * BSplineREC( N, L-1, I+1, T ) ) / N;
     end;
// - - - - - - - - - - - - - - - - - - -
begin
     Result := BSplineREC( N, N, I, T );
end;

//------------------------------------------------------------------------------

function BSpline( const N,I:Integer; const T:Double; const Ks:TArray<Double> ) :Double;
var
   Bs :TArray<Double>;
   J, L :Integer;
   W0, W1 :Double;
begin
     SetLength( Bs, N+1 );
     for J := 0 to N do
     begin
          if ( Ks[ I+J ] <= T ) and ( T < Ks[ I+J+1 ] ) then Bs[ J ] := 1
                                                        else Bs[ J ] := 0;
     end;

     for L := 1 to N do
     begin
          for J := 0 to N-L do
          begin
               W0 := ( T - Ks[ I+J     ]     ) / ( Ks[ I+J+L   ] - Ks[ I+J   ] );
               W1 := (     Ks[ I+J+L+1 ] - T ) / ( Ks[ I+J+L+1 ] - Ks[ I+J+1 ] );

               Bs[ J ] := W0 * Bs[ J ] + W1 * Bs[ J+1 ];
          end;
     end;

     Result := Bs[ 0 ];
end;

function BSpline( const N,I:Integer; const T:Double ) :Double;
var
   Bs :TArray<Double>;
   J, L :Integer;
begin
     SetLength( Bs, N+1 );
     for J := 0 to N do
     begin
          if ( I+J-N <= T ) and ( T < I+J-N+1 ) then Bs[ J ] := 1
                                                else Bs[ J ] := 0;
     end;

     for L := 1 to N do
     begin
          for J := 0 to N-L do
          begin
               Bs[ J ] := ( ( T - ( I+J-N     )     ) * Bs[ J   ]
                          + (     ( I+J-N+L+1 ) - T ) * Bs[ J+1 ] ) / L;
          end;
     end;

     Result := Bs[ 0 ];
end;

end. //######################################################################### ■