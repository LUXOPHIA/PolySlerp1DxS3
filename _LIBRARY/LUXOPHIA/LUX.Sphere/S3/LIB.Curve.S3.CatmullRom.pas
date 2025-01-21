unit LIB.Curve.S3.CatmullRom;

interface //#################################################################### ■

uses LIB.S3,
     LIB.Curve.S3;

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

uses LUX.Curve.CatmullRom;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRom

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRomREC

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveCatmullRomREC.Segment( const i:Integer; const t:Double ) :TDouble3S;
var
   P0, P1, P2, P3,
   P01, P12, P23,
   P012, P123 :TDouble3S;
begin
     P0 := _Poins[ i-1 ];
     P1 := _Poins[ i   ];
     P2 := _Poins[ i+1 ];
     P3 := _Poins[ i+2 ];

     P01 := Slerp( P0, P1, t + 1 );
     P12 := Slerp( P1, P2, t     );
     P23 := Slerp( P2, P3, t - 1 );

     P012 := Slerp( P01, P12, ( t + 1 ) / 2 );
     P123 := Slerp( P12, P23,   t       / 2 );

     Result := Slerp( P012, P123, t );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveCatmullRomPOL

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveCatmullRomPOL.Segment( const i:Integer; const t:Double ) :TDouble3S;
var
   P0, P1, P2, P3 :TDouble3S;
   W0, W1, W2, W3 :Double;
begin
     P0 := _Poins[ i-1 ];
     P1 := _Poins[ i   ];
     P2 := _Poins[ i+1 ];
     P3 := _Poins[ i+2 ];

     W0 := ( ( -0.5 * t + 1.0 ) * t - 0.5 ) * t      ;
     W1 := ( ( +1.5 * t - 2.5 ) * t       ) * t + 1.0;
     W2 := ( ( -1.5 * t + 2.0 ) * t + 0.5 ) * t      ;
     W3 := ( ( +0.5 * t - 0.5 ) * t       ) * t      ;

     Result := Sum1D( [ TDouble3Sw.Create( P0, W0 ),
                        TDouble3Sw.Create( P1, W1 ),
                        TDouble3Sw.Create( P2, W2 ),
                        TDouble3Sw.Create( P3, W3 ) ] ).v;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■