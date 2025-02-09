unit LUX.S3.Data.Grid.D1;

interface //#################################################################### ■

uses LUX.Data.Grid.D1,
     LUX.S2.Data.Grid.D1,
     LUX.S3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     TPoins3S     = TPoins    <TDouble3S>;
     TLoopPoins3S = TLoopPoins<TDouble3S>;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyPoins3S

     TPolyPoins3S = class( TLoopPoins3S )
     private
       ///// M E T H O D
       function BSpline4( P1,P2,P3,P4,P5:TDouble3S ) :TDouble3S;
     protected
       _Anchs :TLoopPoins3S;
       _Twist :Double;
       ///// A C C E S S O R
       function GetTwist :Double; virtual;
       procedure SetTwist( const Twist_:Double ); virtual;
       ///// M E T H O D
       procedure MakeAnchs( const Poins2S_:TLoopPoins2S );
       procedure MakePoins; override;
     public
       constructor Create;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property CellsN                    :Integer   read GetCellsN               ;
       property PoinsN                    :Integer   read GetPoinsN               ;
       property Poins[ const I_:Integer ] :TDouble3S read GetPoins                ; default;
       property Twist                     :Double    read GetTwist  write SetTwist;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyPoins3S04

     TPolyPoins3S04 = class( TPolyPoins3S )
     private
     protected
     public
       constructor Create;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyPoins3S06

     TPolyPoins3S06 = class( TPolyPoins3S )
     private
     protected
     public
       constructor Create;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyPoins3S08

     TPolyPoins3S08 = class( TPolyPoins3S )
     private
     protected
     public
       constructor Create;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyPoins3S12

     TPolyPoins3S12 = class( TPolyPoins3S )
     private
     protected
     public
       constructor Create;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyPoins3S20

     TPolyPoins3S20 = class( TPolyPoins3S )
     private
     protected
     public
       constructor Create;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 V A R I A B L E 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.Math,
     LUX,
     LUX.D3,
     LUX.Quaternion,
     LUX.S3.Bary.Slerp;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyPoins3S<_TPoins_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////////// M E T H O D

//    |-----+-----+--|--+-----+-----|    :Basis Function
//                0-----1                :t
// +-----+-----+--===+===--+-----+-----+ :Poins
// 0    [1]   [2]   [3]   [4]   [5]    6

function TPolyPoins3S.BSpline4( P1,P2,P3,P4,P5:TDouble3S ) :TDouble3S;  // DegN = 4, t = 1/2
begin
     P1 := Slerp( P1, P2, 7/8 );
     P2 := Slerp( P2, P3, 5/8 );
     P3 := Slerp( P3, P4, 3/8 );
     P4 := Slerp( P4, P5, 1/8 );

     P1 := Slerp( P1, P2, 5/6 );
     P2 := Slerp( P2, P3, 3/6 );
     P3 := Slerp( P3, P4, 1/6 );

     P1 := Slerp( P1, P2, 3/4 );
     P2 := Slerp( P2, P3, 1/4 );

     P1 := Slerp( P1, P2, 1/2 );

     Result := P1;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TPolyPoins3S.GetTwist :Double;
begin
     Result := Twist;
end;

procedure TPolyPoins3S.SetTwist( const Twist_:Double );
begin
     if _Twist = Twist_ then Exit;

     _Twist := Twist_;  upPoins := True;  _OnChange.Run( Self );
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TPolyPoins3S.MakeAnchs( const Poins2S_:TLoopPoins2S );
var
   Ps :TArray<TDouble3S>;
   I, N :Integer;
   P :TDouble3S;
   B :Boolean;
begin
     SetPoinsN( Poins2S_.PoinsN );

     _Anchs.PoinsN := PoinsN;

     for I := 0 to PoinsN-1 do _Anchs[ I ] := TDouble3S.Rotate( TDouble3D.IdentityY, Poins2S_[ I ] )
                                            * TDouble3S.Rotate( TDouble3D.IdentityY, Pi2 * Random );

     SetLength( Ps, PoinsN );
     for N := 1 to 1000000 do
     begin
          for I := 0 to PoinsN-1 do
          begin
               P := BSpline4( _Anchs[ I-2 ], _Anchs[ I-1 ], _Anchs[ I ], _Anchs[ I+1 ], _Anchs[ I+2 ] );

               Ps[ I ] := TDouble3S.Rotate( P.Trans( TDouble3D.IdentityY ), Poins2S_[ I ] ) * P;
          end;

          B := True;
          for I := 0 to PoinsN-1 do
          begin
               B := B and ( 1-DOUBLE_EPS3 < DotProduct( _Anchs[ I ], Ps[ I ] ) );

               _Anchs[ I ] := Ps[ I ];
          end;
          if B then Break;
     end;

     Poins2S_.Free;
end;

procedure TPolyPoins3S.MakePoins;
var
   I :Integer;
   S :Double;
begin
     for I := 0 to PoinsN-1 do
     begin
          S := I mod 2 * 2 - 1;

          _Poins[ I ] := _Anchs[ I ] * TDouble3S.Rotate( TDouble3D.IdentityY, S * _Twist );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPolyPoins3S.Create;
begin
     inherited;

     _Anchs := TLoopPoins3S.Create;

     Twist := 0;
end;

destructor TPolyPoins3S.Destroy;
begin
     _Anchs.Free;

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyPoins3S04

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPolyPoins3S04.Create;
begin
     inherited;

     MakeAnchs( TPolyPoins2S04.Create );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyPoins3S06

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPolyPoins3S06.Create;
begin
     inherited;

     MakeAnchs( TPolyPoins2S06.Create );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyPoins3S08

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPolyPoins3S08.Create;
begin
     inherited;

     MakeAnchs( TPolyPoins2S08.Create );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyPoins3S12

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPolyPoins3S12.Create;
begin
     inherited;

     MakeAnchs( TPolyPoins2S12.Create );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyPoins3S20

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPolyPoins3S20.Create;
begin
     inherited;

     MakeAnchs( TPolyPoins2S20.Create );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■