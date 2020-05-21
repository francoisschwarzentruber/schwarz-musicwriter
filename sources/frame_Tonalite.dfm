object frameTonalite_Anneau: TframeTonalite_Anneau
  Left = 0
  Top = 0
  Width = 226
  Height = 188
  VertScrollBar.Visible = False
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object lblTonaliteCourante_Nom: TLabel
    Left = 0
    Top = 0
    Width = 226
    Height = 19
    Align = alTop
    Alignment = taCenter
    Caption = 'Do majeur / la mineur'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object panNotes: TPaintBox
    Left = 56
    Top = 48
    Width = 161
    Height = 113
    OnPaint = panNotesPaint
  end
  object lblAddDiese: TLabel
    Left = 16
    Top = 29
    Width = 118
    Height = 14
    Caption = 'ajouter un di'#232'se '#224' la clef'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblAddDieseClick
  end
  object lblAddBemol: TLabel
    Left = 16
    Top = 164
    Width = 120
    Height = 14
    Caption = 'ajouter un b'#233'mol '#224' la clef'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblAddBemolClick
  end
  object lstNotes: TListBox
    Left = 200
    Top = 24
    Width = 57
    Height = 105
    ItemHeight = 14
    Items.Strings = (
      'si#'
      'mi#'
      'la#'
      'r'#233'#'
      'sol#'
      'do#'
      'fa#'
      'si'
      'mi'
      'la'
      'r'#233
      'sol'
      'do'
      'fa'
      'si b'
      'mi b'
      'la b'
      'r'#233' b'
      'sol b'
      'do b'
      'fa b')
    TabOrder = 0
    Visible = False
  end
  object scrTonalite: TScrollBar
    Left = 32
    Top = 48
    Width = 17
    Height = 113
    Kind = sbVertical
    Max = 7
    Min = -7
    PageSize = 0
    TabOrder = 1
    OnChange = scrTonaliteChange
  end
end
