unit LUX.FMX.Graphics.D3.Shaper;

interface //#################################################################### ■

uses System.SysUtils, System.RTLConsts, System.Classes,
     System.Types, System.UITypes, System.Math.Vectors,
     FMX.Types3D, FMX.Controls3D, FMX.MaterialSources,
     LUX,
     LUX.FMX.Graphics.D3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TF3DSphere

     TF3DSphere = class( TF3DShaper )
     private
       ///// M E T H O D
       function XYtoI( const X_,Y_:Integer ) :Integer; inline;
     protected
       _Polygons :TMeshData;
       _Material :TLightMaterialSource;
       _DivX     :Integer;
       _DivY     :Integer;
       ///// A C C E S S O R
       procedure SetDivX( const DivX_:Integer );
       procedure SetDivY( const DivY_:Integer );
       ///// M E T H O D
       procedure Render; override;
       procedure MakeGeometry; override;
       procedure MakeTopology; override;
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property Material :TLightMaterialSource read _Material write   _Material;
       property DivX     :Integer              read _DivX     write SetDivX    ;
       property DivY     :Integer              read _DivY     write SetDivY    ;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TF3DSphere

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

function TF3DSphere.XYtoI( const X_,Y_:Integer ) :Integer;
begin
     Result := ( _DivX + 1 ) * Y_ + X_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TF3DSphere.SetDivX( const DivX_:Integer );
begin
     _DivX := DivX_;  upGeometry := True;  upTopology := True;
end;

procedure TF3DSphere.SetDivY( const DivY_:Integer );
begin
     _DivY := DivY_;  upGeometry := True;  upTopology := True;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TF3DSphere.Render;
begin
     inherited;

     _Polygons.Render( Context, TMaterialSource.ValidMaterial( _Material ), AbsoluteOpacity );
end;

//------------------------------------------------------------------------------

procedure TF3DSphere.MakeGeometry;
var
   X, Y, I :Integer;
   T :TPointF;
   R :Single;
   P :TPoint3D;
begin
     with _Polygons.VertexBuffer do
     begin
          Length := ( _DivX + 1 ) * ( _DivY + 1 );

          for Y := 0 to _DivY do
          begin
               T.Y := Pi / _DivY * Y;

               for X := 0 to _DivX do
               begin
                    T.X := Pi2 / _DivX * X;

                    P.Y := Cos( T.Y );
                      R := Sin( T.Y );
                    P.X := +R * Cos( T.X );
                    P.Z := -R * Sin( T.X );

                    I := XYtoI( X, Y );

                    Vertices [ I ] := P;
                    Normals  [ I ] := P;
                    TexCoord0[ I ] := TPointF.Create( X / _DivX, Y / _DivY );
               end;
          end;
     end;
end;

procedure TF3DSphere.MakeTopology;
var
   X, Y, I :Integer;
begin
     with _Polygons.IndexBuffer do
     begin
          Length := 3{Poin} * 2{Face} * _DivX * _DivY;

          I := 0;
          for Y := 0 to _DivY-1 do
          begin
               for X := 0 to _DivX-1 do
               begin
                    //     X0     X1
                    //  Y0 +------+
                    //     |＼    |
                    //     |  ＼  |
                    //     |    ＼|
                    //  Y1 +------+

                    Indices[ I ] := XYtoI( X  , Y   );  Inc( I );
                    Indices[ I ] := XYtoI( X+1, Y   );  Inc( I );
                    Indices[ I ] := XYtoI( X+1, Y+1 );  Inc( I );

                    Indices[ I ] := XYtoI( X+1, Y+1 );  Inc( I );
                    Indices[ I ] := XYtoI( X  , Y+1 );  Inc( I );
                    Indices[ I ] := XYtoI( X  , Y   );  Inc( I );
               end;
          end;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TF3DSphere.Create( Owner_:TComponent );
begin
     inherited;

     _Polygons := TMeshData.Create;

     _Material := TLightMaterialSource.Create( Self );
     _Material.Specular := TAlphaColors.Null;

     DivX := 36;
     DivY := 18;
end;

destructor TF3DSphere.Destroy;
begin
     _Polygons.Free;

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■