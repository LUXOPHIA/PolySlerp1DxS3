unit LUX.FMX.Graphics.D3;

interface //#################################################################### ■

uses System.Classes, System.Math.Vectors,
     FMX.Types3D, FMX.Controls3D, FMX.Viewport3D,
     LUX, LUX.D3, LUX.D4x4;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TF3DObject

     TF3DObject = class( TControl3D )
     private
     protected
       upModel :Boolean;
       ///// A C C E S S O R
       function GetAbsoPose :TSingleM4;
       procedure SetAbsoPose( const AbsoPose_:TSingleM4 );
       function GetLocaPose :TSingleM4;
       procedure SetLocaPose( const LocaPose_:TSingleM4 );
       function GetLocaSizeX :Single;
       procedure SetLocaSizeX( const LocaSizeX_:Single );
       function GetLocaSizeY :Single;
       procedure SetLocaSizeY( const LocaSizeY_:Single );
       function GetLocaSizeZ :Single;
       procedure SetLocaSizeZ( const LocaSizeZ_:Single );
       function GetAbsoPos :TSingle3D;
       procedure SetAbsoPos( const AbsoPos_:TSingle3D );
       function GetLocaPos :TSingle3D;
       procedure SetLocaPos( const LocaPos_:TSingle3D );
       ///// M E T H O D
       procedure BeforeRender; override;
       procedure MakeModel; virtual;
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property AbsoPose  :TSingleM4 read GetAbsoPose  write SetAbsoPose ;
       property LocaPose  :TSingleM4 read GetLocaPose  write SetLocaPose ;
       property     Pose  :TSingleM4 read GetLocaPose  write SetLocaPose ;
       property LocaSizeX :Single    read GetLocaSizeX write SetLocaSizeX;
       property LocaSizeY :Single    read GetLocaSizeY write SetLocaSizeY;
       property LocaSizeZ :Single    read GetLocaSizeZ write SetLocaSizeZ;
       property     SizeX :Single    read GetLocaSizeX write SetLocaSizeX;
       property     SizeY :Single    read GetLocaSizeY write SetLocaSizeY;
       property     SizeZ :Single    read GetLocaSizeZ write SetLocaSizeZ;
       property AbsoPos   :TSingle3D read GetAbsoPos   write SetAbsoPos  ;
       property LocaPos   :TSingle3D read GetLocaPos   write SetLocaPos  ;
       property     Pos   :TSingle3D read GetLocaPos   write SetLocaPos  ;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TF3DWorld

     TF3DWorld = class( TF3DObject )
     private
     protected
     public
       constructor Create( Viewport_:TViewport3D ); reintroduce;
       destructor Destroy; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TF3DCamera

     TF3DCamera = class( TF3DObject )
     private
     protected
       _Camera :FMX.Controls3D.TCamera;
       ///// A C C E S S O R
       function GetAbsoPose :TSingleM4;
       procedure SetAbsoPose( const AbsoPose_:TSingleM4 );
       function GetLocaPose :TSingleM4;
       procedure SetLocaPose( const LocaPose_:TSingleM4 );
       function GetLocaSizeX :Single;
       procedure SetLocaSizeX( const LocaSizeX_:Single );
       function GetLocaSizeY :Single;
       procedure SetLocaSizeY( const LocaSizeY_:Single );
       function GetLocaSizeZ :Single;
       procedure SetLocaSizeZ( const LocaSizeZ_:Single );
       function GetAbsoPos :TSingle3D;
       procedure SetAbsoPos( const AbsoPos_:TSingle3D );
       function GetLocaPos :TSingle3D;
       procedure SetLocaPos( const LocaPos_:TSingle3D );
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property Camera    :TCamera   read   _Camera                      ;
       property AbsoPose  :TSingleM4 read GetAbsoPose  write SetAbsoPose ;
       property LocaPose  :TSingleM4 read GetLocaPose  write SetLocaPose ;
       property     Pose  :TSingleM4 read GetLocaPose  write SetLocaPose ;
       property LocaSizeX :Single    read GetLocaSizeX write SetLocaSizeX;
       property LocaSizeY :Single    read GetLocaSizeY write SetLocaSizeY;
       property LocaSizeZ :Single    read GetLocaSizeZ write SetLocaSizeZ;
       property     SizeX :Single    read GetLocaSizeX write SetLocaSizeX;
       property     SizeY :Single    read GetLocaSizeY write SetLocaSizeY;
       property     SizeZ :Single    read GetLocaSizeZ write SetLocaSizeZ;
       property AbsoPos   :TSingle3D read GetAbsoPos   write SetAbsoPos  ;
       property LocaPos   :TSingle3D read GetLocaPos   write SetLocaPos  ;
       property     Pos   :TSingle3D read GetLocaPos   write SetLocaPos  ;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TF3DLight

     TF3DLight = class( FMX.Controls3D.TLight )
     private
     protected
       ///// A C C E S S O R
       function GetAbsoPose :TSingleM4;
       procedure SetAbsoPose( const AbsoPose_:TSingleM4 );
       function GetLocaPose :TSingleM4;
       procedure SetLocaPose( const LocaPose_:TSingleM4 );
       function GetLocaSizeX :Single;
       procedure SetLocaSizeX( const LocaSizeX_:Single );
       function GetLocaSizeY :Single;
       procedure SetLocaSizeY( const LocaSizeY_:Single );
       function GetLocaSizeZ :Single;
       procedure SetLocaSizeZ( const LocaSizeZ_:Single );
       function GetAbsoPos :TSingle3D;
       procedure SetAbsoPos( const AbsoPos_:TSingle3D );
       function GetLocaPos :TSingle3D;
       procedure SetLocaPos( const LocaPos_:TSingle3D );
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property AbsoPose  :TSingleM4 read GetAbsoPose  write SetAbsoPose ;
       property LocaPose  :TSingleM4 read GetLocaPose  write SetLocaPose ;
       property     Pose  :TSingleM4 read GetLocaPose  write SetLocaPose ;
       property LocaSizeX :Single    read GetLocaSizeX write SetLocaSizeX;
       property LocaSizeY :Single    read GetLocaSizeY write SetLocaSizeY;
       property LocaSizeZ :Single    read GetLocaSizeZ write SetLocaSizeZ;
       property     SizeX :Single    read GetLocaSizeX write SetLocaSizeX;
       property     SizeY :Single    read GetLocaSizeY write SetLocaSizeY;
       property     SizeZ :Single    read GetLocaSizeZ write SetLocaSizeZ;
       property AbsoPos   :TSingle3D read GetAbsoPos   write SetAbsoPos  ;
       property LocaPos   :TSingle3D read GetLocaPos   write SetLocaPos  ;
       property     Pos   :TSingle3D read GetLocaPos   write SetLocaPos  ;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TF3DShaper

     TF3DShaper = class( TF3DObject )
     private
     protected
       upGeometry :Boolean;
       upTopology :Boolean;
       ///// M E T H O D
       procedure BeforeRender; override;
       procedure Render; override;
       procedure MakeGeometry; virtual; abstract;
       procedure MakeTopology; virtual; abstract;
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TF3DObject

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TF3DObject.GetAbsoPose :TSingleM4;
begin
     Result := AbsoluteMatrix;
