object MDIChild: TMDIChild
  Left = 332
  Top = 241
  Cursor = crArrow
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  AutoScroll = False
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  Caption = 'Enfant MDI'
  ClientHeight = 350
  ClientWidth = 469
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  Icon.Data = {
    0000010002002020100000000000E80200002600000010101000000000002801
    00000E0300002800000020000000400000000100040000000000800200000000
    0000000000000000000000000000000000000000800000800000008080008000
    0000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF00000000999999900000000000000000000000
    0999999999900000000000000000000099999999999900000000000000000000
    9999999999999000000000000000000099999999999999FFFFFFFF0000000000
    999999999999999FFFFFFF0000000000999999999999999FFFFFFF0000000000
    999999999999999FFFFFFF0000000000999999999999999FFFFFFF0000000000
    999999999999999FFFFFFF0000000000099999999999999FFFFFFF0000000000
    09999999999999FFFFFFFF00000000000099999999999FFFFFFFFF0000000000
    00F9999999999FFFFFFFFF000000000000FFFFFFF9999FFFFFFFFF0990000000
    00FFFFFFF9999FFFFFF999999990000000FFFFFFF9999FFFFF99999999990000
    00FFFFFFF9999FFFFF9999999999000000FFFFFFF9999FFFF999999999990000
    00FFFFFFF9999FFFF99999F00990000000FFFFFFF9999FFFF9999FF000000000
    00FFFFFFF9999FFFF9999FF00000000000FFFFFFF9999FFFF9999FF000000000
    00FFFFFFF9999FFFF9999FF00000000000FFFFFFF9999FFFF9999FF000000000
    00FFFFFFF9999FFFF9999FF00000000000FFFFFFF9999FFFF9999FF000000000
    00FFFFFFF9999FFFF9999FF00000000000000000099990099999900000000000
    0000000009999999999990000000000000000000099999999999000000000000
    0000000009999999990000000000FC07FFFFF801FFFFF000FFFFF000001FF000
    001FF000001FF000001FF000001FF000001FF000001FF800001FF800001FF800
    001FF800001FF8000007F8000001F8000000F8000000F8000000F8000009F800
    000FF800000FF800000FF800000FF800000FF800000FF800000FF800000FF800
    000FFFF8007FFFF800FFFFF803FF280000001000000020000000010004000000
    0000C00000000000000000000000000000000000000000000000000080000080
    00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000009999000000000009
    99999000000000F999999FFFF00000F999999FFFF00000F999999FFFF00000FF
    99999FFFF00000FFFFFF9FFFF00000FFFFFF9FFF999000FFFFFF9FF9909900FF
    FFFF9FF9F00900FFFFFF9FF9F00000FFFFFF9FF9F00000FFFFFF9FF9F00000FF
    FFFF9FF9F00000000000900900000000000099900000F0FF0000800300008003
    0000800300008003000080030000800300008001000080000000800200008003
    000080030000800300008003000080030000FF1F0000}
  KeyPreview = True
  OldCreateOrder = True
  PopupMenu = PopupMenuSelection
  Position = poDefault
  Visible = True
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnMouseWheel = FormMouseWheel
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object HScrollBar: TScrollBar
    Left = 304
    Top = 295
    Width = 65
    Height = 16
    Ctl3D = False
    LargeChange = 100
    Max = 6000
    Min = -200
    PageSize = 0
    ParentCtl3D = False
    Position = -32
    SmallChange = 10
    TabOrder = 0
    TabStop = False
    OnChange = VScrollBarChange
    OnScroll = VScrollBarScroll
  end
  object VScrollBar: TScrollBar
    Left = 368
    Top = 0
    Width = 16
    Height = 297
    Ctl3D = False
    Kind = sbVertical
    LargeChange = 100
    Max = 1000
    Min = -200
    PageSize = 0
    ParentCtl3D = False
    ParentShowHint = False
    ShowHint = False
    SmallChange = 10
    TabOrder = 1
    TabStop = False
    OnChange = VScrollBarChange
    OnScroll = VScrollBarScroll
  end
  object CoinDroitBas: TPanel
    Left = 368
    Top = 296
    Width = 17
    Height = 17
    BevelOuter = bvNone
    TabOrder = 2
  end
  object panStatusBar: TPanel
    Left = 184
    Top = 288
    Width = 121
    Height = 25
    TabOrder = 3
    Visible = False
    OnMouseMove = panStatusBarMouseMove
    object ToolBarVue: TToolBar
      Left = 1
      Top = 1
      Width = 112
      Height = 24
      Align = alNone
      ButtonWidth = 25
      Caption = 'ToolBarVue'
      Color = clBtnFace
      Ctl3D = False
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      ParentColor = False
      TabOrder = 0
      object tbnModeRuban: TToolButton
        Left = 0
        Top = 0
        Hint = 'Mode ruban'
        Caption = 'tbnModeRuban'
        Grouped = True
        ImageIndex = 25
        Style = tbsCheck
        OnClick = tbnModeRubanClick
        OnMouseMove = tbnModeRubanMouseMove
      end
      object tbnModePageEditer: TToolButton
        Left = 25
        Top = 0
        Hint = 'Mode page pour '#233'diter'
        Caption = 'tbnModePageEditer'
        Down = True
        Grouped = True
        ImageIndex = 56
        Style = tbsCheck
        OnClick = tbnModePageEditerClick
        OnMouseMove = tbnModePageEditerMouseMove
      end
      object tbnModePageClean: TToolButton
        Left = 50
        Top = 0
        Hint = 'Mode page'
        Caption = 'tbnModePageClean'
        Grouped = True
        ImageIndex = 24
        Style = tbsCheck
        OnClick = tbnModePageCleanClick
        OnMouseMove = tbnModePageCleanMouseMove
      end
      object tlbAfficherRegleTemps: TToolButton
        Left = 75
        Top = 0
        ImageIndex = 72
        Style = tbsCheck
        Visible = False
        OnClick = tlbAfficherRegleTempsClick
      end
    end
  end
  object cmdMettreBarreMesures: TBitBtn
    Left = 216
    Top = 240
    Width = 33
    Height = 49
    Default = True
    PopupMenu = pupMenuMettreBarreMesures
    TabOrder = 4
    Visible = False
    OnClick = cmdMettreBarreMesuresClick
    Glyph.Data = {
      B20B0000424DB20B00000000000036000000280000001B000000230000000100
      1800000000007C0B000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFF
      FFFF000000000000FF8000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF000000FF8000FF8000FF
      8000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFF
      FFFFFFFFFFFFFF000000000000FF8000FF8000000000000000FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF000000FF80
      00FF8000FF8000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFF000000FFFFFFFFFFFF000000FF8000FF8000FF8000000000000000FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF000000
      FF8000FF8000FF8000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFF000000000000000000FF8000FF8000FF8000000000
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
      0000000000000000000000FF8000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000080FFFF00000000
      0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFF00000000000080FFFF80FFFF000000000000FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000
      0080FFFF80FFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000080FFFF000000FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFF000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
      0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000
      00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
      0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000
      00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
      0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000}
    NumGlyphs = 2
  end
  inline Navigateur: TframeNavigateur
    Left = 0
    Top = 333
    Width = 469
    Height = 17
    Cursor = crHandPoint
    Align = alBottom
    TabOrder = 5
    inherited Panel: TPaintBox
      Width = 469
      Align = alTop
      Font.Height = -13
      Visible = False
    end
  end
  object panInstruments_Portees: TPanel
    Left = 0
    Top = 295
    Width = 185
    Height = 17
    Caption = 'toutes les port'#233'es'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    PopupMenu = PopupMenuInstruments_Portees
    TabOrder = 6
  end
  object tmrKeyWait: TTimer
    Enabled = False
    Interval = 300
    OnTimer = tmrKeyWaitTimer
    Left = 56
    Top = 48
  end
  object tmrSourisCurseur_Clignotement_Timer: TTimer
    OnTimer = tmrSourisCurseur_Clignotement_TimerTimer
    Left = 88
    Top = 48
  end
  object tmrAffichageClignotant: TTimer
    Enabled = False
    Interval = 300
    OnTimer = tmrAffichageClignotantTimer
    Left = 120
    Top = 48
  end
  object tmrDemarrerAnimationEditionMesure: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tmrDemarrerAnimationEditionMesureTimer
    Left = 152
    Top = 48
  end
  object tmrDefilTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrDefilTimerTimer
    Left = 184
    Top = 48
  end
  object PopupMenuSelection: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PopupMenuSelectionPopup
    Left = 120
    Top = 136
    object Slection1: TMenuItem
      Caption = 'S'#233'lection courante'
      OnDrawItem = PopupMenu_AfficherTitre
    end
    object PopupMenuSelection_Quoi: TMenuItem
      Caption = 'un fa, mes. 2, port'#233'e 1'
      OnDrawItem = PopupMenu_AfficherTitre
    end
    object Couper1: TMenuItem
      Caption = 'Couper la s'#233'lection'
      ImageIndex = 0
      OnClick = Couper1Click
    end
    object Coper1: TMenuItem
      Caption = 'Copier la s'#233'lection'
      ImageIndex = 1
      OnClick = Coper1Click
    end
    object Supprimer1: TMenuItem
      Caption = 'Supprimer la s'#233'lection'
      ImageIndex = 5
      OnClick = Supprimer1Click
    end
    object Sousslectionner1: TMenuItem
      Caption = '&Sous-s'#233'lectionner'
      object Noteduhaut1: TMenuItem
        Caption = 'Notes du &haut'
        ImageIndex = 35
        OnClick = Noteduhaut1Click
      end
      object Notesdubas1: TMenuItem
        Caption = 'Notes du &bas'
        ImageIndex = 34
        OnClick = Notesdubas1Click
      end
      object Notesquisontdessi1: TMenuItem
        Caption = '&Notes qui sont des "si"'
        OnClick = Notesquisontdessi1Click
      end
      object Unlmentmusicalsur21: TMenuItem
        Caption = 'Un '#233'l'#233'ment musical sur 2'
        OnClick = Unlmentmusicalsur21Click
      end
    end
    object Dplacer1: TMenuItem
      Caption = '&D'#233'placer la s'#233'lection'
      object Duneoctaveverslehaut1: TMenuItem
        Caption = 'D'#39'une octave vers le &haut'
        OnClick = Duneoctaveverslehaut1Click
      end
      object Duneoctaveverslebas1: TMenuItem
        Caption = 'Dune octave vers le &bas'
        OnClick = Duneoctaveverslebas1Click
      end
    end
    object Octavier1: TMenuItem
      AutoHotkeys = maManual
      Caption = '"&Octavier" la s'#233'lection'
      object Duneoctaveverslehaut2: TMenuItem
        AutoHotkeys = maManual
        Caption = 'D'#39'une octave vers le &haut'
        OnClick = Duneoctaveverslehaut2Click
      end
      object Duneoctaveverslebas2: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Dune octave vers le &bas'
        OnClick = Duneoctaveverslebas2Click
      end
    end
    object Apparences1: TMenuItem
      Caption = 'Apparences'
      Visible = False
      object Queueverslehaut1: TMenuItem
        Caption = 'Queue vers le haut'
        ImageIndex = 30
        OnClick = Queueverslehaut1Click
      end
      object Queueverslebas1: TMenuItem
        Caption = 'Queue vers le bas'
        ImageIndex = 31
        OnClick = Queueverslebas1Click
      end
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Altrer1: TMenuItem
      Caption = 'Alt'#233'rer les notes de la s'#233'lection'
      object Doublebmol1: TMenuItem
        Caption = 'Double-b'#233'moliser  v (juste avant b)'
        OnClick = MnuAltererSelection
      end
      object bmol1: TMenuItem
        Tag = 1
        Caption = 'B'#233'moliser              b'
        OnClick = MnuAltererSelection
      end
      object Dise1: TMenuItem
        Tag = 2
        Caption = 'Tout b'#233'cariser      n (normal)'
        OnClick = MnuAltererSelection
      end
      object Diser1: TMenuItem
        Tag = 3
        Caption = 'Di'#233'ser                  #'
        OnClick = MnuAltererSelection
      end
      object Doublediser1: TMenuItem
        Tag = 4
        Caption = 'Double-di'#233'ser       '#39' (juste apr'#232's #)'
        OnClick = MnuAltererSelection
      end
      object Altrerselonunetonalit1: TMenuItem
        Caption = 'Alt'#233'rer les notes selon une tonalit'#233'...'
        OnClick = I_AltererSelonUneTonalite
      end
    end
    object Ajusternotesetaltrationsselonunetonalit1: TMenuItem
      Caption = 
        'Enharmoniquer (ajuster notes et alt'#233'rations) selon une tonalit'#233'.' +
        '..'
      OnClick = I_AjusterNotesEtAlterationsSelonUneTonalite
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Extraireunmodle1: TMenuItem
      Caption = 'Extraire le mod'#232'le'
      Visible = False
      OnClick = Extraireunmodle1Click
    end
    object mnuCyclerlesvoix_DansMenuSelection: TMenuItem
      Caption = '&Cycler les voix'
      OnClick = mnuCyclerlesvoix_DansMenuSelectionClick
      OnDrawItem = mnuMenuGeneriqueAvecInfoVoixDrawItem
      OnMeasureItem = mnuMenuGeneriqueAvecInfoVoixMeasureItem
    end
    object mnuTransposer: TMenuItem
      Caption = '&Transposer la s'#233'lection...'
      OnClick = mnuTransposerClick
    end
    object Arpger1: TMenuItem
      Caption = 'Arp'#233'ger la s'#233'lection'
      object ArpegerVerslehaut1: TMenuItem
        Caption = 'Arp'#232'ges vers le haut'
        OnClick = ArpegerVerslehaut1Click
      end
      object ArpegerVerslebas1: TMenuItem
        Caption = 'Arp'#232'ges vers le bas'
        OnClick = ArpegerVerslebas1Click
      end
    end
    object Fusionner2: TMenuItem
      Caption = 'Fusionner les notes de la s'#233'lection'
      object Fusionner1: TMenuItem
        Caption = 'Fusionner en un gros accord'
        Hint = 'Fusionner les notes s'#233'lectionn'#233'es pour en faire un gros accords'
        ShortCut = 16454
        OnClick = Fusionner1Click
      end
      object Enfairepleinpareil1: TMenuItem
        Caption = 'Fusionner les notes et recopier pleins d'#39'accords partoutil'
        OnClick = Enfairepleinpareil1Click
      end
    end
    object Dure1: TMenuItem
      Caption = 'Dur'#233'e des '#233'l'#233'ments de la s'#233'lection'
      object mnuDuree_Approximative: TMenuItem
        Caption = 'Dire que la dur'#233'e est approximative'
        OnClick = mnuDuree_ApproximativeClick
      end
      object Multiplierlesdurespar21: TMenuItem
        Caption = 'Multiplier les dur'#233'es par 2'
        OnClick = Multiplierlesdurespar21Click
        OnDrawItem = Multiplierlesdurespar21DrawItem
        OnMeasureItem = Multiplierlesdurespar21MeasureItem
      end
      object Diviserlesdurespar21: TMenuItem
        Caption = 'Diviser les dur'#233'es par 2'
        OnClick = Diviserlesdurespar21Click
      end
      object mnuI_Selection_FusionnerNotesEtSilences: TMenuItem
        Caption = 'Alonger les notes et supprimer les pauses'
        OnClick = I_Selection_FusionnerNotesEtSilences
      end
      object mnuI_Selection_DureesDiviserParDeuxPuisSilence: TMenuItem
        Caption = 'Diviser les dur'#233'es par 2 en mettant des pauses'
        OnClick = I_Selection_DureesDiviserParDeuxPuisSilence
      end
      object Parkinsonner1: TMenuItem
        Caption = 'Parkinsonner'
        OnClick = Parkinsonner1Click
      end
    end
    object Cordedeguitare1: TMenuItem
      Caption = 'Jouer la s'#233'lection sur la corde de guitare n'#176' ...'
      object Corden16: TMenuItem
        Tag = 5
        Caption = 'Corde n'#176' 6'
        OnClick = mnuCorde_De_Guitare_Corde_Numero_Click
      end
      object Corden15: TMenuItem
        Tag = 4
        Caption = 'Corde n'#176' 5'
        OnClick = mnuCorde_De_Guitare_Corde_Numero_Click
      end
      object Corden14: TMenuItem
        Tag = 3
        Caption = 'Corde n'#176' 4'
        OnClick = mnuCorde_De_Guitare_Corde_Numero_Click
      end
      object Corden13: TMenuItem
        Tag = 2
        Caption = 'Corde n'#176' 3'
        OnClick = mnuCorde_De_Guitare_Corde_Numero_Click
      end
      object Corden12: TMenuItem
        Tag = 1
        Caption = 'Corde n'#176' 2'
        OnClick = mnuCorde_De_Guitare_Corde_Numero_Click
      end
      object Corden11: TMenuItem
        Caption = 'Corde n'#176' 1'
        OnClick = mnuCorde_De_Guitare_Corde_Numero_Click
      end
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Placerlaslectiondanslavoix1: TMenuItem
      Caption = 'Placer la s'#233'lection dans la voix...'
      object mnuSelection_PlacerDansVoixCourante: TMenuItem
        Caption = 'Placer la s'#233'lection dans la voix courante !'
        OnClick = mnuSelection_PlacerDansVoixCouranteClick
        OnDrawItem = mnuMenuGeneriqueAvecInfoVoixDrawItem
        OnMeasureItem = mnuMenuGeneriqueAvecInfoVoixMeasureItem
      end
      object mnuSelection_PlacerDansVoixNouvelle: TMenuItem
        Caption = 'Placer la s'#233'lection dans une nouvelle voix !'
        OnClick = mnuSelection_PlacerDansVoixNouvelleClick
        OnDrawItem = mnuMenuGeneriqueAvecInfoVoixDrawItem
        OnMeasureItem = mnuMenuGeneriqueAvecInfoVoixMeasureItem
      end
      object mnuSelection_Deplacer_Voix: TMenuItem
        Caption = 
          'Placer la s'#233'lection dans la voix '#224' sp'#233'cifier (bo'#238'te de dialogue)' +
          '...'
        OnClick = mnuSelection_Deplacer_VoixClick
      end
    end
  end
  object PopupMenuCurseur: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PopupMenuCurseurPopup
    Left = 152
    Top = 136
    object PopupMenuCurseur_Titre: TMenuItem
      Caption = 'Ici, mesure n'#176' 3,'
      OnDrawItem = PopupMenu_AfficherTitre
    end
    object Lirepartirdici1: TMenuItem
      Caption = 'Lire et '#233'couter la partition '#224' partir d'#39'ici'
      ImageIndex = 37
      OnClick = Lirepartirdici1Click
    end
    object Lirepartirdicipourladeuximefois1: TMenuItem
      Caption = 'Lire '#224' partir d'#39'ici pour la deuxi'#232'me fois'
      Visible = False
    end
    object Coller1: TMenuItem
      Caption = 'Coller'
      ImageIndex = 2
      OnClick = Coller1Click
    end
    object Collereninversant1: TMenuItem
      Caption = 'Coller en inversant'
      ImageIndex = 22
      OnClick = Collereninversant1Click
    end
    object Collerdesgrosaccords1: TMenuItem
      Caption = 'Coller en un gros accord'
      OnClick = Collerdesgrosaccords1Click
    end
    object Affichage1: TMenuItem
      Caption = 'Affichage'
      object mnuJusteCettePortee: TMenuItem
        Caption = 'Juste cette port'#233'e (+ bascule en mode page)'
        ImageIndex = 40
        OnClick = mnuJusteCettePorteeClick
      end
      object outeslesportes1: TMenuItem
        Caption = 'Toutes les voix'
        ImageIndex = 41
        OnClick = outeslesportes1Click
      end
    end
    object Voix1: TMenuItem
      Caption = 'Voix'
      object mnuEcrireDansUneNouvelleVoix: TMenuItem
        Caption = 'Ecrire dans une nouvelle voix, par exemple'
        ImageIndex = 42
        OnClick = mnuEcrireDansUneNouvelleVoixClick
        OnDrawItem = mnuMenuGeneriqueAvecInfoVoixDrawItem
        OnMeasureItem = mnuMenuGeneriqueAvecInfoVoixMeasureItem
      end
      object mnuEcrireDansLaVoixSousLeCurseur: TMenuItem
        Caption = 'Ecrire dans la voix sous le curseur, ie'
        ImageIndex = 43
        OnClick = mnuEcrireDansLaVoixSousLeCurseurClick
        OnDrawItem = mnuMenuGeneriqueAvecInfoVoixDrawItem
        OnMeasureItem = mnuMenuGeneriqueAvecInfoVoixMeasureItem
      end
      object Voixautomatiquecriredanslesvoixpardfaut1: TMenuItem
        Caption = 'Voix automatique ('#233'crire dans les voix par d'#233'faut)'
        ImageIndex = 60
        OnClick = Voixautomatiquecriredanslesvoixpardfaut1Click
      end
    end
    object Insrer1: TMenuItem
      Caption = 'Ins'#233'rer'
      object Clefs1: TMenuItem
        Caption = 'Clefs'
        object Clefdesol1: TMenuItem
          Caption = 'Clef de sol'
          ImageIndex = 49
        end
        object Clefdefa1: TMenuItem
          Caption = 'Clef de fa'
          ImageIndex = 50
        end
        object Clefdut1: TMenuItem
          Caption = 'Clef d'#39'ut'
          ImageIndex = 51
        end
      end
      object Mesures1: TMenuItem
        Caption = 'Mesures'
        object Insrerunemesureavant1: TMenuItem
          Caption = 'Ins'#233'rer une mesure avant'
          ImageIndex = 71
          OnClick = Insrerunemesureavant1Click
        end
        object Insrerunemesureaprs1: TMenuItem
          Caption = 'Ins'#233'rer une mesure apr'#232's'
          ImageIndex = 26
          OnClick = Insrerunemesureaprs1Click
        end
      end
      object mnuBarredemesure_Inserer: TMenuItem
        Caption = 'Barre de mesure'
        ImageIndex = 68
        OnClick = mnuBarredemesure_InsererClick
      end
    end
    object mnuSupprimerlamesure: TMenuItem
      Caption = 'Supprimer la mesure'
      ImageIndex = 27
      OnClick = mnuSupprimerlamesureClick
    end
    object Placerlecurseurici1: TMenuItem
      Caption = 'Placer le curseur ici'
      Visible = False
    end
    object mnuProprietedelaportee: TMenuItem
      Caption = 'Propri'#233't'#233' de la port'#233'e'
      OnClick = mnuProprietedelaporteeClick
    end
    object Continuerlcritureavecunemontechromatique1: TMenuItem
      Tag = 1
      Caption = 
        'Recopier les notes pr'#233'c'#233'dentes un demi-ton plus haut (mont'#233'e chr' +
        'omatique)'
      OnClick = Continuerlcritureavecunemontechromatique1Click
    end
    object Continuerlcritureavecunedescentechromatique1: TMenuItem
      Tag = -1
      Caption = 
        'Recopier les notes pr'#233'c'#233'dentes un demi-ton plus bas (descente ch' +
        'romatique)'
      OnClick = Continuerlcritureavecunemontechromatique1Click
    end
    object mnuCyclerlesvoix: TMenuItem
      Caption = 'Cycler les voix : basculer vers la voix'
      OnClick = mnuCyclerlesvoixClick
      OnDrawItem = mnuMenuGeneriqueAvecInfoVoixDrawItem
      OnMeasureItem = mnuMenuGeneriqueAvecInfoVoixMeasureItem
    end
    object Rendrejolilamesure1: TMenuItem
      Caption = 'Rendre joli la mesure'
      Visible = False
      OnClick = Rendrejolilamesure1Click
    end
    object Simplifierlcrituredelamesure1: TMenuItem
      Caption = 'Simplifier l'#39#233'criture des notes dans la mesure'
      Hint = 
        'Simplifie l'#39#233'criture des notes, par exemple, deux noires li'#233'es e' +
        'ntre elles se tranforment en blanche'
      OnClick = Simplifierlcrituredelamesure1Click
    end
    object mnuParolesEcrire: TMenuItem
      Caption = 'Ecrire des paroles dans la voix'
      ImageIndex = 69
      OnClick = mnuParolesEcrireClick
      OnDrawItem = mnuMenuGeneriqueAvecInfoVoixDrawItem
      OnMeasureItem = mnuMenuGeneriqueAvecInfoVoixMeasureItem
    end
  end
  object PopupMenuLecture: TPopupMenu
    AutoHotkeys = maManual
    Left = 312
    Top = 32
    object Reprendrelalecturepartirdici1: TMenuItem
      Caption = 'Reprendre la lecture '#224' partir d'#39'ici'
      OnClick = Lirepartirdici1Click
    end
    object Arrterlalecture1: TMenuItem
      Caption = 'Arr'#234'ter la lecture'
      ImageIndex = 39
      OnClick = Arrterlalecture1Click
    end
  end
  object PopupMenuClef: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PopupMenuClefPopup
    Left = 8
    Top = 160
    object PopupMenuClef_Titre: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Clef de sol sur la port'#233'e n'#176' 1'
      OnDrawItem = PopupMenu_AfficherTitre
    end
    object Clefdesol2: TMenuItem
      Caption = 'Changer en clef de sol'
      ImageIndex = 49
      OnClick = ModifClefPortee
    end
    object Clefdefa2: TMenuItem
      Tag = 1
      Caption = 'Changer en clef de fa'
      ImageIndex = 50
      OnClick = ModifClefPortee
    end
    object Clefdut2: TMenuItem
      Tag = 2
      Caption = 'Changer en clef d'#39'ut'
      ImageIndex = 51
      OnClick = ModifClefPortee
    end
    object mnuMenuTonalite_DuMenuClef: TMenuItem
      Caption = 'Tonalit'#233
      object DobmajeurLabmineur2: TMenuItem
        Tag = -7
        Caption = 'Dob majeur | Lab mineur'
        ImageIndex = 13
        OnClick = ChangerTonaliteAuDebut
      end
      object SolbmajeurMibmineur2: TMenuItem
        Tag = -6
        Caption = 'Solb majeur | Mib mineur'
        ImageIndex = 11
        OnClick = ChangerTonaliteAuDebut
      end
      object RbmajeurSibmineur2: TMenuItem
        Tag = -5
        Caption = 'R'#233'b majeur | Sib mineur'
        ImageIndex = 9
        OnClick = ChangerTonaliteAuDebut
      end
      object LabmajeurFamineur2: TMenuItem
        Tag = -4
        Caption = 'Lab majeur | Fa mineur'
        ImageIndex = 7
        OnClick = ChangerTonaliteAuDebut
      end
      object MibmajeurDomineur2: TMenuItem
        Tag = -3
        Caption = 'Mib majeur | Do mineur'
        ImageIndex = 5
        OnClick = ChangerTonaliteAuDebut
      end
      object SibmajeurSolmineur2: TMenuItem
        Tag = -2
        Caption = 'Sib majeur | Sol mineur'
        ImageIndex = 3
        OnClick = ChangerTonaliteAuDebut
      end
      object Famajeurrmineur3: TMenuItem
        Tag = -1
        Caption = 'Fa majeur | r'#233' mineur'
        ImageIndex = 1
        OnClick = ChangerTonaliteAuDebut
      end
      object Domajeurlamineur2: TMenuItem
        Break = mbBarBreak
        Caption = 'Do majeur | la mineur'
        OnClick = ChangerTonaliteAuDebut
      end
      object SolmajeurMimineur2: TMenuItem
        Tag = 1
        Caption = 'Sol majeur | Mi mineur'
        ImageIndex = 0
        OnClick = ChangerTonaliteAuDebut
      end
      object RmajeurLamajeur2: TMenuItem
        Tag = 2
        Caption = 'R'#233' majeur | Si mineur'
        ImageIndex = 2
        OnClick = ChangerTonaliteAuDebut
      end
      object LamajeurFamineur2: TMenuItem
        Tag = 3
        Caption = 'La majeur | Fa# mineur'
        ImageIndex = 4
        OnClick = ChangerTonaliteAuDebut
      end
      object MimajeurDomineur2: TMenuItem
        Tag = 4
        Caption = 'Mi majeur | Do# mineur'
        ImageIndex = 6
        OnClick = ChangerTonaliteAuDebut
      end
      object SimajeurSolmineur2: TMenuItem
        Tag = 5
        Caption = 'Si majeur | Sol# mineur'
        ImageIndex = 8
        OnClick = ChangerTonaliteAuDebut
      end
      object FamajeurRmineur4: TMenuItem
        Tag = 6
        Caption = 'Fa# majeur | R'#233'# mineur'
        ImageIndex = 10
        OnClick = ChangerTonaliteAuDebut
      end
      object Domajeur2: TMenuItem
        Tag = 7
        Caption = 'Do# majeur | La# mineur'
        ImageIndex = 12
        OnClick = ChangerTonaliteAuDebut
      end
    end
    object Rythme2: TMenuItem
      Caption = 'Rythme'
      object N442: TMenuItem
        Caption = '4/4'
        OnClick = ChangerRythmeDepuisDebut
      end
      object N342: TMenuItem
        Tag = 1
        Caption = '3/4'
        OnClick = ChangerRythmeDepuisDebut
      end
      object N242: TMenuItem
        Tag = 2
        Caption = '2/4'
        OnClick = ChangerRythmeDepuisDebut
      end
      object N681: TMenuItem
        Tag = 3
        Caption = '6/8'
        OnClick = ChangerRythmeDepuisDebut
      end
    end
    object Slectionnertouteslesnotessilencesdelapore1: TMenuItem
      Caption = 'S'#233'lectionner toutes les notes/silences de la port'#233'e'
      OnClick = Slectionnertouteslesnotessilencesdelapore1Click
    end
  end
  object PopupMenuRythmeEtTonalite: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PopupMenuRythmeEtTonalitePopup
    Left = 192
    Top = 192
    object PopupMenuRythmeEtTonalite_Titre: TMenuItem
      Caption = 'A partir d'#39'ici, mesure n'#176'2'
      OnDrawItem = PopupMenu_AfficherTitre
    end
    object mnuMenuTonalite_DuMenuRythmesEtTonalites: TMenuItem
      Caption = 'Tonalit'#233
      object DobmajeurLabmineur3: TMenuItem
        Tag = -7
        Caption = 'Dob majeur | Lab mineur'
        ImageIndex = 13
        OnClick = ChangerTonaliteRT
      end
      object SolbmajeurMibmineur3: TMenuItem
        Tag = -6
        Caption = 'Solb majeur | Mib mineur'
        ImageIndex = 11
        OnClick = ChangerTonaliteRT
      end
      object RbmajeurSibmineur3: TMenuItem
        Tag = -5
        Caption = 'R'#233'b majeur | Sib mineur'
        ImageIndex = 9
        OnClick = ChangerTonaliteRT
      end
      object LabmajeurFamineur3: TMenuItem
        Tag = -4
        Caption = 'Lab majeur | Fa mineur'
        ImageIndex = 7
        OnClick = ChangerTonaliteRT
      end
      object MibmajeurDomineur3: TMenuItem
        Tag = -3
        Caption = 'Mib majeur | Do mineur'
        ImageIndex = 5
        OnClick = ChangerTonaliteRT
      end
      object SibmajeurSolmineur3: TMenuItem
        Tag = -2
        Caption = 'Sib majeur | Sol mineur'
        ImageIndex = 3
        OnClick = ChangerTonaliteRT
      end
      object Famajeurrmineur6: TMenuItem
        Tag = -1
        Caption = 'Fa majeur | r'#233' mineur'
        ImageIndex = 1
        OnClick = ChangerTonaliteRT
      end
      object Domajeurlamineur4: TMenuItem
        Break = mbBarBreak
        Caption = 'Do majeur | la mineur'
        OnClick = ChangerTonaliteRT
      end
      object SolmajeurMimineur3: TMenuItem
        Tag = 1
        Caption = 'Sol majeur | Mi mineur'
        ImageIndex = 0
        OnClick = ChangerTonaliteRT
      end
      object RmajeurSimineur1: TMenuItem
        Tag = 2
        Caption = 'R'#233' majeur | Si mineur'
        ImageIndex = 2
        OnClick = ChangerTonaliteRT
      end
      object LamajeurFamineur3: TMenuItem
        Tag = 3
        Caption = 'La majeur | Fa# mineur'
        ImageIndex = 4
        OnClick = ChangerTonaliteRT
      end
      object MimajeurDomineur3: TMenuItem
        Tag = 4
        Caption = 'Mi majeur | Do# mineur'
        ImageIndex = 6
        OnClick = ChangerTonaliteRT
      end
      object SimajeurSolmineur3: TMenuItem
        Tag = 5
        Caption = 'Si majeur | Sol# mineur'
        ImageIndex = 8
        OnClick = ChangerTonaliteRT
      end
      object FamajeurRmineur5: TMenuItem
        Tag = 6
        Caption = 'Fa# majeur | R'#233'# mineur'
        ImageIndex = 10
        OnClick = ChangerTonaliteRT
      end
      object DomajeurLamineur3: TMenuItem
        Tag = 7
        Caption = 'Do# majeur | La# mineur'
        ImageIndex = 12
        OnClick = ChangerTonaliteRT
      end
    end
    object Rythme3: TMenuItem
      Caption = 'Rythme'
      object N443: TMenuItem
        Caption = '4/4'
        OnClick = ChangerRythmeRT
      end
      object N343: TMenuItem
        Tag = 1
        Caption = '3/4'
        OnClick = ChangerRythmeRT
      end
      object N243: TMenuItem
        Tag = 2
        Caption = '2/4'
        OnClick = ChangerRythmeRT
      end
      object N682: TMenuItem
        Tag = 3
        Caption = '6/8'
        OnClick = ChangerRythmeRT
      end
    end
    object Calculerlarrache1: TMenuItem
      Caption = 'Calculer '#224' l'#39'arrache le rythme'
      OnClick = Calculerlarrache1Click
    end
  end
  object tmrFormResizing: TTimer
    Interval = 200
    OnTimer = tmrFormResizingTimer
    Left = 216
    Top = 48
  end
  object pupMenuMettreBarreMesures: TPopupMenu
    AutoHotkeys = maManual
    Left = 272
    Top = 256
    object Laissertelquel1: TMenuItem
      Caption = 'Laisser tel quel'
      OnClick = Laissertelquel1Click
    end
    object Mettrebarresdemesures1: TMenuItem
      Caption = 'Mettre barres de mesures'
      OnClick = Mettrebarresdemesures1Click
    end
    object Mettrebarresdemesuresencrivantsurlasuite1: TMenuItem
      Caption = 'Mettre barres de mesures en '#233'crivant sur la suite'
      OnClick = Mettrebarresdemesuresencrivantsurlasuite1Click
    end
  end
  object PopupBarreDeMesure: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PopupBarreDeMesurePopup
    Left = 88
    Top = 136
    object PopupBarreDeMesure_Titre: TMenuItem
      AutoHotkeys = maManual
      AutoLineReduction = maManual
      Caption = 'Barre entre les mesures n'#176' 1 et n'#176' 2'
      OnDrawItem = PopupMenu_AfficherTitre
    end
    object Barredemesuresimple1: TMenuItem
      Caption = 'Transformer en barre de mesure simple'
      ImageIndex = 0
      OnClick = Barredemesuresimple1Click
    end
    object Barredereprise1: TMenuItem
      Caption = 'Transformer en barre de reprise'
      object Jusqulonreprend1: TMenuItem
        Caption = 'Jusque l'#224', on reprend'
        ImageIndex = 3
        OnClick = Jusqulonreprend1Click
      end
      object Apartirdelonreprend1: TMenuItem
        Caption = 'A partir de l'#224', on reprend'
        ImageIndex = 4
        OnClick = Apartirdelonreprend1Click
      end
      object Jusqueletpartirdelonreprend1: TMenuItem
        Caption = 'Jusque l'#224', et '#224' partir de l'#224', on reprend'
        ImageIndex = 5
        OnClick = Jusqueletpartirdelonreprend1Click
      end
    end
    object Doublebarre1: TMenuItem
      Caption = 'Transformer en double-barre'
      ImageIndex = 1
      OnClick = Doublebarre1Click
    end
    object mnuBarreDeMesure_Supprimer: TMenuItem
      Caption = 'Supprimer la barre'
      ImageIndex = 2
      OnClick = mnuBarreDeMesure_SupprimerClick
    end
    object mnuBarreDeMesure_Tonalites_grp: TMenuItem
      Caption = 'Tonalit'#233' '#224' partir d'#39'ici'
      object DobmajeurLabmineur1: TMenuItem
        Tag = -7
        Caption = 'Dob majeur | Lab mineur'
        ImageIndex = 13
        OnClick = ChangerTonaliteApartirDeBarreDeMesure
      end
      object SolbmajeurMibmineur1: TMenuItem
        Tag = -6
        Caption = 'Solb majeur | Mib mineur'
        ImageIndex = 11
        OnClick = ChangerTonaliteApartirDeBarreDeMesure
      end
      object RbmajeurSibmineur1: TMenuItem
        Tag = -5
        Caption = 'R'#233'b majeur | Sib mineur'
        ImageIndex = 9
        OnClick = ChangerTonaliteApartirDeBarreDeMesure
      end
      object LabmajeurFamineur1: TMenuItem
        Tag = -4
        Caption = 'Lab majeur | Fa mineur'
        ImageIndex = 7
        OnClick = ChangerTonaliteApartirDeBarreDeMesure
      end
      object MibmajeurDomineur1: TMenuItem
        Tag = -3
        Caption = 'Mib majeur | Do mineur'
        ImageIndex = 5
        OnClick = ChangerTonaliteApartirDeBarreDeMesure
      end
      object SibmajeurSolmineur1: TMenuItem
        Tag = -2
        Caption = 'Sib majeur | Sol mineur'
        ImageIndex = 3
        OnClick = ChangerTonaliteApartirDeBarreDeMesure
      end
      object Famajeurrmineur1: TMenuItem
        Tag = -1
        Caption = 'Fa majeur | r'#233' mineur'
        ImageIndex = 1
        OnClick = ChangerTonaliteApartirDeBarreDeMesure
      end
      object Domajeurlamineur1: TMenuItem
        Break = mbBarBreak
        Caption = 'Do majeur | la mineur'
        OnClick = ChangerTonaliteApartirDeBarreDeMesure
      end
      object SolmajeurMimineur1: TMenuItem
        Tag = 1
        Caption = 'Sol majeur | Mi mineur'
        ImageIndex = 0
        OnClick = ChangerTonaliteApartirDeBarreDeMesure
      end
      object RmajeurLamajeur1: TMenuItem
        Tag = 2
        Caption = 'R'#233' majeur | Si mineur'
        ImageIndex = 2
        OnClick = ChangerTonaliteApartirDeBarreDeMesure
      end
      object LamajeurFamineur1: TMenuItem
        Tag = 3
        Caption = 'La majeur | Fa# mineur'
        ImageIndex = 4
        OnClick = ChangerTonaliteApartirDeBarreDeMesure
      end
      object MimajeurDomineur1: TMenuItem
        Tag = 4
        Caption = 'Mi majeur | Do# mineur'
        ImageIndex = 6
        OnClick = ChangerTonaliteApartirDeBarreDeMesure
      end
      object SimajeurSolmineur1: TMenuItem
        Tag = 5
        Caption = 'Si majeur | Sol# mineur'
        ImageIndex = 8
        OnClick = ChangerTonaliteApartirDeBarreDeMesure
      end
      object FamajeurRmineur2: TMenuItem
        Tag = 6
        Caption = 'Fa# majeur | R'#233'# mineur'
        ImageIndex = 10
        OnClick = ChangerTonaliteApartirDeBarreDeMesure
      end
      object Domajeur1: TMenuItem
        Tag = 7
        Caption = 'Do# majeur | La# mineur'
        ImageIndex = 12
        OnClick = ChangerTonaliteApartirDeBarreDeMesure
      end
    end
    object mnuBarreDeMesures_Rythme_grp: TMenuItem
      Caption = 'Rythme '#224' partir d'#39'ici'
      object N441: TMenuItem
        Caption = '4/4'
        OnClick = ChangerRythme
      end
      object N341: TMenuItem
        Tag = 1
        Caption = '3/4'
        OnClick = ChangerRythme
      end
      object N241: TMenuItem
        Tag = 2
        Caption = '2/4'
        OnClick = ChangerRythme
      end
      object N683: TMenuItem
        Tag = 3
        Caption = '6/8'
        OnClick = ChangerRythme
      end
    end
  end
  object PopupMenuClefInseree: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PopupMenuClefInsereePopup
    Left = 56
    Top = 216
    object PopupMenuClefInseree_Titre: TMenuItem
      Caption = 'Clef ins'#233'r'#233'e, mes. 3, port'#233'e 2'
      OnDrawItem = PopupMenu_AfficherTitre
    end
    object Clefdesol3: TMenuItem
      Caption = 'Changer en clef de sol'
      ImageIndex = 49
      OnClick = ClefInseree_Modifier
    end
    object Clefdefa3: TMenuItem
      Tag = 1
      Caption = 'Changer en clef de fa'
      ImageIndex = 50
      OnClick = ClefInseree_Modifier
    end
    object Clefdut3: TMenuItem
      Tag = 2
      Caption = 'Changer en clef d'#39'ut'
      ImageIndex = 51
      OnClick = ClefInseree_Modifier
    end
    object Supprimerlaclef1: TMenuItem
      Caption = 'Supprimer la clef'
      ImageIndex = 5
      OnClick = ClefInseree_Supprimer
    end
  end
  object PopupMenuOctavieur: TPopupMenu
    AutoHotkeys = maManual
    Left = 128
    Top = 16
    object Supprimerloctavieur1: TMenuItem
      Caption = 'Supprimer l'#39'octavieur'
      OnClick = Supprimerloctavieur1Click
    end
  end
  object PopupMenuNuances: TPopupMenu
    AutoHotkeys = maManual
    Left = 296
    Top = 176
    object pp1: TMenuItem
      Tag = 2
      Caption = 'pp'
      OnClick = mnuNuance_Set
    end
    object p1: TMenuItem
      Tag = 3
      Caption = 'p'
      OnClick = mnuNuance_Set
    end
    object mp1: TMenuItem
      Tag = 4
      Caption = 'mp'
      OnClick = mnuNuance_Set
    end
    object mf1: TMenuItem
      Tag = 5
      Caption = 'mf'
      OnClick = mnuNuance_Set
    end
    object f1: TMenuItem
      Tag = 6
      Caption = 'f'
      OnClick = mnuNuance_Set
    end
    object ff1: TMenuItem
      Tag = 7
      Caption = 'ff'
      OnClick = mnuNuance_Set
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Supprimer2: TMenuItem
      Caption = 'Supprimer la nuance'
      OnClick = mnuNuance_Supprimer
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object AfficherlabotededialoguedeNuances1: TMenuItem
      Caption = 'Afficher la bo'#238'te de dialogue de Nuances'
      Default = True
      OnClick = AfficherlabotededialoguedeNuances1Click
    end
  end
  object PopupMenuCrescendo: TPopupMenu
    AutoHotkeys = maManual
    Left = 264
    Top = 176
    object MenuItem1: TMenuItem
      Tag = 2
      Caption = 'Transformer en crescendo'
      OnClick = objet_graphique_crescendo_transformer
    end
    object MenuItem2: TMenuItem
      Tag = 3
      Caption = 'Transformer en decrescendo'
      OnClick = objet_graphique_decrescendo_transformer
    end
    object MenuItem7: TMenuItem
      Caption = '-'
    end
    object MenuItem8: TMenuItem
      Caption = 'Supprimer le (de)crescendo'
      OnClick = mnuNuance_Supprimer
    end
    object MenuItem9: TMenuItem
      Caption = '-'
    end
    object MenuItem10: TMenuItem
      Caption = 'Afficher la bo'#238'te de dialogue de Nuances'
      Default = True
      OnClick = AfficherlabotededialoguedeNuances1Click
    end
  end
  object PopupMenuPhrase: TPopupMenu
    AutoHotkeys = maManual
    Left = 280
    Top = 216
    object MenuItem6: TMenuItem
      Caption = 'Supprimer le phras'#233
      OnClick = mnuNuance_Supprimer
    end
  end
  object tmrCurseurClavier: TTimer
    Enabled = False
    Interval = 800
    OnTimer = tmrCurseurClavierTimer
    Left = 64
    Top = 16
  end
  object PopupMenuPortees_Instruments_Noms_Zone: TPopupMenu
    OwnerDraw = True
    OnPopup = PopupMenuPortees_Instruments_Noms_ZonePopup
    Left = 16
    Top = 88
    object PopupMenuPortees_Instruments_Noms_Zone_Titre: TMenuItem
      Caption = 'Port'#233'e n'#176' 2'
      OnDrawItem = PopupMenu_AfficherTitre
    end
    object mnuProprietesdelaportee: TMenuItem
      Caption = 'Propri'#233't'#233' de la port'#233'e...'
      OnClick = mnuProprietesdelaporteeClick
    end
  end
  object PopupMenuInstruments_Portees: TPopupMenu
    OnPopup = PopupMenuInstruments_PorteesPopup
    Left = 64
    Top = 256
  end
end
