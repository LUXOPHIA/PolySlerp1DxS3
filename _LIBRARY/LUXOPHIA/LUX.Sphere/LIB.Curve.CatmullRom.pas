unit LIB.Curve.CatmullRom;

interface //#################################################################### ■

uses LIB.Curve;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRom<_TPoin_>

     TCurveCatmullRom<_TPoin_> = class( TCurve<_TPoin_> )
     private
     protected
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRomREC<_TPoin_>

     TCurveCatmullRomREC<_TPoin_> = class( TCurveCatmullRom<_TPoin_> )
     private
     protected
       ///// M E T H O D
       function Segment( const i:Integer; const t:Double ) :_TPoin_; override;
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRomAVE<_TPoin_>

     TCurveCatmullRomAVE<_TPoin_> = class( TCurveCatmullRom<_TPoin_> )
     private
     protected
       ///// M E T H O D
       function Segment( const i:Integer; const t:Double ) :_TPoin_; override;
     public
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function CatmullRom( const t:Single ) :TArray<Single>; overload;
function CatmullRom( const t:Double ) :TArray<Double>; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRom<_TPoin_>

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRomREC<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveCatmullRomREC<_TPoin_>.Segment( const i:Integer; const t:Double ) :_TPoin_;
var
   Ps :TArray<_TPoin_>;
begin
     SetLength( Ps, 4 );

     Ps[0] := Poins[ i-1 ];
     Ps[1] := Poins[ i   ];
     Ps[2] := Poins[ i+1 ];
     Ps[3] := Poins[ i+2 ];

     Ps[0] := Bary.Center( Ps[0], Ps[1],   t + 1       );
     Ps[1] := Bary.Center( Ps[1], Ps[2],   t           );
     Ps[2] := Bary.Center( Ps[2], Ps[3],   t - 1       );

     Ps[0] := Bary.Center( Ps[0], Ps[1], ( t + 1 ) / 2 );
     Ps[1] := Bary.Center( Ps[1], Ps[2],   t       / 2 );

     Ps[0] := Bary.Center( Ps[0], Ps[1],   t           );

     Result := Ps[0];
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRomAVE<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveCatmullRomAVE<_TPoin_>.Segment( const i:Integer; const t:Double ) :_TPoin_;
var
   Ps :TArray<TWector>;
   Ws :TArray<Double>;
begin
     SetLength( Ps, 4 );

     Ws := CatmullRom( t );

     Ps[0] := TWector.Create( Poins[ i-1 ], Ws[0] );
     Ps[1] := TWector.Create( Poins[ i   ], Ws[1] );
     Ps[2] := TWector.Create( Poins[ i+1 ], Ws[2] );
     Ps[3] := TWector.Create( Poins[ i+2 ], Ws[3] );

     Result := Bary.Center( Ps );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function CatmullRom( const t:Single ) :TArray<Single>;
begin
     SetLength( Result, 4 );

     Result[0] := ( ( -0.5 * t + 1.0 ) * t - 0.5 ) * t      ;
     Result[1] := ( ( +1.5 * t - 2.5 ) * t       ) * t + 1.0;
     Result[2] := ( ( -1.5 * t + 2.0 ) * t + 0.5 ) * t      ;
     Result[3] := ( ( +0.5 * t - 0.5 ) * t       ) * t      ;
end;

function CatmullRom( const t:Double ) :TArray<Double>;
begin
     SetLength( Result, 4 );

     Result[0] := ( ( -0.5 * t + 1.0 ) * t - 0.5 ) * t      ;
     Result[1] := ( ( +1.5 * t - 2.5 ) * t       ) * t + 1.0;
     Result[2] := ( ( -1.5 * t + 2.0 ) * t + 0.5 ) * t      ;
     Result[3] := ( ( +0.5 * t - 0.5 ) * t       ) * t      ;
end;

end. //######################################################################### ■