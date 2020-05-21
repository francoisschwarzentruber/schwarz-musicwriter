unit FonctionsAcess;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmFonctionsAccess = class(TForm)
    Label1: TLabel;
    txtSearch: TEdit;
    lstFunctions: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure txtSearchChange(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmFonctionsAccess: TfrmFonctionsAccess;

implementation

uses MusicUser;


var functions: TStrings;

{$R *.dfm}

procedure TfrmFonctionsAccess.FormCreate(Sender: TObject);
begin
    functions := TStringList.Create;
    functions.LoadFromFile(DossierRacine + 'interface_help\functionsaccess.txt');
end;

procedure TfrmFonctionsAccess.txtSearchChange(Sender: TObject);
var mot: string;
    i : integer;
    
begin
     mot := txtSearch.Text;

     lstFunctions.Clear;

     if mot = '' then exit;

     for i := 0 to Functions.Count - 1 do
         if Pos(LowerCase(mot),LowerCase(Functions.Strings[i])) > 0 then
                lstFunctions.AddItem(Functions.Strings[i], nil);
end;

end.
