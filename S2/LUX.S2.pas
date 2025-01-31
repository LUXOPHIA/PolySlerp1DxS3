unit LUX.S2;

interface //#################################################################### ■

uses LUX.D3,
     LIB;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     TSingle2S = TSingle3D;
     TDouble2S = TDouble3D;

     TSingleW2S = TSingleWector<TSingle2S>;
     TDoubleW2S = TDoubleWector<TDouble2S>;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle2S

     HSingle2S = record helper for TSingle2S
     private
       ///// A C C E S S O R
       function GetUnitor :TSingle2S;
     public
       ///// P R O P E R T Y
       property Unitor :TSingle2S read GetUnitor;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble2S

     HDouble2S = record helper for TDouble2S
     private
       ///// A C C E S S O R
       function GetUnitor :TDouble2S;
     public
       ///// P R O P E R T Y
       property Unitor :TDouble2S read GetUnitor;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleW2S

     HSingleW2S = record helper for TSingleW2S
     private
       ///// A C C E S S O R
       function GetUnitor :TSingleW2S;
     public
       ///// P R O P E R T Y
       property Unitor :TSingleW2S read GetUnitor;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleW2S

     HDoubleW2S = record helper for TDoubleW2S
     private
       ///// A C C E S S O R
       function GetUnitor :TDoubleW2S;
     public
       ///// P R O P E R T Y
       property Unitor :TDoubleW2S read GetUnitor;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses LUX;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle2S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function HSingle2S.GetUnitor :TSingle2S;
var
   L :Single;
begin
     L := Size;

     if Abs( L ) < SINGLE_EPS3 then Result := 0 else Result := Self / L;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble2S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function HDouble2S.GetUnitor :TDouble2S;
var
   L :Double;
begin
     L := Size;

     if Abs( L ) < DOUBLE_EPS3 then Result := 0 else Result := Self / L;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleW2S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function HSingleW2S.GetUnitor :TSingleW2S;
var
   L :Single;
begin
     L := v.Size;

     if Abs( L ) < SINGLE_EPS3 then Result := TSingleW2S.Create( 0, 0 )
                               else Result := TSingleW2S.Create( v / L, w );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleW2S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function HDoubleW2S.GetUnitor :TDoubleW2S;
var
   L :Double;
begin
     L := v.Size;

     if Abs( L ) < DOUBLE_EPS3 then Result := TDoubleW2S.Create( 0, 0 )
                               else Result := TDoubleW2S.Create( v / L, w );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■
