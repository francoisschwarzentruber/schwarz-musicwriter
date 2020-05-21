program musicwriter_langue_changer;

uses
  Forms,
  langue_fenetre in 'sources\langue_fenetre.pas' {Form1},
  langues in 'sources\langues.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
