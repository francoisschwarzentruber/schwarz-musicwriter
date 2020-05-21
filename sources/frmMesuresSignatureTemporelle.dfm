object frmMesures_Signature_Temporelle: TfrmMesures_Signature_Temporelle
  Left = 223
  Top = 138
  Width = 285
  Height = 213
  Caption = 'Signature temporelle'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Label4: TLabel
    Left = 24
    Top = 29
    Width = 104
    Height = 14
    Caption = 'Signature temporelle :'
  end
  inline frameRythme: TframeRythme
    Left = 144
    Top = 18
    Width = 49
    Height = 55
    TabOrder = 0
  end
  object chkTaillerMesure: TCheckBox
    Left = 6
    Top = 88
    Width = 233
    Height = 17
    Caption = 'Mettre les barres de mesures correctement'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object cmdApply: TButton
    Left = 16
    Top = 120
    Width = 113
    Height = 25
    Caption = 'Appliquer'
    Default = True
    TabOrder = 2
    OnClick = cmdApplyClick
  end
  object Annuler: TButton
    Left = 136
    Top = 120
    Width = 105
    Height = 25
    Cancel = True
    Caption = 'Annuler'
    TabOrder = 3
  end
end
