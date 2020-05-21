object frmVoixListeViteFait: TfrmVoixListeViteFait
  Left = 716
  Top = 243
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'frmVoixListeViteFait'
  ClientHeight = 246
  ClientWidth = 123
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
  object lstVoix: TListBox
    Left = 0
    Top = 0
    Width = 122
    Height = 209
    Style = lbOwnerDrawFixed
    BorderStyle = bsNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 22
    ParentFont = False
    TabOrder = 0
    OnDrawItem = lstVoixDrawItem
  end
  object tmr: TTimer
    Enabled = False
    OnTimer = tmrTimer
    Left = 32
    Top = 8
  end
end
