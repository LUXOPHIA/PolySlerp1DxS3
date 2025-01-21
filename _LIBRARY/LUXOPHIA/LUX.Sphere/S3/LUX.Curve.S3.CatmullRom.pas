unit LUX.Curve.S3.CatmullRom;

interface //#################################################################### ■

uses LUX.S3,
     LUX.Curve.S3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRom

     TCurveCatmullRom = class( TCurve3S )
     private
     protected
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRomREC

     TCurveCatmullRomREC = class( TCurveCatmullRom )
     private
     protected
       ///// M E T H O D
       function Segment( const i:Integer; const t:Double ) :TDouble3S; override;
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRomPOL

     TCurveCatmullRomPOL = class( TCurveCatmullRom )
     private
     protected
       ///// M E T H O D
       function Segment( const i:Integer; const t:Double ) :TDouble3S; override;
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

function TCurveCatmullRomREC.Segment( const i:Integer; const t:Double ) :TDouble3S;
var
   P0, P1, P2, P3 :TDouble3S;
begin
     P0 := _Poins[ i-1 ];
     P1 := _Poins[ i   ];
     P2 := _Poins[ i+1 ];
     P3 := _Poins[ i+2 ];

     Result := TDoubleCatmullRom<TDouble3S>.CurveREC( P0,P1,P2,P3, t, Slerp );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRomPOL

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveCatmullRomPOL.Segment( const i:Integer; const t:Double ) :TDouble3S;
var
   Ws :TDouble4D;
   P1, P2, P3, P4 :TDouble3Sw;
begin
     Ws := CatmullRom( t );

     P1 := TDouble3Sw.Create( _Poins[ i-1 ], Ws[1] );
     P2 := TDouble3Sw.Create( _Poins[ i   ], Ws[2] );
     P3 := TDouble3Sw.Create( _Poins[ i+1 ], Ws[3] );
     P4 := TDouble3Sw.Create( _Poins[ i+2 ], Ws[4] );

     Result := TDouble3S( Sum1D( [ P1, P2, P3, P4 ] ) );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■