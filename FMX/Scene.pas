unit Scene;

interface //#################################################################### ■

uses System.Types, System.SysUtils, System.RTLConsts, System.Classes,
     System.UITypes, System.Math, System.Math.Vectors,
     FMX.Types3D, FMX.Controls3D, FMX.MaterialSources,
     LUX, LUX.D3, LUX.D4x4,
     LUX.FMX.Graphics.D3,
     LUX.FMX.Graphics.D3.Shaper,
     LIB.Poins.S2;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TWorld3D

     TWorld3D = class( TF3DWorld )
     private
     protected
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCamera3D

     TCamera3D = class( TF3DCamera )
     private
     protected
       _Radius :Single;
       _AngleX :Single;
       _AngleY :Single;
       ///// A C C E S S O R
       function GetRadius :Single;
       procedure SetRadius( const Radius_:Single );
       function GetAngleX :Single;
       procedure SetAngleX( const AngleX_:Single );
       function GetAngleY :Single;
       procedure SetAngleY( const AngleY_:Single );
       ///// M E T H O D
       procedure MakePose;
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property Radius :Single read GetRadius write SetRadius;
       property AngleX :Single read GetAngleX write SetAngleX;
       property AngleY :Single read GetAngleY write SetAngleY;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLight3D

     TLight3D = class( TF3DLight )
     private
     protected
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSphere3D

     TSphere3D = class( TF3DSphere )
     private
     protected
       ///// A C C E S S O R
       function GetRadius :Single;
       procedure SetRadius( const Radius_:Single );
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property Radius :Single read GetRadius write SetRadius;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPoin3D

     TPoin3D = class( TF3DObject )
     private
     protected
       _Sphere :TSphere3D;
       _Direct :TSingle3D;
       _Radius :Single;
       ///// A C C E S S O R
       function GetRadius :Single;
       procedure SetRadius( const Radius_:Single );
       function GetSize :Single;
       procedure SetSize( const Size_:Single );
       function GetColor :TAlphaColorF;
       procedure SetColor( const Color_:TAlphaColorF );
       function GetDirect :TSingle3D;
       procedure SetDirect( const Direct_:TSingle3D );
       ///// M E T H O D
       procedure MakeModel; override;
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property Radius :Single       read GetRadius write SetRadius;
       property Size   :Single       read GetSize   write SetSize  ;
       property Color  :TAlphaColorF read GetColor  write SetColor ;
       property Direct :TSingle3D    read GetDirect write SetDirect;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPoins3D

     TPoins3D = class( TF3DObject )
     private
     protected
       _Poins  :TPoins2S;
       _Radius :Single;
       _Size   :Single;
       _Color  :TAlphaColorF;
       ///// A C C E S S O R
       procedure UpPoins( Sender_:TObject );
       function GetPoins :TPoins2S;
       procedure SetPoins( const Poins_:TPoins2S );
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
       property Poins  :TPoins2S     read GetPoins  write SetPoins ;
       property Radius :Single       read GetRadius write SetRadius;
       property Size   :Single       read   _Size   write   _Size  ;
       property Color  :TAlphaColorF read GetColor  write SetColor ;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 V A R I A B L E 】

    _World3D  :TWorld3D;
    _Camera3D :TCamera3D;
    _Light3D  :TLight3D;
    _Sphere3D :TSphere3D;
    _Poins3D  :TPoins3D;
    _Plots3D0 :TPoins3D;
    _Plots3D1 :TPoins3D;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

procedure MakeScene;

implementation //############################################################### ■

uses Main;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TWorld3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCamera3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TCamera3D.GetRadius :Single;
begin
     Result := _Radius;
end;

procedure TCamera3D.SetRadius( const Radius_:Single );
begin
     _Radius := Radius_;

     MakePose;
end;

//------------------------------------------------------------------------------

function TCamera3D.GetAngleX :Single;
begin
     Result := _AngleX;
