object frmVoix: TfrmVoix
  Left = 394
  Top = 222
  Width = 420
  Height = 427
  Caption = 'Gestion des voix'
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
  OnResize = FormResize
  DesignSize = (
    412
    400)
  PixelsPerInch = 96
  TextHeight = 14
  object lblVoix: TLabel
    Left = 152
    Top = 96
    Width = 67
    Height = 14
    Caption = 'Liste des voix'
  end
  object Label2: TLabel
    Left = 8
    Top = 96
    Width = 109
    Height = 14
    Caption = 'Liste des instruments :'
  end
  object lstVoix: TListBox
    Left = 152
    Top = 112
    Width = 250
    Height = 250
    Style = lbOwnerDrawFixed
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 22
    PopupMenu = PopupMenu
    TabOrder = 0
    OnDblClick = lstVoixDblClick
    OnDrawItem = lstVoixDrawItem
    OnMouseUp = lstVoixMouseUp
  end
  object BitBtn1: TBitBtn
    Left = 313
    Top = 369
    Width = 89
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Fermer'
    TabOrder = 1
    Kind = bkClose
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 412
    Height = 41
    ButtonHeight = 37
    ButtonWidth = 119
    Caption = 'ToolBar1'
    Images = MainForm.imgList
    ShowCaptions = True
    TabOrder = 2
    object tbnVoixAutomatique: TToolButton
      Left = 0
      Top = 2
      Hint = 
        'Bascule dans le mode automatique de la gestion des voix (le logi' +
        'ciel devine dans quel voix on tente d'#39#233'crire)'
      Caption = 'Mode Voix automatique'
      Down = True
      ImageIndex = 60
      Style = tbsCheck
      OnClick = tbnVoixAutomatiqueClick
    end
    object tbnNvVoix: TToolButton
      Left = 119
      Top = 2
      Hint = 
        'Cliquer ici si vous voulez ajouter une nouvelle voix... d'#232's la p' +
        'remi'#232're note '#233'crite, vous resterez dans cette voix (ps : cela d'#233 +
        'active le mode automatique)'
      Caption = 'Nouvelle voix'
      ImageIndex = 61
      Style = tbsCheck
      OnClick = tbnNvVoixClick
    end
    object ToolButton1: TToolButton
      Left = 238
      Top = 2
      Caption = 'Ajouter des paroles'
      ImageIndex = 69
      OnClick = ToolButton1Click
    end
  end
  object cmdAllerDansLaVoix: TBitBtn
    Left = 169
    Top = 369
    Width = 137
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Aller dans la voix'
    TabOrder = 3
    OnClick = cmdAllerDansLaVoixClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00344446333334
      44433333FFFF333333FFFF33000033AAA43333332A4333338833F33333883F33
      00003332A46333332A4333333383F33333383F3300003332A2433336A6633333
      33833F333383F33300003333AA463362A433333333383F333833F33300003333
      6AA4462A46333333333833FF833F33330000333332AA22246333333333338333
      33F3333300003333336AAA22646333333333383333F8FF33000033444466AA43
      6A43333338FFF8833F383F330000336AA246A2436A43333338833F833F383F33
      000033336A24AA442A433333333833F33FF83F330000333333A2AA2AA4333333
      333383333333F3330000333333322AAA4333333333333833333F333300003333
      333322A4333333333333338333F333330000333333344A433333333333333338
      3F333333000033333336A24333333333333333833F333333000033333336AA43
      33333333333333833F3333330000333333336663333333333333333888333333
      0000}
    NumGlyphs = 2
  end
  object Panel1: TPanel
    Left = 0
    Top = 48
    Width = 412
    Height = 41
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    object lblInfo: TLabel
      Left = 8
      Top = 6
      Width = 137
      Height = 33
      AutoSize = False
      Caption = 'La voix courante est la plus proche du curseur, ie :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object panVoixSelectionnee: TPaintBox
      Left = 143
      Top = 10
      Width = 162
      Height = 22
      Hint = 
        'Ce pictogramme repr'#233'sente la voix courante. Clique dessus pour f' +
        'aire apparaitre le gestionnaire des voix.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      OnPaint = panVoixSelectionneePaint
    end
  end
  inline frameComposition_Instruments: TframeComposition_Instruments
    Left = 8
    Top = 112
    Width = 137
    Height = 249
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 5
    inherited list: TListBox
      Width = 137
      Height = 249
    end
  end
  object PopupMenu: TPopupMenu
    Left = 160
    Top = 104
    object Voixsolo1: TMenuItem
      Caption = 'Voix solo'
      OnClick = Voixsolo1Click
    end
    object Portesolo1: TMenuItem
      Tag = 1
      Caption = 'Port'#233'e solo'
      OnClick = Voixsolo1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Entendrelavox1: TMenuItem
      Tag = 2
      Caption = 'Entendre la voix'
      OnClick = Voixsolo1Click
    end
    object Entendrelaporte1: TMenuItem
      Tag = 3
      Caption = 'Entendre la port'#233'e'
      OnClick = Voixsolo1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Chutlavoix1: TMenuItem
      Tag = 4
      Caption = 'Chut! la voix'
      OnClick = Voixsolo1Click
    end
    object Chutlaporte1: TMenuItem
      Tag = 5
      Caption = 'Chut! la port'#233'e'
      OnClick = Voixsolo1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Voirlavoix1: TMenuItem
      Tag = 6
      Caption = 'Voir la voix'
      OnClick = Voixsolo1Click
    end
    object Voirlaporte1: TMenuItem
      Tag = 7
      Caption = 'Voir la port'#233'e'
      OnClick = Voixsolo1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Cacherlavoix1: TMenuItem
      Tag = 8
      Caption = 'Cacher la voix'
      OnClick = Voixsolo1Click
    end
    object Cacherlaporte1: TMenuItem
      Tag = 9
      Caption = 'Cacher la port'#233'e'
      OnClick = Voixsolo1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Entendretout1: TMenuItem
      Tag = 10
      Caption = 'Entendre tout'
      OnClick = Voixsolo1Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Voirtout1: TMenuItem
      Tag = 11
      Caption = 'Voir tout'
      OnClick = Voixsolo1Click
    end
  end
end
