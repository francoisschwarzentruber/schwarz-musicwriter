object frmIntro: TfrmIntro
  Left = 329
  Top = 188
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  AlphaBlend = True
  AlphaBlendValue = 64
  AutoSize = True
  BorderStyle = bsNone
  ClientHeight = 185
  ClientWidth = 281
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    281
    185)
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 281
    Height = 185
    AutoSize = True
    OnClick = Image1Click
  end
  object lblInfo: TLabel
    Left = 0
    Top = 147
    Width = 272
    Height = 14
    Alignment = taRightJustify
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Caption = 'Chargement...'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lblPeripheriqueMIDIDetecte: TLabel
    Left = 3
    Top = 112
    Width = 276
    Height = 22
    Alignment = taRightJustify
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Caption = 'Synth'#233'tiseur externe d'#233'tect'#233' !'
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    Visible = False
  end
end