end;

procedure TCamera3D.SetAngleX( const AngleX_:Single );
begin
     _AngleX := AngleX_;

     MakePose;
end;

function TCamera3D.GetAngleY :Single;
begin
     Result := _AngleY;
end;

procedure TCamera3D.SetAngleY( const AngleY_:Single );
begin
     _AngleY := AngleY_;

     MakePose;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TCamera3D.MakePose;
begin
     Pose := TSingleM4.RotateY( +_AngleX )
           * TSingleM4.RotateX( -_AngleY )
           * TSingleM4.Translate( 0, 0, _Radius );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCamera3D.Create( Owner_:TComponent );
begin
     inherited;

     Camera.AngleOfView := 8;

     Radius := 100;
     AngleX := 0;
     AngleY := DegToRad( 45 );
end;

destructor TCamera3D.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TLight3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TLight3D.Create( Owner_:TComponent );
begin
     inherited;

     Pose := TSingleM4.RotateX( DegToRad( 135 ) );
end;

destructor TLight3D.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSphere3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TSphere3D.GetRadius :Single;
begin
     Result := SizeX / 2;
end;

procedure TSphere3D.SetRadius( const Radius_:Single );
begin
     SizeX := Radius_ * 2;
     SizeY := SizeX;
     SizeZ := SizeX;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TSphere3D.Create( Owner_:TComponent );
begin
     inherited;

     Radius := 4.8;
     DivX   := 180;
     DivY   := 90;
end;

destructor TSphere3D.Destroy;
begin

     inherited;
end;

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

     _Sphere.Material.Diffuse := D.ToAlphaColor;
     _Sphere.Material.Ambient := A.ToAlphaColor;
end;

//------------------------------------------------------------------------------

function TPoin3D.GetDirect :TSingle3D;
begin
     Result := _Direct;
end;

procedure TPoin3D.SetDirect( const Direct_:TSingle3D );
begin
     _Direct := Direct_;  upModel := True;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TPoin3D.MakeModel;
begin
     _Sphere.Pos := _Direct * _Radius;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPoin3D.Create( Owner_:TComponent );
begin
     inherited;

     _Sphere := TSphere3D.Create( Self );

     with _Sphere do
     begin
          Parent := Self;
          DivX   := 18;
          DivY   := 9;
     end;

     Size   := 0.4;
     Direct := TSingle3D.Create( 1, 0, 0 );
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

function TPoins3D.GetPoins :TPoins2S;
begin
     Result := _Poins;
end;

procedure TPoins3D.SetPoins( const Poins_:TPoins2S );
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
               Direct := _Poins[ I ];
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

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

procedure MakeScene;
begin
     with Form1 do
     begin
          _World3D := TWorld3D.Create( Viewport3D1 );

          _Camera3D := TCamera3D.Create( _World3D );

          Viewport3D1.Camera := _Camera3D.Camera;

          _Light3D := TLight3D.Create( _Camera3D );

          _Sphere3D := TSphere3D.Create( _World3D );
          _Sphere3D.Material.Texture.LoadFromFile( '..\..\_DATA\Sphere 1800x900.png' );

          _Poins3D := TPoins3D.Create( _World3D );
          _Poins3D.Poins := _Poins2S;
          _Poins3D.Color := TAlphaColorF.Create( 1, 0, 0 );

          _Plots3D0 := TPoins3D.Create( _World3D );
          _Plots3D0.Poins := _Plots2S0;
          _Plots3D0.Size := 0.2;
          _Plots3D0.Color := TAlphaColorF.Create( 0, 1, 0 );

          _Plots3D1 := TPoins3D.Create( _World3D );
          _Plots3D1.Poins := _Plots2S1;
          _Plots3D1.Size := 0.2;
          _Plots3D1.Color := TAlphaColorF.Create( 0, 0, 1 );
     end;
end;

end. //######################################################################### ■