end;

procedure TF3DObject.SetAbsoPose( const AbsoPose_:TSingleM4 );
begin
     Pose := Pose.Inverse * TMatrix3D( AbsoPose_ );
end;

//------------------------------------------------------------------------------

function TF3DObject.GetLocaPose :TSingleM4;
begin
     Result := FLocalMatrix;
end;

procedure TF3DObject.SetLocaPose( const LocaPose_:TSingleM4 );
begin
     FLocalMatrix := TMatrix3D( LocaPose_ );

     RecalcAbsolute;
     RebuildRenderingList;
     Repaint;
end;

//------------------------------------------------------------------------------

function TF3DObject.GetLocaSizeX :Single;
begin
     Result := Width;
end;

procedure TF3DObject.SetLocaSizeX( const LocaSizeX_:Single );
begin
     Width := LocaSizeX_;
end;

function TF3DObject.GetLocaSizeY :Single;
begin
     Result := Height;
end;

procedure TF3DObject.SetLocaSizeY( const LocaSizeY_:Single );
begin
     Height := LocaSizeY_;
end;

function TF3DObject.GetLocaSizeZ :Single;
begin
     Result := Depth;
end;

procedure TF3DObject.SetLocaSizeZ( const LocaSizeZ_:Single );
begin
     Depth := LocaSizeZ_;
