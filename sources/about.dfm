object AboutBox: TAboutBox
  Left = 264
  Top = 201
  BorderStyle = bsDialog
  Caption = 'A propos'
  ClientHeight = 247
  ClientWidth = 368
  Color = clBtnFace
  TransparentColorValue = clYellow
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object ProgramIcon: TImage
    Left = 8
    Top = 24
    Width = 121
    Height = 201
    IsControl = True
  end
  object ProductName: TLabel
    Left = 144
    Top = 8
    Width = 67
    Height = 19
    Caption = 'Schwarz'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    IsControl = True
  end
  object Version: TLabel
    Left = 168
    Top = 56
    Width = 91
    Height = 18
    Caption = 'Version Beta'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    IsControl = True
  end
  object Label1: TLabel
    Left = 144
    Top = 176
    Width = 193
    Height = 25
    AutoSize = False
    Caption = '2002-2006. Copyright Schwarz Corporation'
    WordWrap = True
    IsControl = True
  end
  object Label2: TLabel
    Left = 144
    Top = 104
    Width = 137
    Height = 17
    AutoSize = False
    Caption = 'Fran'#231'ois Schwarzentruber'
    WordWrap = True
    IsControl = True
  end
  object Label3: TLabel
    Left = 144
    Top = 88
    Width = 105
    Height = 17
    AutoSize = False
    Caption = 'd'#233'velopp'#233' par '
    WordWrap = True
    IsControl = True
  end
  object Label4: TLabel
    Left = 144
    Top = 136
    Width = 105
    Height = 17
    AutoSize = False
    Caption = 'utilisation offerte '#224
    WordWrap = True
    IsControl = True
  end
  object Label5: TLabel
    Left = 144
    Top = 152
    Width = 57
    Height = 17
    AutoSize = False
    Caption = 'moi-m'#234'me'
    WordWrap = True
    IsControl = True
  end
  object Label6: TLabel
    Left = 152
    Top = 24
    Width = 138
    Height = 29
    Caption = 'MusicWriter'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    IsControl = True
  end
  object OKButton: TButton
    Left = 280
    Top = 210
    Width = 65
    Height = 23
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    IsControl = True
  end
  object Button1: TButton
    Left = 280
    Top = 56
    Width = 73
    Height = 25
    Caption = 'Infos...'
    TabOrder = 1
    OnClick = Button1Click
  end
end
