unit LUX.S2.Curve.D2.PolySlerp;

interface //#################################################################### ■

uses LUX,
     LUX.S2,
     LUX.S2.Curve;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 V A R I A B L E 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function PolySlerp( V1_,V2_,V3_:TSingle2S ) :TSingle2S; overload;
function PolySlerp( V1_,V2_,V3_:TDouble2S ) :TDouble2S; overload;

function PolySlerp( V1_,V2_,V3_:TSingle2S; W1_,W2_,W3_:Single ) :TSingle2S; overload;
function PolySlerp( V1_,V2_,V3_:TDouble2S; W1_,W2_,W3_:Double ) :TDouble2S; overload;

function PolySlerp( V1_,V2_,V3_:TSingle2Sw ) :TSingle2Sw; overload;
function PolySlerp( V1_,V2_,V3_:TDouble2Sw ) :TDouble2Sw; overload;

implementation //############################################################### ■

uses LUX.S2.Curve.Lerp,
     LUX.S2.Curve.Glerp,
     LUX.S2.Curve.Slerp;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PolySlerp

function PolySlerp( V1_,V2_,V3_:TSingle2S ) :TSingle2S;
var
   N :Integer;
   V23, V31, V12 :TSingle2S;
begin
     for N := 1 to 10000 do
     begin
          Result := Lerp( V1_, V2_, V3_ );

          if 1-SINGLE_EPS3 < Result.Size2 then Break;

          V23 := Glerp( V2_, V3_ );
          V31 := Glerp( V3_, V1_ );
          V12 := Glerp( V1_, V2_ );

          V1_ := V23;  V2_ := V31;  V3_ := V12;
     end;
end;

function PolySlerp( V1_,V2_,V3_:TDouble2S ) :TDouble2S;
const
     DOUBLE_EPS9 = DOUBLE_EPS * 1E9;
var
   N :Integer;
   V23, V31, V12 :TDouble2S;
begin
     for N := 1 to 10000 do
     begin
          Result := Lerp( V1_, V2_, V3_ );

          if 1-DOUBLE_EPS9 < Result.Size2 then Break;

          V23 := Glerp( V2_, V3_ );
          V31 := Glerp( V3_, V1_ );
          V12 := Glerp( V1_, V2_ );

          V1_ := V23;  V2_ := V31;  V3_ := V12;
     end;
end;

//------------------------------------------------------------------------------

function PolySlerp( V1_,V2_,V3_:TSingle2S; W1_,W2_,W3_:Single ) :TSingle2S;
var
   N :Integer;
   V23, V31, V12 :TSingle2S;
   W23, W31, W12 :Single;
begin
     for N := 1 to 10000 do
     begin
          Result := Lerp( V1_, V2_, V3_, W1_, W2_, W3_ );

          if 1-SINGLE_EPS3 < Result.Size2 then Break;

          V23 := Slerp( V2_, V3_, W2_, W3_ );  W23 := ( W2_ + W3_ ) / 2;
          V31 := Slerp( V3_, V1_, W3_, W1_ );  W31 := ( W3_ + W1_ ) / 2;
          V12 := Slerp( V1_, V2_, W1_, W2_ );  W12 := ( W1_ + W2_ ) / 2;

          V1_ := V23;  V2_ := V31;  V3_ := V12;
          W1_ := W23;  W2_ := W31;  W3_ := W12;
     end;
end;

function PolySlerp( V1_,V2_,V3_:TDouble2S; W1_,W2_,W3_:Double ) :TDouble2S;
const
     DOUBLE_EPS9 = DOUBLE_EPS * 1E9;
var
   N :Integer;
   V23, V31, V12 :TDouble2S;
   W23, W31, W12 :Double;
begin
     for N := 1 to 10000 do
     begin
          Result := Lerp( V1_, V2_, V3_, W1_, W2_, W3_ );

          if 1-DOUBLE_EPS9 < Result.Size2 then Break;

          V23 := Slerp( V2_, V3_, W2_, W3_ );  W23 := ( W2_ + W3_ ) / 2;
          V31 := Slerp( V3_, V1_, W3_, W1_ );  W31 := ( W3_ + W1_ ) / 2;
          V12 := Slerp( V1_, V2_, W1_, W2_ );  W12 := ( W1_ + W2_ ) / 2;

          V1_ := V23;  V2_ := V31;  V3_ := V12;
          W1_ := W23;  W2_ := W31;  W3_ := W12;
     end;
end;

//------------------------------------------------------------------------------

function PolySlerp( V1_,V2_,V3_:TSingle2Sw ) :TSingle2Sw;
var
   N :Integer;
   V23, V31, V12 :TSingle2Sw;
begin
     for N := 1 to 10000 do
     begin
          Result := Lerp( V1_, V2_, V3_ );

          if 1-SINGLE_EPS3 < Result.v.Size2 then Break;

          V23 := ( V2_ + V3_ ) / 2;
          V31 := ( V3_ + V1_ ) / 2;
          V12 := ( V1_ + V2_ ) / 2;

          V1_ := V23;  V2_ := V31;  V3_ := V12;
     end;
end;

function PolySlerp( V1_,V2_,V3_:TDouble2Sw ) :TDouble2Sw;
const
     DOUBLE_EPS9 = DOUBLE_EPS * 1E9;
var
   N :Integer;
   V23, V31, V12 :TDouble2Sw;
begin
     for N := 1 to 10000 do
     begin
          Result := Lerp( V1_, V2_, V3_ );

          if 1-DOUBLE_EPS9 < Result.v.Size2 then Break;

          V23 := ( V2_ + V3_ ) / 2;
          V31 := ( V3_ + V1_ ) / 2;
          V12 := ( V1_ + V2_ ) / 2;

          V1_ := V23;  V2_ := V31;  V3_ := V12;
     end;
end;

end. //######################################################################### ■