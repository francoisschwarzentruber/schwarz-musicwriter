object frmLangue_Choix: TfrmLangue_Choix
  Left = 412
  Top = 237
  BorderStyle = bsDialog
  Caption = 'Schwarz Musicwriter'
  ClientHeight = 246
  ClientWidth = 356
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 24
    Top = 8
    Width = 224
    Height = 18
    Caption = 'Langue - Language - Sprache '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 24
    Top = 40
    Width = 315
    Height = 14
    Caption = 'Choisissez dans la liste votre langue pour Schwarz Musicwriter :'
  end
  object Label3: TLabel
    Left = 24
    Top = 56
    Width = 273
    Height = 14
    Caption = 'Choose Schwarz Musicwriter language in the list below:'
  end
  object langue_list: TListBox
    Left = 48
    Top = 88
    Width = 257
    Height = 105
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 19
    Items.Strings = (
      'Fran'#231'ais - French - Franz'#246'sich'
      'Anglais - English')
    ParentFont = False
    TabOrder = 0
  end
  object cmdOK: TBitBtn
    Left = 48
    Top = 213
    Width = 89
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = cmdOKClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object BitBtn1: TBitBtn
    Left = 152
    Top = 213
    Width = 177
    Height = 25
    Caption = 'Annuler - Cancel'
    TabOrder = 2
    OnClick = BitBtn1Click
    Kind = bkCancel
  end
end
