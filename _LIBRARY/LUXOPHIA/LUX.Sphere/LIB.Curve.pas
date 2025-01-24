unit LIB.Curve;

interface //#################################################################### ■

uses LUX,
     LIB,
     LIB.Poins;

type //$$$$$$$$$&&$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】


     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurve<_TPoin_>

     TCurve<_TPoin_> = class
     private
     protected
       type TWector     = TWector    <_TPoin_>;
       type TBarycenter = TBarycenter<_TPoin_>;
       type TPoins      = TPoins     <_TPoin_>;
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
       constructor Create( const Poins_:TPoins );
       destructor Destroy; Override;
       ///// P R O P E R T Y
       property Bary  :TBarycenter read GetBary  write SetBary ;
       property Poins :TPoins      read GetPoins write SetPoins;
       ///// M E T H O D
       function Value( const X_:Double ) :_TPoin_; virtual;
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

function TCurve<_TPoin_>.GetBary :TBarycenter;
begin
     Result := _Bary;
end;

procedure TCurve<_TPoin_>.SetBary( const Bary_:TBarycenter );
begin
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
     if Assigned( _Poins ) then _Poins.OnChange.Del( UpPoins );

     _Poins := Poins_;

     if Assigned( _Poins ) then _Poins.OnChange.Add( UpPoins );

     UpPoins( Self );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCurve<_TPoin_>.Create( const Poins_:TPoins );
begin
     inherited Create;

     Poins := Poins_;
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

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■