object frmMesures_Tempo: TfrmMesures_Tempo
  Left = 606
  Top = 129
  Width = 294
  Height = 149
  Caption = 'Tempo'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label3: TLabel
    Left = 24
    Top = 21
    Width = 75
    Height = 14
    Caption = 'Tempo affich'#233' :'
  end
  object Edit3: TEdit
    Left = 24
    Top = 40
    Width = 185
    Height = 22
    TabOrder = 0
    Text = 'Allegro'
  end
  object cmdApply: TButton
    Left = 24
    Top = 80
    Width = 113
    Height = 25
    Caption = 'Appliquer'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = cmdApplyClick
  end
  object Annuler: TButton
    Left = 144
    Top = 80
    Width = 105
    Height = 25
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 2
    OnClick = AnnulerClick
  end
end
