unit LUX.FMX.S3;

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
       function XYtoI( const X_,Y_:Integer ) :Integer; inline;
     protected
       _Polygons :TMeshData;
       _Material :TLightMaterialSource;
       _Poins    :TPoins3S;
       _Radius   :Single;
       _DotSize  :TSingle3D;
       _DivX     :Integer;
       _DivY     :Integer;
       ///// A C C E S S O R
       function GetMaterial :TLightMaterialSource;
       procedure UpPoins( Sender_:TObject );
       function GetPoins :TPoins3S;
       procedure SetPoins( const Poins_:TPoins3S );
       function GetRadius :Single;
       procedure SetRadius( const Radius_:Single );
       function GetDotSize :TSingle3D;
       procedure SetDotSize( const DotSize_:TSingle3D );
       function GetDivX :Integer;
       procedure SetDivX( const DivX_:Integer );
       function GetDivY :Integer;
       procedure SetDivY( const DivY_:Integer );
       ///// M E T H O D
       procedure Render; override;
       procedure MakeGeometry; override;
       procedure MakeTopology; override;
       procedure AddSphereG( var J_:Integer; const M_:TSingleM4; const T0_,T1_:Single );
       procedure AddGridT( var J_,I_:Integer );
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property Material :TLightMaterialSource read GetMaterial                 ;
       property Poins    :TPoins3S             read GetPoins    write SetPoins  ;
       property Radius   :Single               read GetRadius   write SetRadius ;
       property DotSize  :TSingle3D            read GetDotSize  write SetDotSize;
       property DivX     :Integer              read GetDivX     write SetDivX   ;
       property DivY     :Integer              read GetDivY     write SetDivY   ;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THemiPoins3D

     THemiPoins3D = class( TPoins3D )
     private
     protected
       ///// M E T H O D
       procedure MakeTopology; override;
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THemiPoinsLo3D

     THemiPoinsLo3D = class( THemiPoins3D )
     private
     protected
       ///// M E T H O D
       procedure MakeGeometry; override;
       procedure AddDiskG( var J_:Integer; const M_:TSingleM4 );
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THemiPoinsUp3D

     THemiPoinsUp3D = class( THemiPoins3D )
     private
     protected
       ///// M E T H O D
       procedure MakeGeometry; override;
       procedure AddDiskG( var J_:Integer; const M_:TSingleM4 );
     public
     end;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPoins3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

function TPoins3D.XYtoI( const X_,Y_:Integer ) :Integer;
begin
     Result := ( _DivX + 1 ) * Y_ + X_;
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

function TPoins3D.GetDotSize :TSingle3D;
begin
     Result := _DotSize;
end;

procedure TPoins3D.SetDotSize( const DotSize_:TSingle3D );
begin
     _DotSize := DotSize_;

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

//------------------------------------------------------------------------------

procedure TPoins3D.MakeGeometry;
var
   M0, M :TSingleM4;
   J, N :Integer;
begin
     _Polygons.VertexBuffer.Length := (DivY+1)*(DivX+1){Vert/Grid} * 1{Grid/Poin} * Poins.PoinsN{Poin};

     M0 := TSingleM4.Translate( 0, Radius, 0 ) * TSingleM4.Scale( _DotSize );

     J := 0;
     for N := 0 to Poins.PoinsN-1 do
     begin
          M := TSingleM4( TSingleQ( Poins[ N ] ) ) * M0;

          AddSphereG( J, M, 0, 1 );
     end;
end;

procedure TPoins3D.MakeTopology;
var
   J, I, N :Integer;
begin
     _Polygons.IndexBuffer.Length := 3{Vert/Tria} * 2{Tria/Face} * DivY*DivX{Face/Grid} * 1{Grid/Poin} *  _Poins.PoinsN{Poin};

     J := 0;  I := 0;
     for N := 0 to _Poins.PoinsN-1 do AddGridT( J, I );
end;

//------------------------------------------------------------------------------

procedure TPoins3D.AddSphereG( var J_:Integer; const M_:TSingleM4; const T0_,T1_:Single );
var
   Mv, Mn :TMatrix3D;
   X, Y :Integer;
   T, A :TPointF;
   P, V, N :TPoint3D;
   R :Single;
begin
     Mv := TMatrix3D( M_ );
     Mn := Mv.Inverse.Transpose;

     for Y := 0 to DivY do
     begin
          T.Y := ( T1_ - T0_ ) * Y / DivY + T0_;
          A.Y := Pi * T.Y;

          P.Y := Cos( A.Y );
          R   := Sin( A.Y );

          for X := 0 to DivX do
          begin
               T.X := X / DivX;
               A.X := Pi2 * T.X;

               P.X := +R * Cos( A.X );
               P.Z := -R * Sin( A.X );

               V :=   P * Mv;
               N := ( P * Mn ).Normalize;

               with _Polygons.VertexBuffer do
               begin
                    Vertices [ J_ ] := V;
                    Normals  [ J_ ] := N;
                    TexCoord0[ J_ ] := T;
               end;
               Inc( J_ );
          end;
     end;
end;

//------------------------------------------------------------------------------

