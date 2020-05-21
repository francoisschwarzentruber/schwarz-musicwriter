object frmConsole: TfrmConsole
  Left = 434
  Top = 249
  Width = 401
  Height = 260
  Caption = 'Console de Schwarz Musicwriter'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 0
    Top = 33
    Width = 393
    Height = 181
    Align = alClient
    Color = 5592439
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 393
    Height = 33
    Align = alTop
    Alignment = taLeftJustify
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object lblFormPaint: TLabel
      Left = 8
      Top = 8
      Width = 135
      Height = 16
      Caption = 'Affichage de la partition'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblDefil: TLabel
      Left = 160
      Top = 8
      Width = 143
      Height = 16
      Caption = 'D'#233'filement de la partition'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
  end
  object MainMenu1: TMainMenu
    Left = 72
    Top = 104
    object Texte: TMenuItem
      Caption = 'Console'
      object Touteffacer1: TMenuItem
        Caption = 'Tout effacer'
        OnClick = Touteffacer1Click
      end
      object mnuStopper: TMenuItem
        Caption = 'Pause pour la console'
        OnClick = mnuStopperClick
      end
      object Ecrirelesmotsnontraduits1: TMenuItem
        Caption = 'Ecrire les mots non traduits'
        OnClick = Ecrirelesmotsnontraduits1Click
      end
      object Fermer1: TMenuItem
        Caption = 'Fermer'
        OnClick = MainFormFermer1Click
      end
    end
    object Test1: TMenuItem
      Caption = 'Test'
      object TesterLigneAvecY1: TMenuItem
        Caption = 'Tester "LigneAvecY"'
        OnClick = TesterLigneAvecY1Click
      end
      object AffichageComplet1: TMenuItem
        Caption = 'Tester "AffichageComplet de la partition"'
        OnClick = AffichageComplet1Click
      end
      object AffichageCompletdelcran1: TMenuItem
        Caption = 'Tester "AffichageComplet de l'#39#233'cran"'
        OnClick = AffichageCompletdelcran1Click
      end
      object Insertiondemillelementsmusicauxalatoires1: TMenuItem
        Caption = 'Insertion de cent '#233'lements musicaux al'#233'atoires'
        OnClick = Insertiondemillelementsmusicauxalatoires1Click
      end
    end
    object Vrification1: TMenuItem
      Caption = 'V'#233'rification'
      object Infomesure1: TMenuItem
        Caption = 'Info mesure'
        OnClick = Infomesure1Click
      end
      object Infoslection1: TMenuItem
        Caption = 'Info s'#233'lection'
        OnClick = Infoslection1Click
      end
    end
    object Gestiondeserreurs1: TMenuItem
      Caption = 'Gestion des erreurs'
      object Neplusignorerleserreurs1: TMenuItem
        Caption = 'Ne plus ignorer les erreurs'
        OnClick = Neplusignorerleserreurs1Click
      end
      object Gnreruneerreur1: TMenuItem
        Caption = 'G'#233'n'#233'rer une "fausse" erreur'
        OnClick = Gnreruneerreur1Click
      end
    end
  end
  object tmrEteindreLumiere: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrEteindreLumiereTimer
    Left = 304
  end
end
