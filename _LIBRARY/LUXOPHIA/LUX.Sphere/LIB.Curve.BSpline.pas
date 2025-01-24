unit LIB.Curve.BSpline;

interface //#################################################################### ■

uses LIB.Poins,
     LIB.Curve;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSpline<_TPoin_>

     TCurveBSpline<_TPoin_> = class( TCurve<_TPoin_> )
     private
     protected
       _DegN :Integer;
       ///// A C C E S S O R
       function GetDegN :Integer; virtual;
       procedure SetDegN( const DegN_:Integer ); virtual;
     public
       constructor Create( const Poins_:TPoins<_TPoin_> );
       ///// P R O P E R T Y
       property DegN :Integer read GetDegN write SetDegN;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSplineREC<_TPoin_>

     TCurveBSplineREC<_TPoin_> = class( TCurveBSpline<_TPoin_> )
     private
     protected
       ///// M E T H O D
       function Segment( const i:Integer; const t:Double ) :_TPoin_; override;
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSplineAVE<_TPoin_>

     TCurveBSplineAVE<_TPoin_> = class( TCurveBSpline<_TPoin_> )
     private
     protected
       ///// M E T H O D
       function Segment( const i:Integer; const t:Double ) :_TPoin_; override;
     public
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function BSplineREC( const N,I:Integer; const T:Single; const Ks:TArray<Single> ) :Single; overload;
function BSplineREC( const N,I:Integer; const T:Double; const Ks:TArray<Double> ) :Double; overload;

function BSplineREC( const N,I:Integer; const T:Single ) :Single; overload;
function BSplineREC( const N,I:Integer; const T:Double ) :Double; overload;

function BSpline( const N,I:Integer; const T:Single; const Ks:TArray<Single> ) :Single; overload;
function BSpline( const N,I:Integer; const T:Double; const Ks:TArray<Double> ) :Double; overload;

function BSpline( const N,I:Integer; const T:Single ) :Single; overload;
function BSpline( const N,I:Integer; const T:Double ) :Double; overload;

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

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCurveBSpline<_TPoin_>.Create( const Poins_:TPoins<_TPoin_> );
begin
     inherited;

     DegN := 3;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSplineREC<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveBSplineREC<_TPoin_>.Segment( const i:Integer; const t:Double ) :_TPoin_;
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

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBSplineAVE<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveBSplineAVE<_TPoin_>.Segment( const i:Integer; const t:Double ) :_TPoin_;
var
   Ps :TArray<TWector>;
   J :Integer;
begin
     SetLength( Ps, DegN+1 );

     for J := 0 to DegN do Ps[ J ] := TWector.Create( Poins[ i+J ], BSpline( DegN, J, t ) );

     Result := Bary.Center( Ps );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//  0     1     2     3     4     5     6     7 = i
//  +-----+-----+-----+=====+-----+-----+-----+
// -3    -2    -1     0     1     2     3     4 = Ks[ i ]
//  |                                         |
// -N                                         N+1

//------------------------------------------------------------------------------

function BSplineREC( const N,I:Integer; const T:Single; const Ks:TArray<Single> ) :Single;
begin
     if N = 0 then
     begin
          if ( Ks[ I ] <= T ) and ( T < Ks[ I+1 ] ) then Result := 1
                                                    else Result := 0;
     end
     else Result := ( T - Ks[ I     ]     ) / ( Ks[ I+N   ] - Ks[ I   ] ) * BSplineREC( N-1, I  , T, Ks )
                  + (     Ks[ I+N+1 ] - T ) / ( Ks[ I+N+1 ] - Ks[ I+1 ] ) * BSplineREC( N-1, I+1, T, Ks );
end;

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

//------------------------------------------------------------------------------

function BSplineREC( const N,I:Integer; const T:Single ) :Single;
// - - - - - - - - - - - - - - - - - - -
     function BSplineREC( const L,I:Integer ) :Single;
     begin
          if L = 0 then
          begin
               if ( I-N <= T ) and ( T < I-N+1 ) then Result := 1
                                                 else Result := 0;
          end
          else Result := ( ( T - (I-N    )     ) * BSplineREC( L-1, I   )
                         + (     (I-N+L+1) - T ) * BSplineREC( L-1, I+1 ) ) / N;
     end;
// - - - - - - - - - - - - - - - - - - -
begin
     Result := BSplineREC( N, I );
end;

function BSplineREC( const N,I:Integer; const T:Double ) :Double;
// - - - - - - - - - - - - - - - - - - -
     function BSplineREC( const L,I:Integer ) :Double;
     begin
          if L = 0 then
          begin
               if ( I-N <= T ) and ( T < I-N+1 ) then Result := 1
                                                 else Result := 0;
          end
          else Result := ( ( T - (I-N    )     ) * BSplineREC( L-1, I   )
                         + (     (I-N+L+1) - T ) * BSplineREC( L-1, I+1 ) ) / N;
     end;
// - - - - - - - - - - - - - - - - - - -
begin
     Result := BSplineREC( N, I );
end;

//------------------------------------------------------------------------------

function BSpline( const N,I:Integer; const T:Single; const Ks:TArray<Single> ) :Single;
var
   Bs :TArray<Single>;
   J, L :Integer;
   W0, W1 :Single;
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

//------------------------------------------------------------------------------

function BSpline( const N,I:Integer; const T:Single ) :Single;
var
   Bs :TArray<Single>;
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