unit LUX.Poins.S3;

interface //#################################################################### ■

uses LUX.S3,
     LIB.Poins,
     LUX.Poins.S2;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     TPoins3S     = TPoins    <TDouble3S>;
     TLoopPoins3S = TLoopPoins<TDouble3S>;

     TPolyPoins3S<_TPoins_:constructor,TLoopPoins2S> = class;

     TPolyPoins3S04 = TPolyPoins3S<TPolyPoins2S04>;
     TPolyPoins3S06 = TPolyPoins3S<TPolyPoins2S06>;
     TPolyPoins3S08 = TPolyPoins3S<TPolyPoins2S08>;
     TPolyPoins3S12 = TPolyPoins3S<TPolyPoins2S12>;
     TPolyPoins3S20 = TPolyPoins3S<TPolyPoins2S20>;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPolyPoins3S<_TPoins_>

     TPolyPoins3S<_TPoins_:constructor,TLoopPoins2S> = class( TLoopPoins3S )
     private
       ///// M E T H O D
       function BSpline4( P1,P2,P3,P4,P5:TDouble3S ) :TDouble3S;
     protected
       _Poins2S :_TPoins_;
       ///// M E T H O D
       procedure MakePoins; override;
     public
       constructor Create;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property CellsN                    :Integer    read GetCellsN;
       property PoinsN                    :Integer    read GetPoinsN;
       property Poins[ const I_:Integer ] :TDouble3S  read GetPoins ; default;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 V A R I A B L E 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses LUX,
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

function TPolyPoins3S<_TPoins_>.BSpline4( P1,P2,P3,P4,P5:TDouble3S ) :TDouble3S;  // DegN = 4, t = 1/2
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

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TPolyPoins3S<_TPoins_>.MakePoins;
var
   Ps :TArray<TDouble3S>;
   I, N :Integer;
   P :TDouble3S;
   B :Boolean;
begin
     SetLength( Ps, PoinsN );
     for I := 0 to PoinsN-1 do _Poins[ I ] := TDouble3S.Rotate( TDouble3D.IdentityY, _Poins2S.Poins[ I ] )
                                            * TDouble3S.Rotate( TDouble3D.IdentityY, Pi2 * Random );

     for N := 1 to 1000000 do
     begin
          for I := 0 to PoinsN-1 do
          begin
               P := BSpline4( Poins[ I-2 ], Poins[ I-1 ], Poins[ I ], Poins[ I+1 ], Poins[ I+2 ] );

               Ps[ I ] := TDouble3S.Rotate( P.Trans( TDouble3D.IdentityY ), _Poins2S.Poins[ I ] ) * P;
          end;

          B := True;
          for I := 0 to PoinsN-1 do
          begin
               B := B and ( 1-DOUBLE_EPS3 < DotProduct( _Poins[ I ], Ps[ I ] ) );

               _Poins[ I ] := Ps[ I ];
          end;
          if B then Break;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPolyPoins3S<_TPoins_>.Create;
begin
     inherited;

     _Poins2S := _TPoins_.Create;

     SetPoinsN( _Poins2S.PoinsN );
end;

destructor TPolyPoins3S<_TPoins_>.Destroy;
begin
     _Poins2S.Free;

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■