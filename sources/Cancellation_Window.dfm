object frmCancellation_Window: TfrmCancellation_Window
  Left = 130
  Top = 127
  Width = 511
  Height = 397
  Caption = 'Annuler - Refaire'
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
    503
    370)
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 24
    Top = 64
    Width = 115
    Height = 14
    Caption = 'Op'#233'rations effectu'#233'es :'
  end
  object lstOperations: TListBox
    Left = 16
    Top = 80
    Width = 471
    Height = 242
    Style = lbOwnerDrawFixed
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 18
    Items.Strings = (
      'ertheth'
      'rettey'
      'azerazerazer'
      'bsbvcbxcvb')
    MultiSelect = True
    TabOrder = 0
    OnDrawItem = lstOperationsDrawItem
    OnMouseDown = lstOperationsMouseDown
    OnMouseMove = lstOperationsMouseMove
  end
  object tlbGeneral: TToolBar
    Left = 0
    Top = 0
    Width = 503
    Height = 22
    AutoSize = True
    ButtonWidth = 166
    Caption = 'G'#233'n'#233'ral'
    Color = clBtnFace
    Customizable = True
    DragKind = dkDock
    EdgeBorders = []
    Flat = True
    Indent = 5
    ParentColor = False
    ParentShowHint = False
    ShowCaptions = True
    ShowHint = True
    TabOrder = 2
    object tbnAnnuler: TToolButton
      Left = 5
      Top = 0
      Hint = 'Annuler'
      Caption = 'Annuler 1 op'#233'ration'
      Grouped = True
      ImageIndex = 3
      OnClick = tbnAnnulerClick
    end
    object tbnRefaire: TToolButton
      Left = 171
      Top = 0
      Hint = 'Refaire'
      Caption = 'Refaire 1 op'#233'ration'
      Grouped = True
      ImageIndex = 4
      OnClick = tbnRefaireClick
    end
    object tbnAnnulation_Reset: TToolButton
      Left = 337
      Top = 0
      Caption = 'Supprimer les infos d'#39'annulations'
      ImageIndex = 5
      OnClick = tbnAnnulation_ResetClick
    end
  end
  object cmdAnnulerOuRefaire: TButton
    Left = 20
    Top = 331
    Width = 462
    Height = 37
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Annuler ces trois op'#233'rations'
    TabOrder = 1
    OnClick = cmdAnnulerOuRefaireClick
  end
end
