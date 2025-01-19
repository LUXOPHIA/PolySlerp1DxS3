unit LIB.Poins.S2;

interface //#################################################################### ■

uses LIB.S2,
     LIB.Poins;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     TPoins2S     = TPoins    <TDouble2S>;
     TLoopPoins2S = TLoopPoins<TDouble2S>;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyhedron4

     TPolyhedron4 = class( TLoopPoins2S )
     private
     protected
     public
       constructor Create;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyhedron6

     TPolyhedron6 = class( TLoopPoins2S )
     private
     protected
     public
       constructor Create;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyhedron8

     TPolyhedron8 = class( TLoopPoins2S )
     private
     protected
     public
       constructor Create;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyhedron12

     TPolyhedron12 = class( TLoopPoins2S )
     private
     protected
     public
       constructor Create;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyhedron20

     TPolyhedron20 = class( TLoopPoins2S )
     private
     protected
     public
       constructor Create;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 V A R I A B L E 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyhedron4

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPolyhedron4.Create;
begin
     inherited;

     PoinsN := 4;
     Poins[ 0 ] := TDouble2S.Create(  +1, -1, -1 ).Unitor;
     Poins[ 1 ] := TDouble2S.Create(  -1, +1, -1 ).Unitor;
     Poins[ 2 ] := TDouble2S.Create(  -1, -1, +1 ).Unitor;
     Poins[ 3 ] := TDouble2S.Create(  +1, +1, +1 ).Unitor;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyhedron6

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPolyhedron6.Create;
begin
     inherited;

     PoinsN := 8;
     Poins[ 0 ] := TDouble2S.Create(  -1, -1, -1 ).Unitor;
     Poins[ 1 ] := TDouble2S.Create(  +1, -1, -1 ).Unitor;
     Poins[ 2 ] := TDouble2S.Create(  +1, +1, -1 ).Unitor;
     Poins[ 3 ] := TDouble2S.Create(  -1, +1, -1 ).Unitor;
     Poins[ 4 ] := TDouble2S.Create(  -1, +1, +1 ).Unitor;
     Poins[ 5 ] := TDouble2S.Create(  +1, +1, +1 ).Unitor;
     Poins[ 6 ] := TDouble2S.Create(  +1, -1, +1 ).Unitor;
     Poins[ 7 ] := TDouble2S.Create(  -1, -1, +1 ).Unitor;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyhedron8

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPolyhedron8.Create;
begin
     inherited;

     PoinsN := 6;
     Poins[ 0 ] := TDouble2S.Create(  -1,  0,  0 ).Unitor;
     Poins[ 1 ] := TDouble2S.Create(   0, -1,  0 ).Unitor;
     Poins[ 2 ] := TDouble2S.Create(   0,  0, -1 ).Unitor;
     Poins[ 3 ] := TDouble2S.Create(  +1,  0,  0 ).Unitor;
     Poins[ 4 ] := TDouble2S.Create(   0, +1,  0 ).Unitor;
     Poins[ 5 ] := TDouble2S.Create(   0,  0, +1 ).Unitor;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyhedron12

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPolyhedron12.Create;
var
   G, R :Double;
begin
     inherited;

     G := (Sqrt(5)+1)/2;
     R := 2/(Sqrt(5)+1);

     PoinsN := 20;
     Poins[ 00 ] := TDouble2S.Create( -1, -1, -1 ).Unitor;
     Poins[ 01 ] := TDouble2S.Create( -R, -G,  0 ).Unitor;
     Poins[ 02 ] := TDouble2S.Create( -1, -1, +1 ).Unitor;
     Poins[ 03 ] := TDouble2S.Create( -G,  0, +R ).Unitor;
     Poins[ 04 ] := TDouble2S.Create( -G,  0, -R ).Unitor;
     Poins[ 05 ] := TDouble2S.Create( -1, +1, -1 ).Unitor;
     Poins[ 06 ] := TDouble2S.Create( -R, +G,  0 ).Unitor;
     Poins[ 07 ] := TDouble2S.Create( -1, +1, +1 ).Unitor;
     Poins[ 08 ] := TDouble2S.Create(  0, +R, +G ).Unitor;
     Poins[ 09 ] := TDouble2S.Create(  0, -R, +G ).Unitor;
     Poins[ 10 ] := TDouble2S.Create( +1, -1, +1 ).Unitor;
     Poins[ 11 ] := TDouble2S.Create( +R, -G,  0 ).Unitor;
     Poins[ 12 ] := TDouble2S.Create( +1, -1, -1 ).Unitor;
     Poins[ 13 ] := TDouble2S.Create( +G,  0, -R ).Unitor;
     Poins[ 14 ] := TDouble2S.Create( +G,  0, +R ).Unitor;
     Poins[ 15 ] := TDouble2S.Create( +1, +1, +1 ).Unitor;
     Poins[ 16 ] := TDouble2S.Create( +R, +G,  0 ).Unitor;
     Poins[ 17 ] := TDouble2S.Create( +1, +1, -1 ).Unitor;
     Poins[ 18 ] := TDouble2S.Create(  0, +R, -G ).Unitor;
     Poins[ 19 ] := TDouble2S.Create(  0, -R, -G ).Unitor;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyhedron20

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPolyhedron20.Create;
var
   G :Double;
begin
     inherited;

     G := (Sqrt(5)+1)/2;

     PoinsN := 12;
     Poins[ 00 ] := TDouble2S.Create(  0, -G, -1 ).Unitor;
     Poins[ 01 ] := TDouble2S.Create(  0, -G, +1 ).Unitor;
     Poins[ 02 ] := TDouble2S.Create( +1,  0, +G ).Unitor;
     Poins[ 03 ] := TDouble2S.Create( -1,  0, +G ).Unitor;
     Poins[ 04 ] := TDouble2S.Create( -G, -1,  0 ).Unitor;
     Poins[ 05 ] := TDouble2S.Create( -G, +1,  0 ).Unitor;
     Poins[ 06 ] := TDouble2S.Create(  0, +G, +1 ).Unitor;
     Poins[ 07 ] := TDouble2S.Create(  0, +G, -1 ).Unitor;
     Poins[ 08 ] := TDouble2S.Create( -1,  0, -G ).Unitor;
     Poins[ 09 ] := TDouble2S.Create( +1,  0, -G ).Unitor;
     Poins[ 10 ] := TDouble2S.Create( +G, +1,  0 ).Unitor;
     Poins[ 11 ] := TDouble2S.Create( +G, -1,  0 ).Unitor;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■