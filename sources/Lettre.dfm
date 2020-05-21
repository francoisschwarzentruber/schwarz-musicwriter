object frmLettre: TfrmLettre
  Left = 645
  Top = 408
  BorderStyle = bsDialog
  Caption = 'Lettre'
  ClientHeight = 64
  ClientWidth = 194
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblResultat: TLabel
    Left = 96
    Top = 24
    Width = 49
    Height = 13
    Caption = 'lblResultat'
  end
  object txtLettre: TEdit
    Left = 16
    Top = 16
    Width = 57
    Height = 32
    CharCase = ecUpperCase
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 1
    ParentFont = False
    TabOrder = 0
    Text = 'A'
    OnChange = txtLettreChange
  end
end
