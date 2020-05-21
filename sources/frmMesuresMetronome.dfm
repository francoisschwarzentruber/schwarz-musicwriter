object frmMesures_Metronome: TfrmMesures_Metronome
  Left = 354
  Top = 473
  BorderStyle = bsDialog
  Caption = 'M'#233'tronome'
  ClientHeight = 137
  ClientWidth = 267
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 40
    Top = 42
    Width = 25
    Height = 17
    Picture.Data = {
      07544269746D61709E010000424D9E0100000000000036000000280000000D00
      000009000000010018000000000068010000C40E0000C40E0000000000000000
      0000C0C0C0000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C000000000000000000000000000000000C0C0C0C0C0C0C0
      C0C0000000000000000000000000000000000000000000000000000000000000
      00C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000C0C0C0000000
      000000C0C0C0000000C0C0C0C0C0C0C0C0C00000000000000000000000000000
      0000C0C0C0C0C0C0C0C0C0C0C0C0000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C000C0C0C0C0C0C0C0C0C0C0C0C0000000C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000C0C0C0C0C0C0C0C0C0C0C0C00000
      00C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000C0C0C0C0C0C0
      C0C0C0C0C0C0000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C000C0C0C0C0C0C0C0C0C0C0C0C0000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0C0C0C000}
  end
  object Label5: TLabel
    Left = 24
    Top = 29
    Width = 59
    Height = 13
    Caption = 'M'#233'tronome :'
  end
  object txtMetronome: TEdit
    Left = 80
    Top = 37
    Width = 105
    Height = 22
    TabOrder = 0
    Text = '200'
  end
  object cmdApply: TButton
    Left = 16
    Top = 80
    Width = 113
    Height = 25
    Caption = 'Appliquer'
    Default = True
    TabOrder = 1
    OnClick = cmdApplyClick
  end
  object Annuler: TButton
    Left = 136
    Top = 80
    Width = 105
    Height = 25
    Cancel = True
    Caption = 'Annuler'
    TabOrder = 2
  end
end
