unit LUX.Sphere.FMX.S3;

interface //#################################################################### ■

uses System.Classes, System.UITypes, System.Math.Vectors,
     FMX.Types3D, FMX.MaterialSources,
     LUX, LUX.D3, LUX.Quaternion, LUX.D4x4,
     LUX.FMX.Graphics.D3,
     LIB.Poins.S3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPoins3D

     TPoins3D = class( TF3DShaper )
     private
     protected
       _PolygonsX :TMeshData;
       _PolygonsY :TMeshData;
       _PolygonsZ :TMeshData;
       _MaterialX :TLightMaterialSource;
       _MaterialY :TLightMaterialSource;
       _MaterialZ :TLightMaterialSource;
       _Poins     :TPoins3S;
       _Radius    :Single;
       _PlotR     :Single;
       ///// A C C E S S O R
       procedure UpPoins( Sender_:TObject );
       function GetPoins :TPoins3S;
       procedure SetPoins( const Poins_:TPoins3S );
       function GetRadius :Single;
       procedure SetRadius( const Radius_:Single );
       ///// M E T H O D
       procedure Render; override;
       procedure MakeGeometry; override;
       procedure MakeTopology; override;
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property Poins  :TPoins3S read GetPoins  write SetPoins ;
       property Radius :Single   read GetRadius write SetRadius;
       property PlotR  :Single   read   _PlotR  write   _PlotR ;
     end;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPoins3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TPoins3D.UpPoins( Sender_:TObject );
begin
     upGeometry := True;
     upTopology := True;

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

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TPoins3D.Render;
begin
     inherited;

     _PolygonsX.Render( Context, TMaterialSource.ValidMaterial( _MaterialX ), AbsoluteOpacity );
     _PolygonsY.Render( Context, TMaterialSource.ValidMaterial( _MaterialY ), AbsoluteOpacity );
     _PolygonsZ.Render( Context, TMaterialSource.ValidMaterial( _MaterialZ ), AbsoluteOpacity );
end;

procedure TPoins3D.MakeGeometry;
var
   FX0, FX1, FY0, FY1, FZ0, FZ1 :TVector3D;
   P0, P1, P2, P3, P4, P5, P6, P7, V :TPoint3D;
   M0 :TSingleM4;
   M :TMatrix3D;
   N, J, J0, J1, J2, J3 :Integer;
