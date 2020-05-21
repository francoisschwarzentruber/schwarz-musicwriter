object frmProprietes: TfrmProprietes
  Left = 423
  Top = 212
  BorderStyle = bsDialog
  Caption = 'Propri'#233't'#233's'
  ClientHeight = 402
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  DesignSize = (
    367
    402)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 353
    Height = 357
    ActivePage = TabSheet2
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabIndex = 1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'G'#233'n'#233'ralit'#233's'
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 27
        Height = 13
        Caption = 'Titre :'
      end
      object Label2: TLabel
        Left = 8
        Top = 48
        Width = 37
        Height = 13
        Caption = 'Auteur :'
      end
      object txtNom: TEdit
        Left = 48
        Top = 16
        Width = 129
        Height = 21
        TabOrder = 0
        OnChange = txtNomChange
      end
      object txtAuteur: TEdit
        Left = 48
        Top = 48
        Width = 129
        Height = 21
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Des chiffres...'
      ImageIndex = 1
      DesignSize = (
        345
        329)
      object lst: TListView
        Left = 8
        Top = 16
        Width = 329
        Height = 301
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Nom'
          end
          item
            Caption = 'Valeur'
          end>
        Items.Data = {
          460000000200000000000000FFFFFFFFFFFFFFFF000000000000000005447572
          E96500000000FFFFFFFFFFFFFFFF00000000000000000F4E6F6D627265206465
          206E6F746573}
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
  end
  object cmdOK: TButton
    Left = 224
    Top = 372
    Width = 65
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object cmdCancel: TButton
    Left = 296
    Top = 372
    Width = 65
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 2
  end
end
