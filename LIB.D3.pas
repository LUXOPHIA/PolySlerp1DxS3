unit LIB.D3;

interface //#################################################################### ■

uses LUX.D3;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 V A R I A B L E 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OrthVector

function OrthVector( const V_:TSingle3D ) :TSingle3D; overload;
function OrthVector( const V_:TDouble3D ) :TDouble3D; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Lerp

function Lerp( const V1_,V2_:TSingle3D ) :TSingle3D; overload;
function Lerp( const V1_,V2_:TDouble3D ) :TDouble3D; overload;

function Lerp( const V1_,V2_:TSingle3D; const T_:Single ) :TSingle3D; overload;
function Lerp( const V1_,V2_:TDouble3D; const T_:Double ) :TDouble3D; overload;

function Lerp( const V1_,V2_:TSingle3D; const W1_,W2_:Single ) :TSingle3D; overload;
function Lerp( const V1_,V2_:TDouble3D; const W1_,W2_:Double ) :TDouble3D; overload;

implementation //############################################################### ■

uses LUX;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OrthVector

function OrthVector( const V_:TSingle3D ) :TSingle3D;
var
   E :TSingle3D;
begin
     case MinI( Abs( V_.X ), Abs( V_.Y ), Abs( V_.Z ) ) of
       1: E := TDouble3D.IdentityX;
       2: E := TDouble3D.IdentityY;
       3: E := TDouble3D.IdentityZ;
     end;

     Result := CrossProduct( V_, E ).Unitor;
end;

function OrthVector( const V_:TDouble3D ) :TDouble3D;
var
   E :TDouble3D;
begin
     case MinI( Abs( V_.X ), Abs( V_.Y ), Abs( V_.Z ) ) of
       1: E := TDouble3D.IdentityX;
       2: E := TDouble3D.IdentityY;
       3: E := TDouble3D.IdentityZ;
     end;

     Result := CrossProduct( V_, E ).Unitor;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Lerp

function Lerp( const V1_,V2_:TSingle3D ) :TSingle3D;
begin
     Result := ( V1_ + V2_ ) / 2;
end;

function Lerp( const V1_,V2_:TDouble3D ) :TDouble3D;
begin
     Result := ( V1_ + V2_ ) / 2;
end;

//------------------------------------------------------------------------------

function Lerp( const V1_,V2_:TSingle3D; const T_:Single ) :TSingle3D; overload;
begin
     Result := ( V2_ - V1_ ) * T_ + V1_;
end;

function Lerp( const V1_,V2_:TDouble3D; const T_:Double ) :TDouble3D; overload;
begin
     Result := ( V2_ - V1_ ) * T_ + V1_;
end;

//------------------------------------------------------------------------------

function Lerp( const V1_,V2_:TSingle3D; const W1_,W2_:Single ) :TSingle3D;
var
   W :Single;
begin
     W := W1_ + W2_;

     if Abs( W ) < SINGLE_EPS3 then Result := Lerp( V1_, V2_ )
                               else Result := ( W1_ * V1_ + W2_ * V2_ ) / W;
end;

function Lerp( const V1_,V2_:TDouble3D; const W1_,W2_:Double ) :TDouble3D;
var
   W :Double;
begin
     W := W1_ + W2_;

     if Abs( W ) < DOUBLE_EPS3 then Result := Lerp( V1_, V2_ )
                               else Result := ( W1_ * V1_ + W2_ * V2_ ) / W;
end;

end. //######################################################################### ■