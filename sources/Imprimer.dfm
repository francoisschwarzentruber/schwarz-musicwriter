object frmImprimer: TfrmImprimer
  Left = 277
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Imprimer la partition'
  ClientHeight = 523
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    408
    523)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 168
    Width = 393
    Height = 321
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Imprimer le document'
      object Label1: TLabel
        Left = 48
        Top = 144
        Width = 333
        Height = 26
        Caption = 
          'Yo ! Pour imprimer toute ta partition, on va commencer par impri' +
          'mer les pages impaires.'
        WordWrap = True
      end
      object Label2: TLabel
        Left = 56
        Top = 224
        Width = 329
        Height = 39
        Caption = 
          'Attends un peu... ou plut'#244't fais autre chose... maintenant, tu r' +
          'etournes ton paquet (correctement, d'#233'merde-toi...) et on imprime' +
          ' les pages paires...'
        WordWrap = True
      end
      object Label6: TLabel
        Left = 48
        Top = 88
        Width = 133
        Height = 13
        Caption = 'On imprime tout dans l'#39'odre :'
        WordWrap = True
      end
      object Label7: TLabel
        Left = 16
        Top = 56
        Width = 107
        Height = 20
        Caption = '2 solutions :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        WordWrap = True
      end
      object Label8: TLabel
        Left = 8
        Top = 88
        Width = 26
        Height = 20
        Caption = '1)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        WordWrap = True
      end
      object Label9: TLabel
        Left = 8
        Top = 144
        Width = 26
        Height = 20
        Caption = '2)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        WordWrap = True
      end
      object Bevel1: TBevel
        Left = 0
        Top = 80
        Width = 385
        Height = 49
      end
      object Bevel2: TBevel
        Left = 0
        Top = 136
        Width = 385
        Height = 153
      end
      object Label5: TLabel
        Left = 248
        Top = 16
        Width = 6
        Height = 13
        Caption = #224
        WordWrap = True
      end
      object Label4: TLabel
        Left = 40
        Top = 16
        Width = 112
        Height = 13
        Caption = 'Consid'#233'rons les pages :'
        WordWrap = True
      end
      object Button2: TButton
        Left = 240
        Top = 252
        Width = 137
        Height = 25
        Caption = 'Imprimer les pages paires'
        TabOrder = 0
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 240
        Top = 184
        Width = 137
        Height = 25
        Caption = 'Imprimer les pages impaires'
        TabOrder = 1
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 240
        Top = 96
        Width = 137
        Height = 25
        Caption = 'Imprimer les pages...'
        TabOrder = 2
        OnClick = Button4Click
      end
      object txtPageFrom: TEdit
        Left = 184
        Top = 16
        Width = 49
        Height = 21
        TabOrder = 3
        Text = '1'
      end
      object txtPageTo: TEdit
        Left = 272
        Top = 16
        Width = 57
        Height = 21
        TabOrder = 4
        Text = '1'
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Imprimer tous les documents ouverts (faire un livre)'
      ImageIndex = 1
      object Button5: TButton
        Left = 96
        Top = 72
        Width = 193
        Height = 41
        Caption = 'POUF !!!'
        TabOrder = 0
        OnClick = Button5Click
      end
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 393
    Height = 145
    Caption = 'Sur quelle imprimante imprimer ?'
    TabOrder = 1
    object Label3: TLabel
      Left = 16
      Top = 100
      Width = 90
      Height = 12
      Caption = 'Zoom pour imprimer :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label10: TLabel
      Left = 16
      Top = 52
      Width = 97
      Height = 12
      Caption = 'R'#233'solution horizontale :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label11: TLabel
      Left = 16
      Top = 76
      Width = 89
      Height = 12
      Caption = 'R'#233'solution verticale :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label12: TLabel
      Left = 16
      Top = 28
      Width = 92
      Height = 12
      Caption = 'Nom de l'#39'imprimante :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object txtZoomImpression: TEdit
      Left = 136
      Top = 100
      Width = 49
      Height = 20
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Text = '200'
    end
    object txtResolutionHorizontale: TEdit
      Left = 136
      Top = 52
      Width = 49
      Height = 20
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = '200'
    end
    object txtResolutionVerticale: TEdit
      Left = 136
      Top = 76
      Width = 49
      Height = 20
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      Text = '200'
    end
    object Button6: TButton
      Left = 200
      Top = 59
      Width = 185
      Height = 25
      Caption = 'Modifier ou configurer l'#39'imprimante...'
      TabOrder = 3
      OnClick = Button6Click
    end
    object chkPrintInFile: TCheckBox
      Left = 200
      Top = 96
      Width = 177
      Height = 17
      Caption = 'Imprimer dans des fichiers BMP'
      TabOrder = 4
      Visible = False
    end
    object txtImprimanteNom: TEdit
      Left = 136
      Top = 28
      Width = 225
      Height = 20
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
      Text = '200'
    end
  end
  object BitBtn3: TBitBtn
    Left = 305
    Top = 496
    Width = 89
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Fermer'
    ModalResult = 2
    TabOrder = 2
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
  object Panel1: TPanel
    Left = 8
    Top = 168
    Width = 385
    Height = 337
    Caption = 'Panel1'
    TabOrder = 3
    Visible = False
    object Label13: TLabel
      Left = 1
      Top = 1
      Width = 72
      Height = 13
      Caption = 'Quoi imprimer ?'
    end
    object Label14: TLabel
      Left = 1
      Top = 185
      Width = 94
      Height = 13
      Caption = 'Comment imprimer ?'
    end
    object CheckListBox1: TCheckListBox
      Left = 1
      Top = 25
      Width = 353
      Height = 129
      ItemHeight = 13
      Items.Strings = (
        'Tout le conducteur'
        'Partie piano'
        'Partie violon'
        'Partition contenant exactement les port'#233'es affich'#233'es '#224' l'#39#233'cran')
      TabOrder = 0
    end
    object ComboBox1: TComboBox
      Left = 1
      Top = 201
      Width = 249
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 1
      Text = 'Imprimer toutes les pages'
      Items.Strings = (
        'Imprimer toutes les pages'
        'Imprimer que les pages paires'
        'Imprimer que les pages impaires')
    end
    object Button1: TButton
      Left = 185
      Top = 241
      Width = 137
      Height = 25
      Caption = 'Imprimer !'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object PrinterSetupDialog: TPrinterSetupDialog
    Left = 360
    Top = 72
  end
end
