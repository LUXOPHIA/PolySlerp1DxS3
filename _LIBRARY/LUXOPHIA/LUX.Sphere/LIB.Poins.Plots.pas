unit LIB.Poins.Plots;

interface //#################################################################### ■

uses LIB.Poins,
     LIB.Curve;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPlots0<_TPoin_>

     TPlots0<_TPoin_> = class( TPoins<_TPoin_> )
     private
     protected
       _Curve    :TCurve<_TPoin_>;
       _EdgesN   :Integer;
       _Edges    :TArray<Double>;  upEdges :Boolean;
       _PlotSize :Double;
       ///// A C C E S S O R
       function GetPoinsN :Integer; override;
       procedure UpCurve( Sender_:TObject );
       function GetCurve :TCurve<_TPoin_>; virtual;
       procedure SetCurve( const Curve_:TCurve<_TPoin_> ); virtual;
       function GetEdgesN :Integer; virtual;
       procedure SetEdgesN( const EdgesN_:Integer ); virtual;
       function GetEdges( const I_:Integer ) :Double; virtual;
       function GetArcLen :Double; virtual;
       function GetPlotSize :Double; virtual;
       procedure SetPlotSize( const PlotSize_:Double ); virtual;
       ///// M E T H O D
       function Distance( const P0_,P1_:_TPoin_ ) :Double; virtual; abstract;
       procedure InitEdges; virtual;
       procedure MakeEdges; virtual;
       procedure MakePoins; override;
     public
       constructor Create( const Curve_:TCurve<_TPoin_> );
       destructor Destroy; Override;
       ///// P R O P E R T Y
       property CellsN                    :Integer         read GetCellsN                    ;
       property PoinsN                    :Integer         read GetPoinsN                    ;
       property Poins[ const I_:Integer ] :_TPoin_         read GetPoins                     ; default;
       property Curve                     :TCurve<_TPoin_> read GetCurve    write SetCurve   ;
       property EdgesN                    :Integer         read GetEdgesN   write SetEdgesN  ;
       property Edges[ const I_:Integer ] :Double          read GetEdges                     ;
       property ArcLen                    :Double          read GetArcLen                    ;
       property PlotSize                  :Double          read GetPlotSize write SetPlotSize;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPlots1<_TPoin_>

     TPlots1<_TPoin_> = class( TPlots0<_TPoin_> )
     private
     protected
       ///// A C C E S S O R
       function GetPoinsN :Integer; override;
       ///// M E T H O D
       procedure MakePoins; override;
     public
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 V A R I A B L E 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPlots0<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TPlots0<_TPoin_>.GetPoinsN :Integer;
begin
     Result := Round( ArcLen / PlotSize );
end;

//------------------------------------------------------------------------------

procedure TPlots0<_TPoin_>.UpCurve( Sender_:TObject );
begin
     upEdges := True;
     upPoins := True;

     _OnChange.Run( Self );
end;

function TPlots0<_TPoin_>.GetCurve :TCurve<_TPoin_>;
begin
     Result := _Curve;
end;

procedure TPlots0<_TPoin_>.SetCurve( const Curve_:TCurve<_TPoin_> );
begin
     if Assigned( _Curve ) then _Curve.OnChange.Del( UpCurve );

     _Curve := Curve_;

     if Assigned( _Curve ) then _Curve.OnChange.Add( UpCurve );

     UpCurve( Self );
end;

//------------------------------------------------------------------------------

function TPlots0<_TPoin_>.GetEdgesN :Integer;
begin
     Result := _EdgesN;
end;

procedure TPlots0<_TPoin_>.SetEdgesN( const EdgesN_:Integer );
begin
     _EdgesN := EdgesN_;  UpCurve( Self );
end;

//------------------------------------------------------------------------------

function TPlots0<_TPoin_>.GetEdges( const I_:Integer ) :Double;
begin
     InitEdges;

     Result := _Edges[ I_ ];
end;

//------------------------------------------------------------------------------

function TPlots0<_TPoin_>.GetArcLen :Double;
var
   I :Integer;
begin
     Result := 0;
     for I := 0 to EdgesN-1 do Result := Result + Edges[ I ];
end;

//------------------------------------------------------------------------------

function TPlots0<_TPoin_>.GetPlotSize :Double;
begin
     Result := _PlotSize;
end;

procedure TPlots0<_TPoin_>.SetPlotSize( const PlotSize_:Double );
begin
     _PlotSize := PlotSize_;  upPoins := True;  _OnChange.Run( Self );
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TPlots0<_TPoin_>.InitEdges;
begin
     if upEdges then
     begin
          upEdges := False;

          SetLength( _Edges, EdgesN );

          MakeEdges;
     end;
end;

procedure TPlots0<_TPoin_>.MakeEdges;
var
   T, Td :Double;
   P0, P1 :_TPoin_;
   J :Integer;
begin
     Td := _Curve.Poins.CellsN / EdgesN;
     T := 0;  P0 := _Curve.Value( T );
     for J := 0 to EdgesN-1 do
     begin
          T := T + Td;  P1 := _Curve.Value( T );

          _Edges[ J ] := Distance( P0, P1 );

          P0 := P1;
     end;
end;

//------------------------------------------------------------------------------

//     1       2       3       4       5       6       7
//  |--+===|===+===|===+===|===+===|===+===|===+===|===+--| = ArcLen
//     *   1   *   2   *   3   *   4   *   5   *   6   *    = CellsN
//     1       2       3       4       5       6       7    = PoinsN

procedure TPlots0<_TPoin_>.MakePoins;
var
   I, J :Integer;
   A, T, Td :Double;
begin
     Td := _Curve.Poins.CellsN / EdgesN;

     A := ( ArcLen - PlotSize * CellsN ) / 2;
     J := 0;
     for I := 0 to CellsN do
     begin
          while ( Edges[ J ] < A ) and ( J < EdgesN-1 )  do
          begin
               A := A - Edges[ J ];  Inc( J );
          end;

          T := A / Edges[ J ];

          _Poins[ I ] := _Curve.Value( Td * ( J + T ) );

          A := A + PlotSize;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPlots0<_TPoin_>.Create( const Curve_:TCurve<_TPoin_> );
begin
     inherited Create;

     Curve    := Curve_;
     EdgesN   := 1000;
     PlotSize := 1;
end;

destructor TPlots0<_TPoin_>.Destroy;
begin
     Curve := nil;

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPlots1<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TPlots1<_TPoin_>.GetPoinsN :Integer;
begin
     Result := Round( ArcLen / PlotSize ) - 1;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

//     1       2       3       4       5       6       7
//  |--+---|===+===|===+===|===+===|===+===|===+===|---+--| = ArcLen
//         *   1   *   2   *   3   *   4   *   5   *        = CellsN
//         1       2       3       4       5       6        = PoinsN

procedure TPlots1<_TPoin_>.MakePoins;
var
   I, J :Integer;
   A, T, Td :Double;
begin
     Td := _Curve.Poins.CellsN / EdgesN;

     A := ( ArcLen - PlotSize * CellsN ) / 2;
     J := 0;
     for I := 0 to CellsN do
     begin
          while ( Edges[ J ] < A ) and ( J < EdgesN-1 )  do
          begin
               A := A - Edges[ J ];  Inc( J );
          end;

          T := A / Edges[ J ];

          _Poins[ I ] := _Curve.Value( Td * ( J + T ) );

          A := A + PlotSize;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■