procedure TPoins3D.AddGridT( var J_,I_:Integer );
var
   X0, X1, Y0, Y1 :Integer;
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

               with _Polygons.IndexBuffer do
               begin
                    Indices[ I_ ] := J_ + XYtoI( X0, Y0 );  Inc( I_ );
                    Indices[ I_ ] := J_ + XYtoI( X1, Y0 );  Inc( I_ );
                    Indices[ I_ ] := J_ + XYtoI( X1, Y1 );  Inc( I_ );

                    Indices[ I_ ] := J_ + XYtoI( X1, Y1 );  Inc( I_ );
                    Indices[ I_ ] := J_ + XYtoI( X0, Y1 );  Inc( I_ );
                    Indices[ I_ ] := J_ + XYtoI( X0, Y0 );  Inc( I_ );
               end;

               X0 := X1;
          end;
          Y0 := Y1;
     end;

     Inc( J_, (DivY+1)*(DivX+1) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPoins3D.Create( Owner_:TComponent );
begin
     inherited;

     _Polygons := TMeshData.Create;

     _Material := TLightMaterialSource.Create( Self );
     _Material.Specular := TAlphaColors.Null;

     Radius  := 5;
     DotSize := TSingle3D.Create( 0.3 );
     DivX    := 18;
     DivY    := 9;
end;

destructor TPoins3D.Destroy;
begin
     Poins := nil;

     _Polygons.Free;

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THemiPoins3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

procedure THemiPoins3D.MakeTopology;
var
   J, I, N :Integer;
begin
     _Polygons.IndexBuffer.Length := 3{Vert/Tria} * 2{Tria/Face} * DivY*DivX{Face/Grid} * 2{Grid/Poin} * _Poins.PoinsN{Poin};

     J := 0;  I := 0;
     for N := 0 to _Poins.PoinsN-1 do
     begin
          AddGridT( J, I );
          AddGridT( J, I );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THemiPoinsLo3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

procedure THemiPoinsLo3D.MakeGeometry;
var
   M0, M :TSingleM4;
   I, N :Integer;
begin
     _Polygons.VertexBuffer.Length := (DivY+1)*(DivX+1){Vert/Grid} * 2{Grid/Poin} * Poins.PoinsN{Poin};

     M0 := TSingleM4.Translate( 0, Radius, 0 ) * TSingleM4.Scale( _DotSize );

     I := 0;
     for N := 0 to Poins.PoinsN-1 do
     begin
          M := TSingleM4( TSingleQ( Poins[ N ] ) ) * M0;

          AddSphereG( I, M, 0.5, 1 );
          AddDiskG( I, M );
     end;
end;

//------------------------------------------------------------------------------

procedure THemiPoinsLo3D.AddDiskG( var J_:Integer; const M_:TSingleM4 );
var
   Mv, Mn :TMatrix3D;
   X, Y :Integer;
   S, T, A :TPointF;
   P, V, N :TPoint3D;
   R :Single;
begin
     Mv := TMatrix3D( M_ );
     Mn := Mv.Inverse.Transpose;

     N := ( TPoint3D.Create( 0, +1, 0 ) * Mn ).Normalize;

     P.Y := 0;
     for Y := 0 to DivY do
     begin
          S.Y := Y / DivY;
          T.Y := 0.5 * S.Y;

          R := S.Y;

          for X := 0 to DivX do
          begin
               S.X := X / DivX;
               T.X := S.X;
               A.X := Pi2 * S.X;

               P.X := +R * Cos( A.X );
               P.Z := -R * Sin( A.X );

               V := P * Mv;

               with _Polygons.VertexBuffer do
               begin
                    Vertices [ J_ ] := V;
                    Normals  [ J_ ] := N;
                    TexCoord0[ J_ ] := T;
               end;
               Inc( J_ );
          end;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THemiPoinsUp3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////////// M E T H O D

procedure THemiPoinsUp3D.MakeGeometry;
var
   M0, M :TSingleM4;
   I, N :Integer;
begin
     _Polygons.VertexBuffer.Length := (DivY+1)*(DivX+1){Vert/Grid} * 2{Grid/Poin} * Poins.PoinsN{Poin};

     M0 := TSingleM4.Translate( 0, Radius, 0 ) * TSingleM4.Scale( _DotSize );

     I := 0;
     for N := 0 to Poins.PoinsN-1 do
     begin
          M := TSingleM4( TSingleQ( Poins[ N ] ) ) * M0;

          AddSphereG( I, M, 0.0, 0.5 );
          AddDiskG( I, M );
     end;
end;

//------------------------------------------------------------------------------

procedure THemiPoinsUp3D.AddDiskG( var J_:Integer; const M_:TSingleM4 );
var
   Mv, Mn :TMatrix3D;
   X, Y :Integer;
   S, T, A :TPointF;
   P, V, N :TPoint3D;
   R :Single;
begin
     Mv := TMatrix3D( M_ );
     Mn := Mv.Inverse.Transpose;

     N := ( TPoint3D.Create( 0, -1, 0 ) * Mn ).Normalize;

     P.Y := 0;
     for Y := 0 to DivY do
     begin
          S.Y := Y / DivY;
          T.Y := 0.5 + 0.5 * S.Y;

          R := 1 - S.Y;

          for X := 0 to DivX do
          begin
               S.X := X / DivX;
               T.X := S.X;
               A.X := Pi2 * S.X;

               P.X := +R * Cos( A.X );
               P.Z := -R * Sin( A.X );

               V := P * Mv;

               with _Polygons.VertexBuffer do
               begin
                    Vertices [ J_ ] := V;
                    Normals  [ J_ ] := N;
                    TexCoord0[ J_ ] := T;
               end;
               Inc( J_ );
          end;
     end;
end;

end. //######################################################################### ■