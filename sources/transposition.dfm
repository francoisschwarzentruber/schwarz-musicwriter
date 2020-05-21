object frmTransposition: TfrmTransposition
  Left = 232
  Top = 120
  BorderStyle = bsDialog
  Caption = 'Transposition'
  ClientHeight = 183
  ClientWidth = 226
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    226
    183)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 189
    Height = 14
    Caption = 'Je veux transposer la s'#233'lection d'#39'une...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object TabControl: TTabControl
    Left = 8
    Top = 32
    Width = 209
    Height = 113
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MultiLine = True
    ParentFont = False
    TabOrder = 0
    Tabs.Strings = (
      '&octave...'
      '&quinte...'
      '&seconde...')
    TabIndex = 0
    object Label2: TLabel
      Left = 40
      Top = 40
      Width = 66
      Height = 14
      Caption = '...vers le haut'
    end
    object Label3: TLabel
      Left = 40
      Top = 80
      Width = 63
      Height = 14
      Caption = '...vers le bas'
    end
    object cmdPlus: TSpeedButton
      Left = 144
      Top = 32
      Width = 41
      Height = 33
      Caption = '&+'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -24
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = cmdPlusClick
    end
    object cmdMoins: TSpeedButton
      Left = 144
      Top = 72
      Width = 41
      Height = 33
      Caption = '&-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -24
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = cmdMoinsClick
    end
  end
  object BitBtn3: TBitBtn
    Left = 96
    Top = 152
    Width = 113
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Fermer'
    TabOrder = 1
    OnClick = BitBtn3Click
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
      F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
      000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
      338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
      45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
      3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
      F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
      000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
      338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
      4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
      8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
      333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
      0000}
    NumGlyphs = 2
  end
end
