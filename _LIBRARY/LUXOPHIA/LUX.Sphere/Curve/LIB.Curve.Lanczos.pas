unit LIB.Curve.Lanczos;

interface //#################################################################### ■

uses LUX.Data.Grid.D1,
     LIB.Curve,
     LUX.Curve.Lanczos;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveLanczos<_TPoin_>

     TCurveLanczos<_TPoin_> = class( TCurveAlgo<_TPoin_> )
     private
     protected
       _WinR :Integer;
       ///// A C C E S S O R
       function GetWinR :Integer; virtual;
       procedure SetWinR( const WinR_:Integer ); virtual;
       ///// M E T H O D
       function Lanczos( const X_:Double ) :Double;
       function Algorithm0( const i:Integer; const t:Double ) :_TPoin_;
     public
       constructor Create;
       ///// P R O P E R T Y
       property WinR :Integer read GetWinR write SetWinR;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses LUX;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveLanczos<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TCurveLanczos<_TPoin_>.GetWinR :Integer;
begin
     Result := _WinR;
end;

procedure TCurveLanczos<_TPoin_>.SetWinR( const WinR_:Integer );
begin
     _WinR := WinR_;  _OnChange.Run( Self );
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveLanczos<_TPoin_>.Lanczos( const X_:Double ) :Double;
begin
     if Abs( X_ ) < _WinR then Result := Sinc( X_ ) * Sinc( X_ / _WinR )
                          else Result := 0;
end;

//     -2-t  -1-t    -t     1-t   2-t   3-t
//        |     |     | 0   |     |     |
//    |-----+-----+-----|-----+-----+-----|    :Basis Function
//  +-----+-----+-----+=====+-----+-----+-----+ :Poins
// -3    -2    -1     0     1     2     3     4

function TCurveLanczos<_TPoin_>.Algorithm0( const i:Integer; const t:Double ) :_TPoin_;
var
   Ps :TArray<TWector>;
   J :Integer;
begin
     SetLength( Ps, 2*WinR );

     for J := 1-WinR to WinR do Ps[ J+WinR-1 ] := TWector.Create( Poins[ i+J ], Lanczos( J-t ) );

     Result := Bary.Center( Ps );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCurveLanczos<_TPoin_>.Create;
begin
     inherited;

     AlgosN := 1;
     _Algos[0] := Algorithm0;

     WinR := 2;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■