unit LUX.Sphere.FMX.S3;

interface //#################################################################### ■

uses System.Types, System.SysUtils, System.RTLConsts, System.Classes,
     System.UITypes, System.Math, System.Math.Vectors,
     FMX.Types3D, FMX.Controls3D, FMX.MaterialSources,
     LUX, LUX.D3, LUX.Quaternion, LUX.D4x4,
     LUX.FMX.Graphics.D3,
     LUX.FMX.Graphics.D3.Shaper,
     LUX.Sphere.FMX,
     LIB.Poins.S3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPoin3D

     TPoin3D = class( TF3DObject )
     private
     protected
       _Sphere :TSphere3D;
       _Direct :TSingleQ;
       _Radius :Single;
       ///// A C C E S S O R
       function GetRadius :Single;
       procedure SetRadius( const Radius_:Single );
       function GetSize :Single;
       procedure SetSize( const Size_:Single );
       function GetColor :TAlphaColorF;
       procedure SetColor( const Color_:TAlphaColorF );
       function GetDirect :TSingleQ;
       procedure SetDirect( const Direct_:TSingleQ );
       ///// M E T H O D
       procedure MakeModel; override;
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property Radius :Single       read GetRadius write SetRadius;
       property Size   :Single       read GetSize   write SetSize  ;
       property Color  :TAlphaColorF read GetColor  write SetColor ;
       property Direct :TSingleQ     read GetDirect write SetDirect;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPoins3D

     TPoins3D = class( TF3DObject )
     private
     protected
       _Poins  :TPoins3S;
       _Radius :Single;
       _Size   :Single;
       _Color  :TAlphaColorF;
       ///// A C C E S S O R
       procedure UpPoins( Sender_:TObject );
       function GetPoins :TPoins3S;
       procedure SetPoins( const Poins_:TPoins3S );
       function GetRadius :Single;
       procedure SetRadius( const Radius_:Single );
       function GetColor :TAlphaColorF;
       procedure SetColor( const Color_:TAlphaColorF );
       ///// M E T H O D
       procedure MakeModel; override;
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property Poins  :TPoins3S     read GetPoins  write SetPoins ;
       property Radius :Single       read GetRadius write SetRadius;
       property Size   :Single       read   _Size   write   _Size  ;
       property Color  :TAlphaColorF read GetColor  write SetColor ;
     end;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPoin3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TPoin3D.GetRadius :Single;
begin
     Result := _Radius;
end;

procedure TPoin3D.SetRadius( const Radius_:Single );
begin
     _Radius := Radius_;  upModel := True;
end;

//------------------------------------------------------------------------------

function TPoin3D.GetSize :Single;
begin
     Result := _Sphere.SizeX;
end;

procedure TPoin3D.SetSize( const Size_:Single );
begin
     _Sphere.SizeX := Size_;
     _Sphere.SizeY := Size_;
     _Sphere.SizeZ := Size_;
end;

//------------------------------------------------------------------------------

function TPoin3D.GetColor :TAlphaColorF;
begin
     Result := TAlphaColorF.Create( _Sphere.Material.Diffuse );
end;

procedure TPoin3D.SetColor( const Color_:TAlphaColorF );
var
   D, A :TAlphaColorF;
begin
     D := 0.8 * Color_;
     A := 0.2 * Color_;

     //_Sphere.Material.Diffuse := D.ToAlphaColor;
     //_Sphere.Material.Ambient := A.ToAlphaColor;
end;

//------------------------------------------------------------------------------

function TPoin3D.GetDirect :TSingleQ;
begin
     Result := _Direct;
end;

procedure TPoin3D.SetDirect( const Direct_:TSingleQ );
begin
     _Direct := Direct_;  upModel := True;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TPoin3D.MakeModel;
begin
     _Sphere.Pose := TSingleM4( _Direct ) * TSingleM4.Translate( 0, _Radius, 0 );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPoin3D.Create( Owner_:TComponent );
begin
     inherited;

     _Sphere := TSphere3D.Create( Self );

     _Sphere.Material.Texture.LoadFromFile( '..\..\_DATA\Poin0 180x90.png' );

     with _Sphere do
     begin
          Parent := Self;
          DivX   := 18;
          DivY   := 9;
     end;

     Size   := 0.4;
     Direct := 1;
     Radius := 5;
end;

destructor TPoin3D.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPoins3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TPoins3D.UpPoins( Sender_:TObject );
begin
     upModel := True;

     Repaint;
end;

function TPoins3D.GetPoins :TPoins3S;
begin
     Result := _Poins;
end;

procedure TPoins3D.SetPoins( const Poins_:TPoins3S );
begin
     if Assigned( _Poins ) then _Poins.OnChange.Del( UpPoins );

     _Poins := Poins_;

     if Assigned( _Poins ) then _Poins.OnChange.Add( UpPoins );

     UpPoins( Self );
end;

//------------------------------------------------------------------------------

function TPoins3D.GetRadius :Single;
begin
     Result := _Radius;
end;

procedure TPoins3D.SetRadius( const Radius_:Single );
begin
     _Radius := Radius_;  upModel := True;
end;

//------------------------------------------------------------------------------

function TPoins3D.GetColor :TAlphaColorF;
begin
     Result := _Color;
end;

procedure TPoins3D.SetColor( const Color_:TAlphaColorF );
begin
     _Color := Color_;  upModel := True;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TPoins3D.MakeModel;
var
   I :Integer;
begin
     Self.DeleteChildren;

     if not Assigned( _Poins ) then Exit;

     for I := 0 to _Poins.PoinsN-1 do
     begin
          with TPoin3D.Create( Self ) do
          begin
               Size   := _Size;
               Color  := _Color;
               Direct := TSingleQ( _Poins[ I ] );
          end;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPoins3D.Create( Owner_:TComponent );
begin
     inherited;

     Size := 0.4;
end;

destructor TPoins3D.Destroy;
begin
     Poins := nil;

     inherited;
end;

end. //######################################################################### ■