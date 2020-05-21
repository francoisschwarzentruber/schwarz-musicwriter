object frmParoles: TfrmParoles
  Left = 376
  Top = 248
  Width = 451
  Height = 344
  Caption = 'Paroles'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  DesignSize = (
    443
    317)
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 24
    Top = 8
    Width = 83
    Height = 14
    Caption = 'Voix concern'#233'e :'
  end
  object panVoixAvecParoles: TPaintBox
    Left = 127
    Top = 8
    Width = 146
    Height = 25
    Hint = 
      'Ce pictogramme repr'#233'sente la voix courante. Clique dessus pour f' +
      'aire apparaitre le gestionnaire des voix.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    OnPaint = panVoixAvecParolesPaint
  end
  object Label2: TLabel
    Left = 24
    Top = 96
    Width = 42
    Height = 14
    Caption = 'Paroles :'
  end
  object Memo: TMemo
    Left = 8
    Top = 120
    Width = 429
    Height = 160
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'Memo')
    TabOrder = 0
    WantReturns = False
    WantTabs = True
    OnChange = MemoChange
  end
  object BitBtn1: TBitBtn
    Left = 346
    Top = 284
    Width = 89
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Fermer'
    ModalResult = 1
    TabOrder = 1
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
  object ToolBar1: TToolBar
    Left = 0
    Top = 40
    Width = 443
    Height = 41
    Align = alNone
    Anchors = [akLeft, akTop, akRight]
    ButtonHeight = 37
    ButtonWidth = 190
    Caption = 'ToolBar1'
    Images = MainForm.imgList
    ShowCaptions = True
    TabOrder = 2
    object ToolButton1: TToolButton
      Left = 0
      Top = 2
      Caption = 'Ins'#233'rer un s'#233'parateur de syllabe (tab)'
      ImageIndex = 70
      OnClick = ToolButton1Click
    end
  end
end
