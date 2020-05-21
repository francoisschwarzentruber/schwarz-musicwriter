unit frame_Instruments_Choix;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls;

type

  TOnChange = procedure of Object;

  TframeInstruments_Choix = class(TFrame)
    lstInstruments: TListView;
    txtInstrumentSubStr: TEdit;
    Image2: TImage;
    Label1: TLabel;
    pbInstrument: TPaintBox;
    procedure lstInstrumentsCustomDraw(Sender: TCustomListView;
      const ARect: TRect; var DefaultDraw: Boolean);
    procedure txtInstrumentSubStrChange(Sender: TObject);
    procedure pbInstrumentPaint(Sender: TObject);
    procedure lstInstrumentsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FrameResize(Sender: TObject);
  private
     IsLancerOnChange: Boolean;
     FOnChange: TOnChange;
     procedure lstInstruments_Actualiser;
     procedure LancerOnChange;
    { Déclarations privées }
  public
    { Déclarations publiques }

    
    Function InstrumentNumero_Get: integer;
    Procedure InstrumentNumero_Set(instru: integer);

  published
    property OnChange: TOnChange Read FOnChange Write FOnChange;
  end;

implementation

{$R *.dfm}

uses Instruments, Main; {pour INSTRUMENTS_INDICE_MAX}









procedure TframeInstruments_Choix.LancerOnChange;
Begin
    if IsLancerOnChange then
    if @FOnChange <> nil then
       OnChange;
End;



procedure TframeInstruments_Choix.lstInstruments_Actualiser;

var item : TListItem;
    i: integer;
    s: string;
    substr: string;
Begin
     lstInstruments.Items.BeginUpdate;

     lstInstruments.Clear;

     substr := LowerCase(txtInstrumentSubStr.Text);
     for i := 0 to INSTRUMENTS_INDICE_MAX do
     if IsInstrument_DansListeStandard(i) then
     Begin
         s := GetInstrumentNom(i);

         if (substr = '') or (Pos(substr, LowerCase(s)) <> 0) then
         Begin
               item := lstInstruments.Items.Add;
               item.ImageIndex := i + 1;
               item.Caption := s;
         End;

     End;

     IsLancerOnChange := false;
     lstInstruments.Items.EndUpdate;
     IsLancerOnChange := true;
End;





procedure TframeInstruments_Choix.lstInstrumentsCustomDraw(
  Sender: TCustomListView; const ARect: TRect; var DefaultDraw: Boolean);
begin
    if lstInstruments.Items.Count = 0 then
          lstInstruments_Actualiser;
     IsLancerOnChange := true;
end;



Function TframeInstruments_Choix.InstrumentNumero_Get: integer;
Begin
    if lstInstruments.ItemFocused = nil then
        result := 0
    else
        result := lstInstruments.ItemFocused.ImageIndex - 1;
End;


Procedure TframeInstruments_Choix.InstrumentNumero_Set(instru: integer);
var i: integer;
Begin
     txtInstrumentSubStr.Text := '';

     for i := 0 to lstInstruments.Items.Count - 1 do
          if (lstInstruments.Items[i].ImageIndex - 1 = instru) then
          BEgin
                lstInstruments.ItemFocused := lstInstruments.Items[i];
                lstInstruments.ItemFocused.Selected := true;
                Break;
          End;


End;

procedure TframeInstruments_Choix.txtInstrumentSubStrChange(
  Sender: TObject);
begin
       lstInstruments_Actualiser;
end;

procedure TframeInstruments_Choix.pbInstrumentPaint(Sender: TObject);
var instru: integer;
begin
      if MainForm = nil then
              Exit;

      if MainForm.imgIconesInstruments = nil then
           exit;

      With pbInstrument do
      Begin
          Canvas.Brush.Color := clWhite;
          Canvas.Rectangle(pbInstrument.ClientRect);

          instru := InstrumentNumero_Get;
          MainForm.imgIconesInstruments.Draw(Canvas,
                     2,
                     2,instru + 1 );

          Canvas.TextOut(20, 2,
               GetInstrumentNom(instru));
      End;
end;

procedure TframeInstruments_Choix.lstInstrumentsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
    pbInstrumentPaint(nil);
    LancerOnChange;

end;

procedure TframeInstruments_Choix.FrameResize(Sender: TObject);
begin
     if lstInstruments.LargeImages = nil then
           lstInstruments.LargeImages := MainForm.imgIconesInstruments;
end;

end.
