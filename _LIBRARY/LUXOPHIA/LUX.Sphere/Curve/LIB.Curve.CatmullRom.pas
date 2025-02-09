unit LIB.Curve.CatmullRom;

interface //#################################################################### ■

uses LIB,
     LUX.D4,
     LIB.Curve,
     LUX.Curve.CatmullRom;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRom<_TPoin_>

     TCurveCatmullRom<_TPoin_> = class( TCurveAlgo<_TPoin_> )
     private
     protected
       ///// M E T H O D
       function Algorithm0( const i:Integer; const t:Double ) :_TPoin_;
       function Algorithm1( const i:Integer; const t:Double ) :_TPoin_;
     public
       constructor Create;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRom<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveCatmullRom<_TPoin_>.Algorithm0( const i:Integer; const t:Double ) :_TPoin_;
var
   Ws :TDouble4D;
   Ps :TArray<TWector>;
begin
     Ws := CatmullRom( t );

     Ps := [ TWector.Create( Poins[ i-1 ], Ws[1] ),
             TWector.Create( Poins[ i   ], Ws[2] ),
             TWector.Create( Poins[ i+1 ], Ws[3] ),
             TWector.Create( Poins[ i+2 ], Ws[4] ) ];

     Result := Bary.Center( Ps );
end;

function TCurveCatmullRom<_TPoin_>.Algorithm1( const i:Integer; const t:Double ) :_TPoin_;
var
   Ps :TArray<_TPoin_>;
begin
     Ps := [ Poins[ i-1 ],
             Poins[ i   ],
             Poins[ i+1 ],
             Poins[ i+2 ] ];

     Ps[0] := Bary.Center( Ps[0], Ps[1],   t + 1       );
     Ps[1] := Bary.Center( Ps[1], Ps[2],   t           );
     Ps[2] := Bary.Center( Ps[2], Ps[3],   t - 1       );

     Ps[0] := Bary.Center( Ps[0], Ps[1], ( t + 1 ) / 2 );
     Ps[1] := Bary.Center( Ps[1], Ps[2],   t       / 2 );

     Ps[0] := Bary.Center( Ps[0], Ps[1],   t           );

     Result := Ps[0];
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCurveCatmullRom<_TPoin_>.Create;
begin
     inherited;

     AlgosN := 2;
     _Algos[0] := Algorithm0;
     _Algos[1] := Algorithm1;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■