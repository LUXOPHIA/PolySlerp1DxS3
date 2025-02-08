unit LIB.Curve.Bezier;

interface //#################################################################### ■

uses LIB.Poins,
     LIB.Curve;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBezier<_TPoin_>

     TCurveBezier<_TPoin_> = class( TCurveAlgo<_TPoin_> )
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
       ///// M E T H O D
       function Value( const X_:Double ) :_TPoin_; override;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Bezier( const N_,I_:Integer; const T_:Single ) :Single; overload;
function Bezier( const N_,I_:Integer; const T_:Double ) :Double; overload;

implementation //############################################################### ■

uses System.Math,
     LUX;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveBezier<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TCurveBezier<_TPoin_>.GetDegN :Integer;
begin
     Result := _DegN;
end;

procedure TCurveBezier<_TPoin_>.SetDegN( const DegN_:Integer );
begin
     _DegN := DegN_;  _OnChange.Run( Self );
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveBezier<_TPoin_>.Algorithm0( const i:Integer; const t:Double ) :_TPoin_;
var
   Ps :TArray<TWector>;
   J :Integer;
begin
     SetLength( Ps, DegN+1 );

     for J := 0 to DegN do Ps[ J ] := TWector.Create( Poins[ i+J ], Bezier( DegN, J, t ) );

     Result := Bary.Center( Ps );
end;

function TCurveBezier<_TPoin_>.Algorithm1( const i:Integer; const t:Double ) :_TPoin_;
var
   Ps :TArray<_TPoin_>;
   J, N :Integer;
begin
     SetLength( Ps, DegN+1 );

     for J := 0 to DegN do Ps[ J ] := Poins[ i + J ];

     for N := DegN-1 downto 0 do
     begin
          for J := 0 to N do Ps[ J ] := Bary.Center( Ps[ J ], Ps[ J+1 ], t );
     end;

     Result := Ps[ 0 ];
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCurveBezier<_TPoin_>.Create;
begin
     inherited;

     AlgosN := 2;
     _Algos[0] := Algorithm0;
     _Algos[1] := Algorithm1;

     DegN := 3;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveBezier<_TPoin_>.Value( const X_:Double ) :_TPoin_;
var
   i, J :Integer;
   t, s :Double;
begin
     i := Floor( X_ );
     t := X_ - I;

     j :=   i div DegN       * DegN;
     s := ( i mod DegN + t ) / DegN;

     Result := Segment( j, s );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Bezier( const N_,I_:Integer; const T_:Single ) :Single;
begin
     Result := Binomial32( N_, I_ ) * IntPower( 1 - T_, N_ - I_ )
                                    * IntPower(     T_,      I_ );
end;

function Bezier( const N_,I_:Integer; const T_:Double ) :Double;
begin
     Result := Binomial32( N_, I_ ) * IntPower( 1 - T_, N_ - I_ )
                                    * IntPower(     T_,      I_ );
end;

end. //######################################################################### ■