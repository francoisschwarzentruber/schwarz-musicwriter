object frmDuree: TfrmDuree
  Left = 366
  Top = 260
  BorderStyle = bsDialog
  Caption = 'Changer la dur'#233'e des '#233'l'#233'ments s'#233'lectionn'#233'es'
  ClientHeight = 247
  ClientWidth = 339
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    339
    247)
  PixelsPerInch = 96
  TextHeight = 14
  object Label4: TLabel
    Left = 280
    Top = 29
    Width = 35
    Height = 14
    Caption = 'Dur'#233'e :'
  end
  object Bevel1: TBevel
    Left = 273
    Top = 42
    Width = 57
    Height = 33
    Shape = bsBottomLine
  end
  object txtDureeNum: TEdit
    Left = 280
    Top = 48
    Width = 41
    Height = 22
    MaxLength = 3
    TabOrder = 0
    Text = '1'
    OnChange = txtDureeNumChange
    OnKeyDown = txtDureeNumKeyDown
    OnKeyPress = txtDureeNumKeyPress
  end
  object txtDureeDenom: TEdit
    Left = 280
    Top = 80
    Width = 41
    Height = 22
    MaxLength = 3
    TabOrder = 1
    Text = '1'
    OnChange = txtDureeDenomChange
    OnKeyDown = txtDureeDenomKeyDown
    OnKeyPress = txtDureeDenomKeyPress
  end
  inline frameDureeChoix: TframeDureeChoix
    Left = 16
    Top = 8
    Width = 233
    Height = 185
    HorzScrollBar.Visible = False
    VertScrollBar.Visible = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    inherited tlbNotes: TToolBar
      Width = 121
      Wrapable = False
      inherited tbnDbCroche: TToolButton
        Wrap = True
      end
    end
  end
  object cmdApply: TBitBtn
    Left = 64
    Top = 217
    Width = 105
    Height = 25
    Anchors = [akLeft]
    Caption = 'Appliquer'
    TabOrder = 3
    OnClick = cmdApplyClick
    Kind = bkOK
  end
  object Fermer: TBitBtn
    Left = 184
    Top = 217
    Width = 105
    Height = 25
    Anchors = [akLeft]
    Cancel = True
    Caption = '&Fermer'
    ModalResult = 2
    TabOrder = 4
    OnClick = cmdCancelClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
      F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
      000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
      338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
      45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
      3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
      F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
      000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
      338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
      4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
      8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
      333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
      0000}
    NumGlyphs = 2
  end
end
