object frmPiano: TfrmPiano
  Left = 213
  Top = 437
  BorderStyle = bsDialog
  Caption = 'Piano'
  ClientHeight = 89
  ClientWidth = 613
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clRed
  Font.Height = -9
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 12
  object PopupMenu1: TPopupMenu
    Left = 208
    Top = 16
    object Rinitialiser1: TMenuItem
      Caption = 'R'#233'initialiser (relever toutes les touches)'
      OnClick = Rinitialiser1Click
    end
  end
  object tmrRelever: TTimer
    Enabled = False
    Interval = 200
    OnTimer = tmrReleverTimer
    Left = 288
    Top = 16
  end
end
