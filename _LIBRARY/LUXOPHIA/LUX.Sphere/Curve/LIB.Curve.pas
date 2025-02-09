unit LIB.Curve;

interface //#################################################################### ■

uses LUX,
     LIB,
     LUX.Data.Grid.D1,
     LUX.Curve,
     LUX.Curve.Data.Grid.D1;

type //$$$$$$$$$&&$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     TAlgoFunc<_TPoin_> = function ( const i:Integer; const t:Double ) :_TPoin_ of object;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurve<_TPoin_>

     TCurve<_TPoin_> = class( LUX.Curve.Data.Grid.D1.TCurve<_TPoin_> )
     private
     protected
       type TWector     = TDoubleWector<_TPoin_>;
       type TBarycenter = TBarycenter  <_TPoin_>;
       type TPoins      = TPoins       <_TPoin_>;
     protected
       _Bary :TBarycenter;
       ///// A C C E S S O R
       function GetBary :TBarycenter; virtual;
       procedure SetBary( const Bary_:TBarycenter ); virtual;
     public
       constructor Create;
       destructor Destroy; Override;
       ///// P R O P E R T Y
       property Bary :TBarycenter read GetBary write SetBary;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveAlgo<_TPoin_>

     TCurveAlgo<_TPoin_> = class( TCurve<_TPoin_> )
     private
     protected
       type TAlgoFunc = TAlgoFunc<_TPoin_>;
     protected
       _Algos  :TArray<TAlgoFunc>;
       _AlgoID :Integer;
       ///// A C C E S S O R
       function GetAlgosN :Integer; virtual;
       procedure SetAlgosN( const AlgosN_:Integer ); virtual;
       function GetAlgoID :Integer; virtual;
       procedure SetAlgoID( const AlgoID_:Integer ); virtual;
       ///// M E T H O D
       function Segment( const i:Integer; const t:Double ) :_TPoin_; override;
     public
       constructor Create;
       ///// P R O P E R T Y
       property AlgosN :Integer read GetAlgosN write SetAlgosN;
       property AlgoID :Integer read GetAlgoID write SetAlgoID;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurve<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TCurve<_TPoin_>.GetBary :TBarycenter;
begin
     Result := _Bary;
end;

procedure TCurve<_TPoin_>.SetBary( const Bary_:TBarycenter );
begin
     if _Bary = Bary_ then Exit;

     _Bary := Bary_;  _OnChange.Run( Self );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCurve<_TPoin_>.Create;
begin
     inherited;

     Bary := nil;
end;

destructor TCurve<_TPoin_>.Destroy;
begin
     Bary := nil;

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurveAlgo<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TCurveAlgo<_TPoin_>.GetAlgosN :Integer;
begin
     Result := Length( _Algos );
end;

procedure TCurveAlgo<_TPoin_>.SetAlgosN( const AlgosN_:Integer );
begin
     if AlgosN = AlgosN_ then Exit;

     SetLength( _Algos, AlgosN_ );  _OnChange.Run( Self );
end;

function TCurveAlgo<_TPoin_>.GetAlgoID :Integer;
begin
     Result := _AlgoID;
end;

procedure TCurveAlgo<_TPoin_>.SetAlgoID( const AlgoID_:Integer );
begin
     if _AlgoID = AlgoID_ then Exit;

     _AlgoID := AlgoID_;  _OnChange.Run( Self );
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurveAlgo<_TPoin_>.Segment( const i:Integer; const t:Double ) :_TPoin_;
begin
     Result := _Algos[ AlgoID ]( i, t );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCurveAlgo<_TPoin_>.Create;
begin
     inherited;

     AlgoID := 0;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■