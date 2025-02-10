unit LUX.Sphere.FMX;

interface //#################################################################### ■

uses System.Types, System.SysUtils, System.RTLConsts, System.Classes, System.Math,
     FMX.MaterialSources,
     LUX, LUX.D3, LUX.D4x4,
     LUX.FMX.Graphics.D3,
     LUX.FMX.Graphics.D3.Shaper;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

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

implementation //############################################################### ■

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
     Result := SizeX;
end;

procedure TSphere3D.SetRadius( const Radius_:Single );
begin
     SizeX := Radius_;
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

end. //######################################################################### ■