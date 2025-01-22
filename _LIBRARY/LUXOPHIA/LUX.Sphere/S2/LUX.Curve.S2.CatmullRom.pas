unit LUX.Curve.S2.CatmullRom;

interface //#################################################################### ■

uses LUX.S2,
     LUX.Curve.S2;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRom

     TCurveCatmullRom = class( TCurve2S )
     private
     protected
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRomREC

     TCurveCatmullRomREC = class( TCurveCatmullRom )
     private
     protected
       ///// M E T H O D
       function Segment( const i:Integer; const t:Double ) :TDouble2S; override;
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRomAVE

     TCurveCatmullRomAVE = class( TCurveCatmullRom )
     private
     protected
       ///// M E T H O D
       function Segment( const i:Integer; const t:Double ) :TDouble2S; override;
     public
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses LUX.D4,
     LIB.Curve.CatmullRom;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRom

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRomREC

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveCatmullRomREC.Segment( const i:Integer; const t:Double ) :TDouble2S;
var
   Ps :TArray<TDouble2S>;
begin
     SetLength( Ps, 4 );

     Ps[0] := _Poins[ i-1 ];
     Ps[1] := _Poins[ i   ];
     Ps[2] := _Poins[ i+1 ];
     Ps[3] := _Poins[ i+2 ];

     Result := TDoubleCatmullRom<TDouble2S>.CurveREC( Ps, t, Slerp );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRomAVE

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveCatmullRomAVE.Segment( const i:Integer; const t:Double ) :TDouble2S;
var
   Ws :TDouble4D;
   Ps :TArray<TDouble2Sw>;
begin
     Ws := CatmullRom( t );

     SetLength( Ps, 4 );

     Ps[0] := TDouble2Sw.Create( _Poins[ i-1 ], Ws[1] );
     Ps[1] := TDouble2Sw.Create( _Poins[ i   ], Ws[2] );
     Ps[2] := TDouble2Sw.Create( _Poins[ i+1 ], Ws[3] );
     Ps[3] := TDouble2Sw.Create( _Poins[ i+2 ], Ws[4] );

     Result := TDouble2S( Sum1D( Ps ) );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■