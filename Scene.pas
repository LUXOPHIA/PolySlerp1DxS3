unit Scene;

interface //#################################################################### ■

uses LUX.FMX.Sphere,
     LUX.FMX.S3;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

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

uses LUX.D3,
     Main;

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
          _Sphere3D.Radius := 4.7;

          _Poins3D := TPoins3D.Create( _World3D );
          _Poins3D.Radius  := 5;
          _Poins3D.DotSize := TSingle3D.Create( 0.3 );
          _Poins3D.DivX    := 20;
          _Poins3D.DivY    := 10;
          _Poins3D.Material.Texture.LoadFromFile( '..\..\_DATA\Poin 180x90.png' );

          _Plots3D0 := THemiPoinsLo3D.Create( _World3D );
          _Plots3D0.Poins   := _Plots3S0;
          _Plots3D0.Radius  := 5;
          _Plots3D0.DotSize := TSingle3D.Create( 0.15 );
          _Plots3D0.DivX    := 20;
          _Plots3D0.DivY    :=  5;
          _Plots3D0.Material.Texture.LoadFromFile( '..\..\_DATA\Poin0 180x90.png' );

          _Plots3D1 := THemiPoinsUp3D.Create( _World3D );
          _Plots3D1.Poins   := _Plots3S1;
          _Plots3D1.Radius  := 5;
          _Plots3D1.DotSize := TSingle3D.Create( 0.15 );
          _Plots3D1.DivX    := 20;
          _Plots3D1.DivY    :=  5;
          _Plots3D1.Material.Texture.LoadFromFile( '..\..\_DATA\Poin1 180x90.png' );
     end;
end;

end. //######################################################################### ■