end;

//------------------------------------------------------------------------------

function TF3DObject.GetAbsoPos :TSingle3D;
begin
     Result := AbsoPose.AxisP;
end;

procedure TF3DObject.SetAbsoPos( const AbsoPos_:TSingle3D );
var
   M :TSingleM4;
begin
     M := AbsoPose;
     M.AxisP := AbsoPos_;
     AbsoPose := M;
end;

//------------------------------------------------------------------------------

function TF3DObject.GetLocaPos :TSingle3D;
begin
     with FLocalMatrix.M[3] do Result := TSingle3D.Create( X, Y, Z );
end;

procedure TF3DObject.SetLocaPos( const LocaPos_:TSingle3D );
begin
     with FLocalMatrix.M[3] do
     begin
          X := LocaPos_.X;
          Y := LocaPos_.Y;
          Z := LocaPos_.Z;
     end;

     RecalcAbsolute;
     RebuildRenderingList;
     Repaint;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TF3DObject.BeforeRender;
begin
     inherited;

     if upModel then
     begin
          MakeModel;

          upModel := False;
     end;
end;

procedure TF3DObject.MakeModel;
begin

end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TF3DObject.Create( Owner_:TComponent );
begin
     inherited;

     if Owner_ is TControl3D then Parent := Owner_ as TControl3D;

     HitTest := False;
end;

destructor TF3DObject.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TF3DWorld

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TF3DWorld.Create( Viewport_:TViewport3D );
begin
     inherited Create( Viewport_ );

     Parent := Viewport_;
     Pose   := TSingleM4.Scale( +1, -1, -1 );
end;

destructor TF3DWorld.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TF3DCamera

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TF3DCamera.GetAbsoPose :TSingleM4;
begin
     Result := AbsoluteMatrix;
end;

procedure TF3DCamera.SetAbsoPose( const AbsoPose_:TSingleM4 );
begin
     LocaPose := LocaPose.Inverse * TMatrix3D( AbsoPose_ );
end;

//------------------------------------------------------------------------------

function TF3DCamera.GetLocaPose :TSingleM4;
begin
     Result := FLocalMatrix;
end;

procedure TF3DCamera.SetLocaPose( const LocaPose_:TSingleM4 );
begin
     FLocalMatrix := TMatrix3D( LocaPose_ );

     RecalcAbsolute;
     RebuildRenderingList;
     Repaint;
end;

//------------------------------------------------------------------------------

function TF3DCamera.GetLocaSizeX :Single;
begin
     Result := Width;
end;

procedure TF3DCamera.SetLocaSizeX( const LocaSizeX_:Single );
begin
     Width := LocaSizeX_;
end;

function TF3DCamera.GetLocaSizeY :Single;
begin
     Result := Height;
end;

procedure TF3DCamera.SetLocaSizeY( const LocaSizeY_:Single );
begin
     Height := LocaSizeY_;
end;

function TF3DCamera.GetLocaSizeZ :Single;
begin
     Result := Depth;
end;

procedure TF3DCamera.SetLocaSizeZ( const LocaSizeZ_:Single );
begin
     Depth := LocaSizeZ_;
end;

//------------------------------------------------------------------------------

function TF3DCamera.GetAbsoPos :TSingle3D;
begin
     Result := AbsoPose.AxisP;
end;

procedure TF3DCamera.SetAbsoPos( const AbsoPos_:TSingle3D );
var
   M :TSingleM4;
begin
     M := AbsoPose;
     M.AxisP := AbsoPos_;
     AbsoPose := M;
end;

//------------------------------------------------------------------------------

function TF3DCamera.GetLocaPos :TSingle3D;
begin
     with FLocalMatrix.M[3] do Result := TSingle3D.Create( X, Y, Z );
