unit LIB.Curve;

interface //#################################################################### ■

uses LUX,
     LIB.Poins;

type //$$$$$$$$$&&$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     TSingleLerp<_TValue_> = reference to function ( const P0_,P1_:_TValue_; const T_:Single ) :_TValue_;
     TDoubleLerp<_TValue_> = reference to function ( const P0_,P1_:_TValue_; const T_:Double ) :_TValue_;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurve<_TPoin_>

     TCurve<_TPoin_> = class
     private
     protected
       _Poins :TPoins<_TPoin_>;
       ///// E V E N T
       _OnChange :TDelegates;
       ///// A C C E S S O R
       procedure UpPoins( Sender_:TObject );
       function GetPoins :TPoins<_TPoin_>; virtual;
       procedure SetPoins( const Poins_:TPoins<_TPoin_> ); virtual;
       ///// M E T H O D
       function Segment( const I:Integer; const T:Double ) :_TPoin_; virtual; abstract;
     public
       constructor Create( const Poins_:TPoins<_TPoin_> );
       destructor Destroy; Override;
       ///// P R O P E R T Y
       property Poins :TPoins<_TPoin_> read GetPoins write SetPoins;
       ///// M E T H O D
       function Value( const X_:Double ) :_TPoin_;
       ///// E V E N T
       property OnChange :TDelegates read _OnChange;
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

procedure TCurve<_TPoin_>.UpPoins( Sender_:TObject );
begin
     _OnChange.Run( Self );
end;

function TCurve<_TPoin_>.GetPoins :TPoins<_TPoin_>;
begin
     Result := _Poins;
end;

procedure TCurve<_TPoin_>.SetPoins( const Poins_:TPoins<_TPoin_> );
begin
     if Assigned( _Poins ) then _Poins.OnChange.Del( UpPoins );

     _Poins := Poins_;

     if Assigned( _Poins ) then _Poins.OnChange.Add( UpPoins );

     UpPoins( Self );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCurve<_TPoin_>.Create( const Poins_:TPoins<_TPoin_> );
begin
     inherited Create;

     Poins := Poins_;
end;

destructor TCurve<_TPoin_>.Destroy;
begin
     _OnChange.Free;

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

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■