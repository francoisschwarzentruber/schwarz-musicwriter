object frmCorrection: TfrmCorrection
  Left = 192
  Top = 81
  Width = 301
  Height = 419
  Caption = 'Correction du document - Liste des erreurs de composition'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnActivate = FormActivate
  DesignSize = (
    293
    392)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 244
    Height = 13
    Caption = 'Voici les erreurs qu'#39'il y a dans le document courant :'
  end
  object lstErreurs: TListBox
    Left = 8
    Top = 32
    Width = 280
    Height = 321
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = lstErreursDblClick
  end
  object cmdFermer: TButton
    Left = 215
    Top = 358
    Width = 73
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Fermer'
    TabOrder = 1
  end
  object cmdYAller: TButton
    Left = 39
    Top = 358
    Width = 73
    Height = 25
    HelpType = htKeyword
    Anchors = [akRight, akBottom]
    Caption = 'Y aller'
    TabOrder = 2
    OnClick = cmdYAllerClick
  end
  object cmdCorriger: TButton
    Left = 119
    Top = 358
    Width = 89
    Height = 25
    HelpType = htKeyword
    Anchors = [akRight, akBottom]
    Caption = 'Corriger'
    TabOrder = 3
    OnClick = cmdCorrigerClick
  end
end
