object frmMesures_Tonalite: TfrmMesures_Tonalite
  Left = 286
  Top = 127
  BorderStyle = bsDialog
  Caption = 'Tonalit'#233' des mesures'
  ClientHeight = 258
  ClientWidth = 256
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    256
    258)
  PixelsPerInch = 96
  TextHeight = 13
  inline frameTonalite: TframeTonalite_Anneau
    Left = 8
    Top = 2
    Width = 224
    Height = 207
    VertScrollBar.Visible = False
    Anchors = [akLeft, akTop, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    inherited lblTonaliteCourante_Nom: TLabel
      Width = 224
    end
  end
  object cmdApply: TButton
    Left = 16
    Top = 216
    Width = 113
    Height = 25
    Caption = 'Appliquer'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = cmdApplyClick
  end
  object Annuler: TButton
    Left = 136
    Top = 216
    Width = 105
    Height = 25
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 2
    OnClick = AnnulerClick
  end
end
