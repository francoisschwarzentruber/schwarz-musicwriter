object frmMessageViteFait: TfrmMessageViteFait
  Left = 280
  Top = 242
  AlphaBlend = True
  AlphaBlendValue = 192
  BorderStyle = bsNone
  BorderWidth = 1
  Caption = 'frmMessageViteFait'
  ClientHeight = 88
  ClientWidth = 517
  Color = clWhite
  TransparentColorValue = clWhite
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 517
    Height = 88
    Align = alClient
    Caption = 'Label1'
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    WordWrap = True
  end
  object tmr: TTimer
    Enabled = False
    OnTimer = tmrTimer
    Left = 400
  end
end