begin
     //    2------3
     //   /|     /|
     //  6------7 |
     //  | |    | |
     //  | 0----|-1
     //  |/     |/
     //  4------5

     FX0 := TVector3D.Create( -1,  0,  0, 0 );  FX1 := TVector3D.Create( +1,  0,  0, 0 );
     FY0 := TVector3D.Create(  0, -1,  0, 0 );  FY1 := TVector3D.Create(  0, +1,  0, 0 );
     FZ0 := TVector3D.Create(  0,  0, -1, 0 );  FZ1 := TVector3D.Create(  0,  0, +1, 0 );

     P0 := TPoint3D.Create( -1, -1, -1 ).Normalize;
     P1 := TPoint3D.Create( +1, -1, -1 ).Normalize;
     P2 := TPoint3D.Create( -1, +1, -1 ).Normalize;
     P3 := TPoint3D.Create( +1, +1, -1 ).Normalize;
     P4 := TPoint3D.Create( -1, -1, +1 ).Normalize;
     P5 := TPoint3D.Create( +1, -1, +1 ).Normalize;
     P6 := TPoint3D.Create( -1, +1, +1 ).Normalize;
     P7 := TPoint3D.Create( +1, +1, +1 ).Normalize;

     M0 := TSingleM4.Translate( 0, Radius, 0 )
         * TSingleM4.Scale( _PlotR, _PlotR, _PlotR )
         * TSingleM4.RotateZ( P4i )
         * TSingleM4.RotateY( P4i );

     with _PolygonsX.VertexBuffer do
     begin
          Length := 4{Poin/Face} * 2{Face/Cube} * _Poins.PoinsN{Cube};

          J := 0;
          for N := 0 to _Poins.PoinsN{Cube}-1 do
          begin
               J0 := J;  Inc( J );  J1 := J;  Inc( J );
               J2 := J;  Inc( J );  J3 := J;  Inc( J );

               M := TMatrix3D( TDoubleM4( _Poins.Poins[ N ] ) * M0 );

               Vertices[ J0 ] := P2 * M;  Vertices[ J1 ] := P6 * M;
               Vertices[ J2 ] := P0 * M;  Vertices[ J3 ] := P4 * M;

               V := TPoint3D( FX0 * M );
               Normals[ J0 ] := V;  Normals[ J1 ] := V;
               Normals[ J2 ] := V;  Normals[ J3 ] := V;

               J0 := J;  Inc( J );  J1 := J;  Inc( J );
               J2 := J;  Inc( J );  J3 := J;  Inc( J );

               Vertices[ J0 ] := P7 * M;  Vertices[ J1 ] := P3 * M;
               Vertices[ J2 ] := P5 * M;  Vertices[ J3 ] := P1 * M;

               V := TPoint3D( FX1 * M );
               Normals[ J0 ] := V;  Normals[ J1 ] := V;
               Normals[ J2 ] := V;  Normals[ J3 ] := V;
          end;
     end;

     with _PolygonsY.VertexBuffer do
     begin
          Length := 4{Poin/Face} * 2{Face/Cube} * _Poins.PoinsN{Cube};

          J := 0;
          for N := 0 to _Poins.PoinsN{Cube}-1 do
          begin
               J0 := J;  Inc( J );  J1 := J;  Inc( J );
               J2 := J;  Inc( J );  J3 := J;  Inc( J );

               M := TMatrix3D( TDoubleM4( _Poins.Poins[ N ] ) * M0 );

               Vertices[ J0 ] := P1 * M;  Vertices[ J1 ] := P0 * M;
               Vertices[ J2 ] := P5 * M;  Vertices[ J3 ] := P4 * M;

               V := TPoint3D( FY0 * M );
               Normals[ J0 ] := V;  Normals[ J1 ] := V;
               Normals[ J2 ] := V;  Normals[ J3 ] := V;

               J0 := J;  Inc( J );  J1 := J;  Inc( J );
               J2 := J;  Inc( J );  J3 := J;  Inc( J );

               Vertices[ J0 ] := P2 * M;  Vertices[ J1 ] := P3 * M;
               Vertices[ J2 ] := P6 * M;  Vertices[ J3 ] := P7 * M;

               V := TPoint3D( FY1 * M );
               Normals[ J0 ] := V;  Normals[ J1 ] := V;
               Normals[ J2 ] := V;  Normals[ J3 ] := V;
          end;
     end;

     with _PolygonsZ.VertexBuffer do
     begin
          Length := 4{Poin/Face} * 2{Face/Cube} * _Poins.PoinsN{Cube};

          J := 0;
          for N := 0 to _Poins.PoinsN{Cube}-1 do
          begin
               J0 := J;  Inc( J );  J1 := J;  Inc( J );
               J2 := J;  Inc( J );  J3 := J;  Inc( J );

               M := TMatrix3D( TDoubleM4( _Poins.Poins[ N ] ) * M0 );

               Vertices[ J0 ] := P6 * M;  Vertices[ J1 ] := P7 * M;
               Vertices[ J2 ] := P4 * M;  Vertices[ J3 ] := P5 * M;

               V := TPoint3D( FZ1 * M );
               Normals[ J0 ] := V;  Normals[ J1 ] := V;
               Normals[ J2 ] := V;  Normals[ J3 ] := V;

               J0 := J;  Inc( J );  J1 := J;  Inc( J );
               J2 := J;  Inc( J );  J3 := J;  Inc( J );

               Vertices[ J0 ] := P3 * M;  Vertices[ J1 ] := P2 * M;
               Vertices[ J2 ] := P1 * M;  Vertices[ J3 ] := P0 * M;

               V := TPoint3D( FZ0 * M );
               Normals[ J0 ] := V;  Normals[ J1 ] := V;
               Normals[ J2 ] := V;  Normals[ J3 ] := V;
          end;
     end;
end;

