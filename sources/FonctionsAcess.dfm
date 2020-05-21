object frmFonctionsAccess: TfrmFonctionsAccess
  Left = 260
  Top = 202
  Width = 462
  Height = 316
  Caption = 'Que voulez-vous faire ?'
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
    Left = 16
    Top = 16
    Width = 44
    Height = 14
    Caption = 'Je veux :'
  end
  object txtSearch: TEdit
    Left = 80
    Top = 16
    Width = 361
    Height = 22
    TabOrder = 0
    OnChange = txtSearchChange
  end
  object lstFunctions: TListBox
    Left = 80
    Top = 48
    Width = 361
    Height = 233
    ItemHeight = 14
    TabOrder = 1
  end
end
