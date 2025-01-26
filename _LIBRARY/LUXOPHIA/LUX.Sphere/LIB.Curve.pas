unit LIB.Curve;

interface //#################################################################### ■

uses LUX,
     LIB,
     LIB.Poins;

type //$$$$$$$$$&&$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     TAlgoFunc<_TPoin_> = function ( const i:Integer; const t:Double ) :_TPoin_ of object;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurve<_TPoin_>

     TCurve<_TPoin_> = class
     private
     protected
       type TWector     = TDoubleWector<_TPoin_>;
       type TBarycenter = TBarycenter  <_TPoin_>;
       type TPoins      = TPoins       <_TPoin_>;
     protected
       _Bary  :TBarycenter;
       _Poins :TPoins;
       ///// E V E N T
       _OnChange :TDelegates;
       ///// A C C E S S O R
       function GetBary :TBarycenter; virtual;
       procedure SetBary( const Bary_:TBarycenter ); virtual;
       procedure UpPoins( Sender_:TObject );
       function GetPoins :TPoins; virtual;
       procedure SetPoins( const Poins_:TPoins ); virtual;
       ///// M E T H O D
       function Segment( const I:Integer; const T:Double ) :_TPoin_; virtual; abstract;
     public
       constructor Create;
       destructor Destroy; Override;
       ///// P R O P E R T Y
       property Bary  :TBarycenter read GetBary  write SetBary ;
       property Poins :TPoins      read GetPoins write SetPoins;
       ///// M E T H O D
       function Value( const X_:Double ) :_TPoin_; virtual;
       ///// E V E N T
       property OnChange :TDelegates read _OnChange;
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

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 V A R I A B L E 】

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

//------------------------------------------------------------------------------

procedure TCurve<_TPoin_>.UpPoins( Sender_:TObject );
begin
     _OnChange.Run( Self );
end;

function TCurve<_TPoin_>.GetPoins :TPoins;
begin
     Result := _Poins;
end;

procedure TCurve<_TPoin_>.SetPoins( const Poins_:TPoins );
begin
     if _Poins = Poins_ then Exit;

     if Assigned( _Poins ) then _Poins.OnChange.Del( UpPoins );

     _Poins := Poins_;

     if Assigned( _Poins ) then _Poins.OnChange.Add( UpPoins );

     UpPoins( Self );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCurve<_TPoin_>.Create;
begin
     inherited;

     Bary  := nil;
     Poins := nil;
end;

destructor TCurve<_TPoin_>.Destroy;
begin
     Poins := nil;

     inherited;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TCurve<_TPoin_>.Value( const X_:Double ) :_TPoin_;
var
   i :Integer;
   t :Double;
begin
     i := Floor( X_ );  t := X_ - I;

     Result := Segment( i, t );
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