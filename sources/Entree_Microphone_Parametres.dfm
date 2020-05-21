object frmEntree_WaveIn: TfrmEntree_WaveIn
  Left = 207
  Top = 192
  Width = 442
  Height = 443
  Caption = 'Param'#232'tres de l'#39'entr'#233'e microphone'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 24
    Width = 34
    Height = 13
    Caption = 'Driver :'
  end
  object Label2: TLabel
    Left = 32
    Top = 72
    Width = 57
    Height = 13
    Caption = 'Fr'#233'quence :'
  end
  object cmdActiver: TButton
    Left = 192
    Top = 368
    Width = 97
    Height = 25
    Caption = 'Activer'
    Default = True
    TabOrder = 0
    OnClick = cmdActiverClick
  end
  object Button1: TButton
    Left = 304
    Top = 368
    Width = 97
    Height = 25
    Cancel = True
    Caption = 'D'#233'sactiver'
    TabOrder = 1
  end
end