procedure TPoins3D.MakeTopology;
var
   FsN, N, I, J, J0, J1, J2, J3 :Integer;
begin
     FsN := 2{Face/Cube} * _Poins.PoinsN{Cube};

     //  0------1
     //  |\\    |
     //  |  \\  |
     //  |    \\|
     //  2------3

     with _PolygonsX.IndexBuffer do
     begin
          Length := 3{Poin/Tria} * 2{Face/Quad} * FsN;

          I := 0;  J := 0;
          for N := 1 to FsN do
          begin
               J0 := J;  Inc( J );  J1 := J;  Inc( J );
               J2 := J;  Inc( J );  J3 := J;  Inc( J );

               Indices[ I ] := J0;  Inc( I );
               Indices[ I ] := J1;  Inc( I );
               Indices[ I ] := J3;  Inc( I );

               Indices[ I ] := J3;  Inc( I );
               Indices[ I ] := J2;  Inc( I );
               Indices[ I ] := J0;  Inc( I );
          end;
     end;

     with _PolygonsY.IndexBuffer do
     begin
          Length := 3{Poin/Tria} * 2{Tria/Face} * FsN;

          I := 0;  J := 0;
          for N := 1 to FsN do
          begin
               J0 := J;  Inc( J );  J1 := J;  Inc( J );
               J2 := J;  Inc( J );  J3 := J;  Inc( J );

               Indices[ I ] := J0;  Inc( I );
               Indices[ I ] := J1;  Inc( I );
               Indices[ I ] := J3;  Inc( I );

               Indices[ I ] := J3;  Inc( I );
               Indices[ I ] := J2;  Inc( I );
               Indices[ I ] := J0;  Inc( I );
          end;
     end;

     with _PolygonsZ.IndexBuffer do
     begin
          Length := 3{Poin/Tria} * 2{Tria/Face} * FsN;

          I := 0;  J := 0;
          for N := 1 to FsN do
          begin
               J0 := J;  Inc( J );  J1 := J;  Inc( J );
               J2 := J;  Inc( J );  J3 := J;  Inc( J );

               Indices[ I ] := J0;  Inc( I );
               Indices[ I ] := J1;  Inc( I );
               Indices[ I ] := J3;  Inc( I );

               Indices[ I ] := J3;  Inc( I );
               Indices[ I ] := J2;  Inc( I );
               Indices[ I ] := J0;  Inc( I );
          end;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPoins3D.Create( Owner_:TComponent );
var
   C :TAlphaColorF;
begin
     inherited;

     _PolygonsX := TMeshData.Create;
     _PolygonsY := TMeshData.Create;
     _PolygonsZ := TMeshData.Create;

     C := TAlphaColorF.Create( 196,  79,  79 ) / 255;
     _MaterialX := TLightMaterialSource.Create( Self );
     _MaterialX.Ambient  := ( 0.2 * C ).ToAlphaColor;
     _MaterialX.Diffuse  := ( 0.8 * C ).ToAlphaColor;
     _MaterialX.Specular := TAlphaColors.Null;

     C := TAlphaColorF.Create(  54, 135,  54 ) / 255;
     _MaterialY := TLightMaterialSource.Create( Self );
     _MaterialY.Ambient  := ( 0.2 * C ).ToAlphaColor;
     _MaterialY.Diffuse  := ( 0.8 * C ).ToAlphaColor;
     _MaterialY.Specular := TAlphaColors.Null;

     C := TAlphaColorF.Create( 103, 103, 255 ) / 255;
     _MaterialZ := TLightMaterialSource.Create( Self );
     _MaterialZ.Ambient  := ( 0.2 * C ).ToAlphaColor;
     _MaterialZ.Diffuse  := ( 0.8 * C ).ToAlphaColor;
     _MaterialZ.Specular := TAlphaColors.Null;

     Radius := 5;
     PlotR  := 0.5;
end;

destructor TPoins3D.Destroy;
begin
     Poins := nil;

     _PolygonsX.Free;
     _PolygonsY.Free;
     _PolygonsZ.Free;

     inherited;
end;

end. //######################################################################### ■