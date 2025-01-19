unit LIB.D4;

interface //#################################################################### ■

uses LUX.Quaternion;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 V A R I A B L E 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Lerp

function Lerp( const V1_,V2_:TSingleQ ) :TSingleQ; overload;
function Lerp( const V1_,V2_:TDoubleQ ) :TDoubleQ; overload;

function Lerp( const V1_,V2_:TSingleQ; const T_:Single ) :TSingleQ; overload;
function Lerp( const V1_,V2_:TDoubleQ; const T_:Double ) :TDoubleQ; overload;

function Lerp( const V1_,V2_:TSingleQ; const W1_,W2_:Single ) :TSingleQ; overload;
function Lerp( const V1_,V2_:TDoubleQ; const W1_,W2_:Double ) :TDoubleQ; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Lerp

function Lerp( const V1_,V2_:TSingleQ ) :TSingleQ;
begin
     Result := ( V1_ + V2_ ) / 2;
end;

function Lerp( const V1_,V2_:TDoubleQ ) :TDoubleQ;
begin
     Result := ( V1_ + V2_ ) / 2;
end;

//------------------------------------------------------------------------------

function Lerp( const V1_,V2_:TSingleQ; const T_:Single ) :TSingleQ; overload;
begin
     Result := ( V2_ - V1_ ) * T_ + V1_;
end;

function Lerp( const V1_,V2_:TDoubleQ; const T_:Double ) :TDoubleQ; overload;
begin
     Result := ( V2_ - V1_ ) * T_ + V1_;
end;

//------------------------------------------------------------------------------

function Lerp( const V1_,V2_:TSingleQ; const W1_,W2_:Single ) :TSingleQ;
begin
     Result := ( W1_ * V1_ + W2_ * V2_ ) / ( W1_ + W2_ );
end;

function Lerp( const V1_,V2_:TDoubleQ; const W1_,W2_:Double ) :TDoubleQ;
begin
     Result := ( W1_ * V1_ + W2_ * V2_ ) / ( W1_ + W2_ );
end;

end. //######################################################################### ■