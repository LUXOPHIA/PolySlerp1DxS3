unit LIB;

interface //#################################################################### ■

type //$$$$$$$$$&&$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TWector<_TVector_>

     TWector<_TVector_> = record
     private
     public
       v :_TVector_;
       w :Double;
       /////
       constructor Create( const V_:_TVector_; const W_:Double );
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBarycenter<_TPoin_>

     TBarycenter<_TPoin_> = class
     private
       type TWector  = TWector<_TPoin_>;
       type TWectors = TArray<TWector>;
     protected
       _Poins :TWectors;
       ///// A C C E S S O R
       function GetPoinsN :Integer; virtual;
       procedure SetPoinsN( const PoinsN_:Integer ); virtual;
       function GetPoins( const I_:Integer ) :TWector; virtual;
       procedure SetPoins( const I_:Integer; const Poin_:TWector ); virtual;
       function GetCenter :_TPoin_; virtual; abstract;
     public
       constructor Create;
       ///// P R O P E R T Y
       property PoinsN                    :Integer read GetPoinsN write SetPoinsN;
       property Poins[ const I_:Integer ] :TWector read GetPoins  write SetPoins ;
       property Center                    :_TPoin_ read GetCenter                ;
       ///// M E T H O D
       function Lerp( const Ps_:TWectors ) :_TPoin_; overload;
       function Lerp( const P0_,P1_:_TPoin_; const T_:Double ) :_TPoin_; overload;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TWector<_TVector_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TWector<_TVector_>.Create( const V_:_TVector_; const W_:Double );
begin
     v := V_;
     w := W_;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TBarycenter<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TBarycenter<_TPoin_>.GetPoinsN :Integer;
begin
     Result := Length( _Poins );
end;

procedure TBarycenter<_TPoin_>.SetPoinsN( const PoinsN_:Integer );
begin
     if PoinsN <> PoinsN_ then SetLength( _Poins, PoinsN_ );
end;

function TBarycenter<_TPoin_>.GetPoins( const I_:Integer ) :TWector;
begin
     Result := _Poins[ I_ ];
end;

procedure TBarycenter<_TPoin_>.SetPoins( const I_:Integer; const Poin_:TWector );
begin
     _Poins[ I_ ] := Poin_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TBarycenter<_TPoin_>.Create;
begin
     inherited;

     PoinsN := 2;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TBarycenter<_TPoin_>.Lerp( const Ps_:TWectors ) :_TPoin_;
begin
     _Poins := Ps_;

     Result := Center;
end;

function TBarycenter<_TPoin_>.Lerp( const P0_,P1_:_TPoin_; const T_:Double ) :_TPoin_;
begin
     Poins[ 0 ] := TWector.Create( P0_, 1 - T_ );
     Poins[ 1 ] := TWector.Create( P1_,     T_ );

     Result := Center;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■