unit LUX.S3;

interface //#################################################################### ■

uses LIB,
     LUX.Quaternion;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     TSingle3S = TSingleQ;
     TDouble3S = TDoubleQ;

     TSingleW3S = TSIngleWector<TSingle3S>;
     TDoubleW3S = TDoubleWector<TDouble3S>;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle2S

     HSingle3S = record helper for TSingle3S
     private
       ///// A C C E S S O R
       function GetUnitor :TSingle3S;
     public
       ///// P R O P E R T Y
       property Unitor :TSingle3S read GetUnitor;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble3S

     HDouble3S = record helper for TDouble3S
     private
       ///// A C C E S S O R
       function GetUnitor :TDouble3S;
     public
       ///// P R O P E R T Y
       property Unitor :TDouble3S read GetUnitor;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleW3S

     HSingleW3S = record helper for TSingleW3S
     private
       ///// A C C E S S O R
       function GetUnitor :TSingleW3S;
     public
       ///// P R O P E R T Y
       property Unitor :TSingleW3S read GetUnitor;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleW3S

     HDoubleW3S = record helper for TDoubleW3S
     private
       ///// A C C E S S O R
       function GetUnitor :TDoubleW3S;
     public
       ///// P R O P E R T Y
       property Unitor :TDoubleW3S read GetUnitor;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses LUX;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle3S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function HSingle3S.GetUnitor :TSingle3S;
var
   L :Single;
begin
     L := Size;

     if L < SINGLE_EPS3 then Result := 0 else Result := Self / L;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble3S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function HDouble3S.GetUnitor :TDouble3S;
var
   L :Double;
begin
     L := Size;

     if L < DOUBLE_EPS3 then Result := 0 else Result := Self / L;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleW3S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function HSingleW3S.GetUnitor :TSingleW3S;
var
   L :Single;
begin
     L := v.Size;

     if L < SINGLE_EPS3 then Result := TSingleW3S.Create( 0, 0 )
                        else Result := TSingleW3S.Create( v / L, w );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleW3S

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function HDoubleW3S.GetUnitor :TDoubleW3S;
var
   L :Double;
begin
     L := v.Size;

     if L < DOUBLE_EPS3 then Result := TDoubleW3S.Create( 0, 0 )
                        else Result := TDoubleW3S.Create( v / L, w );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■