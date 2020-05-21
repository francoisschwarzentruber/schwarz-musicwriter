object frmMagnetophone: TfrmMagnetophone
  Left = 0
  Top = 0
  Width = 344
  Height = 95
  VertScrollBar.Visible = False
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  DesignSize = (
    344
    95)
  object lblNom: TLabel
    Left = 8
    Top = 112
    Width = 146
    Height = 14
    Caption = '<pas de fichier en lecture>'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
    WordWrap = True
  end
  object Label1: TLabel
    Left = 8
    Top = 152
    Width = 43
    Height = 14
    Caption = 'Position :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label2: TLabel
    Left = 8
    Top = 208
    Width = 35
    Height = 14
    Caption = 'Dur'#233'e :'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object lblPosition: TLabel
    Left = 64
    Top = 152
    Width = 49
    Height = 14
    Caption = '<position>'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object lblMesureCourante: TLabel
    Left = 64
    Top = 168
    Width = 94
    Height = 14
    Caption = '<mesure courante>'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object lblTemps: TLabel
    Left = 64
    Top = 184
    Width = 41
    Height = 14
    Caption = '<temps>'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object lblDureeTotale: TLabel
    Left = 64
    Top = 208
    Width = 69
    Height = 14
    Caption = '<dur'#233'e totale>'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object lblNombreDeMesures: TLabel
    Left = 64
    Top = 224
    Width = 107
    Height = 14
    Caption = '<nb total de mesures>'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  inline frameComposition_Instruments: TframeComposition_Instruments
    Left = 13
    Top = 250
    Width = 307
    Height = 61
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    Visible = False
    inherited list: TListBox
      Width = 307
      Height = 61
      OnClick = frameComposition_InstrumentslistClick
      OnMouseUp = frameComposition_InstrumentslistMouseUp
    end
  end
  object tmrMagnetophone: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tmrMagnetophoneTimer
    Left = 153
    Top = 33
  end
end
