unit LUX.Sphere.FMX.S3;

interface //#################################################################### ■

uses System.Types, System.SysUtils, System.RTLConsts, System.Classes,
     System.UITypes, System.Math.Vectors,
     FMX.Types3D, FMX.Controls3D, FMX.MaterialSources,
     LUX, LUX.D3, LUX.Quaternion, LUX.D4x4,
     LUX.FMX.Graphics.D3,
     LIB.Poins.S3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPoins3D

     TPoins3D = class( TF3DShaper )
     private
       ///// M E T H O D
       function XYtoI( const I_,X_,Y_:Integer ) :Integer; inline;
     protected
       _Polygons :TMeshData;
       _Material :TLightMaterialSource;
       _Poins    :TPoins3S;
       _Radius   :Single;
       _PlotR    :Single;
       _DivX     :Integer;
       _DivY     :Integer;
       ///// A C C E S S O R
       function GetMaterial :TLightMaterialSource;
       procedure UpPoins( Sender_:TObject );
       function GetPoins :TPoins3S;
       procedure SetPoins( const Poins_:TPoins3S );
       function GetRadius :Single;
       procedure SetRadius( const Radius_:Single );
       function GetPlotR :Single;
       procedure SetPlotR( const PlotR_:Single );
       function GetDivX :Integer;
       procedure SetDivX( const DivX_:Integer );
       function GetDivY :Integer;
       procedure SetDivY( const DivY_:Integer );
       ///// M E T H O D
       procedure Render; override;
       procedure MakeGeometry; override;
       procedure MakeTopology; override;
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property Material :TLightMaterialSource read GetMaterial                ;
       property Poins    :TPoins3S             read GetPoins    write SetPoins ;
       property Radius   :Single               read GetRadius   write SetRadius;
       property PlotR    :Single               read GetPlotR    write SetPlotR ;
       property DivX     :Integer              read GetDivX     write SetDivX  ;
       property DivY     :Integer              read GetDivY     write SetDivY  ;
     end;

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPoins3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

function TPoins3D.XYtoI( const I_,X_,Y_:Integer ) :Integer;
begin
     Result := ( ( _DivY + 1 ) * I_ + Y_ ) * ( _DivX + 1 ) + X_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TPoins3D.GetMaterial :TLightMaterialSource;
begin
     Result := _Material;
end;

//------------------------------------------------------------------------------

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
     _Radius := Radius_;

     upGeometry := True;
     upTopology := True;
end;

//------------------------------------------------------------------------------

function TPoins3D.GetPlotR :Single;
begin
     Result := _PlotR;
end;

procedure TPoins3D.SetPlotR( const PlotR_:Single );
begin
     _PlotR := PlotR_;

     upGeometry := True;
     upTopology := True;
end;

//------------------------------------------------------------------------------

function TPoins3D.GetDivX :Integer;
begin
     Result := _DivX;
end;

procedure TPoins3D.SetDivX( const DivX_:Integer );
begin
     _DivX := DivX_;

     upGeometry := True;
     upTopology := True;
end;

function TPoins3D.GetDivY :Integer;
begin
     Result := _DivY;
end;

procedure TPoins3D.SetDivY( const DivY_:Integer );
begin
     _DivY := DivY_;

     upGeometry := True;
     upTopology := True;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TPoins3D.Render;
begin
     inherited;

     _Polygons.Render( Context, TMaterialSource.ValidMaterial( _Material ), AbsoluteOpacity );
end;

procedure TPoins3D.MakeGeometry;
var
   M, M0, M1 :TMatrix3D;
   N, X, Y, I :Integer;
   T :TPointF;
   P :TPoint3D;
   R :Single;
begin
     M := TMatrix3D( TSingleM4.Translate( 0, Radius, 0 )
                   * TSingleM4.Scale( _PlotR, _PlotR, _PlotR ) );

     with _Polygons.VertexBuffer do
     begin
          Length := (DivY+1)*(DivX+1){Vert/Poin} * Poins.PoinsN{Poin};

          for N := 0 to Poins.PoinsN{Cube}-1 do
          begin
               M0 := TMatrix3D( TDoubleM4( Poins[ N ] ) );
               M1 := M * M0;

               for Y := 0 to DivY do
               begin
                    T.Y := Pi / DivY * Y;

                    P.Y := Cos( T.Y );
                    R   := Sin( T.Y );

                    for X := 0 to DivX do
                    begin
                         T.X := Pi2 / DivX * X;

                         P.X := +R * Cos( T.X );
                         P.Z := -R * Sin( T.X );

                         I := XYtoI( N, X, Y );

                         Vertices [ I ] := P * M1;
                         Normals  [ I ] := P * M0;
                         TexCoord0[ I ] := TPointF.Create( X / DivX, Y / DivY );
                    end;
               end;
          end;
     end;
end;

procedure TPoins3D.MakeTopology;
var
   I, N, X0, X1, Y0, Y1 :Integer;
begin
     with _Polygons.IndexBuffer do
     begin
          Length := 3{Vert/Tria} * 2{Tria/Face} * DivY*DivX{Face/Poin} * _Poins.PoinsN{Poin};

          I := 0;
          for N := 0 to _Poins.PoinsN-1 do
          begin
               Y0 := 0;
               for Y1 := 1 to _DivY do
               begin
                    X0 := 0;
                    for X1 := 1 to _DivX do
                    begin
                         //     X0     X1
                         //  Y0 +------+
                         //     |＼    |
                         //     |  ＼  |
                         //     |    ＼|
                         //  Y1 +------+

                         Indices[ I ] := XYtoI( N, X0, Y0 );  Inc( I );
                         Indices[ I ] := XYtoI( N, X1, Y0 );  Inc( I );
                         Indices[ I ] := XYtoI( N, X1, Y1 );  Inc( I );

                         Indices[ I ] := XYtoI( N, X1, Y1 );  Inc( I );
                         Indices[ I ] := XYtoI( N, X0, Y1 );  Inc( I );
                         Indices[ I ] := XYtoI( N, X0, Y0 );  Inc( I );

                         X0 := X1;
                    end;
                    Y0 := Y1;
               end;
          end;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPoins3D.Create( Owner_:TComponent );
begin
     inherited;

     _Polygons := TMeshData.Create;

     _Material := TLightMaterialSource.Create( Self );
     _Material.Specular := TAlphaColors.Null;

     Radius := 5;
     PlotR  := 0.3;
     DivX   := 18;
     DivY   := 9;
end;

destructor TPoins3D.Destroy;
begin
     Poins := nil;

     _Polygons.Free;

     inherited;
end;

end. //######################################################################### ■