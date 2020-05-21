object frameDureeChoix: TframeDureeChoix
  Left = 0
  Top = 0
  Width = 307
  Height = 246
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -9
  Font.Name = 'Arial'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object Label1: TLabel
    Left = 7
    Top = 184
    Width = 85
    Height = 12
    Caption = 'Dur'#233'e (en fraction) :'
  end
  object tlbNotes: TToolBar
    Left = 0
    Top = 0
    Width = 73
    Height = 185
    Align = alNone
    ButtonHeight = 20
    ButtonWidth = 50
    Caption = 'Notes'
    Color = clBtnFace
    DragCursor = crArrow
    DragKind = dkDock
    EdgeBorders = []
    EdgeInner = esNone
    EdgeOuter = esNone
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowCaptions = True
    ShowHint = True
    TabOrder = 0
    object tbnRonde: TToolButton
      Left = 0
      Top = 0
      Hint = 'Dur'#233'e de ronde/pause'
      Caption = 'Rondes'
      Grouped = True
      ImageIndex = 1
      Wrap = True
      Style = tbsCheck
      OnClick = tbnCrocheClick
    end
    object tbnBlanche: TToolButton
      Left = 0
      Top = 20
      Hint = 'Dur'#233'e de blanche/demi-pause'
      Caption = 'Blanche'
      Grouped = True
      ImageIndex = 2
      Wrap = True
      Style = tbsCheck
      OnClick = tbnCrocheClick
    end
    object tbnNoire: TToolButton
      Left = 0
      Top = 40
      Hint = 'Dur'#233'e de nNoire/soupir'
      Caption = 'Noire'
      Down = True
      Grouped = True
      ImageIndex = 3
      Wrap = True
      Style = tbsCheck
      OnClick = tbnCrocheClick
    end
    object tbnCroche: TToolButton
      Left = 0
      Top = 60
      Hint = 'Dur'#233'e de croche/demi-soupir'
      Caption = 'Croche'
      Grouped = True
      ImageIndex = 4
      Wrap = True
      Style = tbsCheck
      OnClick = tbnCrocheClick
    end
    object tbnDbCroche: TToolButton
      Left = 0
      Top = 80
      Hint = 'Dur'#233'e de double-croche/quart de soupir'
      Caption = 'Db-croche'
      Grouped = True
      ImageIndex = 5
      Style = tbsCheck
      OnClick = tbnCrocheClick
    end
  end
  inline frameDureeEntree: TframeDureeEntree
    Left = 5
    Top = 200
    Width = 84
    Height = 24
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object tlbNotes_PointsDuree: TToolBar
    Left = 135
    Top = 35
    Width = 138
    Height = 57
    Align = alNone
    ButtonHeight = 18
    ButtonWidth = 72
    Caption = 'Notes'
    Color = clBtnFace
    Ctl3D = False
    DragCursor = crArrow
    DragKind = dkDock
    EdgeBorders = []
    EdgeInner = esNone
    EdgeOuter = esNone
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'Arial'
    Font.Style = []
    List = True
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowCaptions = True
    ShowHint = True
    TabOrder = 2
    object btn2PointDuree: TToolButton
      Left = 0
      Top = 0
      Hint = '... point'#233'e doublement'
      Caption = 'double-point'#233'e'
      ImageIndex = 7
      Wrap = True
      Style = tbsCheck
      OnClick = btn2PointDureeClick
    end
    object btn1PointDuree: TToolButton
      Left = 0
      Top = 18
      Hint = '... point'#233'e'
      Caption = '...point'#233'e'
      ImageIndex = 6
      Style = tbsCheck
      OnClick = btn2PointDureeClick
    end
  end
end