end;

procedure TF3DCamera.SetLocaPos( const LocaPos_:TSingle3D );
begin
     with FLocalMatrix.M[3] do
     begin
          X := LocaPos_.X;
          Y := LocaPos_.Y;
          Z := LocaPos_.Z;
     end;

     RecalcAbsolute;
     RebuildRenderingList;
     Repaint;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TF3DCamera.Create( Owner_:TComponent );
begin
     inherited;

     _Camera := FMX.Controls3D.TCamera.Create( Self );
     _Camera.Parent := Self;
     _Camera.Scale.Y := -1;
     _Camera.Scale.Z := -1;

     if Owner_ is TControl3D then Parent := Owner_ as TControl3D;
end;

destructor TF3DCamera.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TF3DLight

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TF3DLight.GetAbsoPose :TSingleM4;
begin
     Result := AbsoluteMatrix;
end;

procedure TF3DLight.SetAbsoPose( const AbsoPose_:TSingleM4 );
begin
     LocaPose := LocaPose.Inverse * TMatrix3D( AbsoPose_ );
end;

//------------------------------------------------------------------------------

function TF3DLight.GetLocaPose :TSingleM4;
begin
     Result := FLocalMatrix;
end;

procedure TF3DLight.SetLocaPose( const LocaPose_:TSingleM4 );
begin
     FLocalMatrix := TMatrix3D( LocaPose_ );

     RecalcAbsolute;
     RebuildRenderingList;
     Repaint;
end;

//------------------------------------------------------------------------------

function TF3DLight.GetLocaSizeX :Single;
begin
     Result := Width;
end;

procedure TF3DLight.SetLocaSizeX( const LocaSizeX_:Single );
begin
     Width := LocaSizeX_;
end;

function TF3DLight.GetLocaSizeY :Single;
begin
     Result := Height;
end;

procedure TF3DLight.SetLocaSizeY( const LocaSizeY_:Single );
begin
     Height := LocaSizeY_;
end;

function TF3DLight.GetLocaSizeZ :Single;
begin
     Result := Depth;
end;

procedure TF3DLight.SetLocaSizeZ( const LocaSizeZ_:Single );
begin
     Depth := LocaSizeZ_;
end;

//------------------------------------------------------------------------------

function TF3DLight.GetAbsoPos :TSingle3D;
begin
     Result := AbsoPose.AxisP;
end;

procedure TF3DLight.SetAbsoPos( const AbsoPos_:TSingle3D );
var
   M :TSingleM4;
begin
     M := AbsoPose;
     M.AxisP := AbsoPos_;
     AbsoPose := M;
end;

//------------------------------------------------------------------------------

function TF3DLight.GetLocaPos :TSingle3D;
begin
     with FLocalMatrix.M[3] do Result := TSingle3D.Create( X, Y, Z );
end;

procedure TF3DLight.SetLocaPos( const LocaPos_:TSingle3D );
begin
     with FLocalMatrix.M[3] do
     begin
          X := LocaPos_.X;
          Y := LocaPos_.Y;
          Z := LocaPos_.Z;
     end;

     RecalcAbsolute;
     RebuildRenderingList;
     Repaint;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TF3DLight.Create( Owner_:TComponent );
begin
     inherited;

     if Owner_ is TControl3D then Parent := Owner_ as TControl3D;
end;

destructor TF3DLight.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TF3DShaper

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

procedure TF3DShaper.BeforeRender;
begin
     inherited;

     if upGeometry then
     begin
          upGeometry := False;

          MakeGeometry;
     end;

     if upTopology then
     begin
          upTopology := False;

          MakeTopology;
     end;
end;

procedure TF3DShaper.Render;
begin
     inherited;

     Context.SetMatrix( TMatrix3D.CreateScaling( TPoint3D.Create( SizeX, SizeY, SizeZ ) ) * AbsoluteMatrix );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TF3DShaper.Create( Owner_:TComponent );
begin
     inherited;

     upGeometry := True;
     upTopology := True;
end;

destructor TF3DShaper.Destroy;
begin

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■