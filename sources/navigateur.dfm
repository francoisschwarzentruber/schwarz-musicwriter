object frameNavigateur: TframeNavigateur
  Left = 0
  Top = 0
  Width = 443
  Height = 277
  Cursor = crHandPoint
  Align = alClient
  TabOrder = 0
  OnResize = FrameResize
  object Panel: TPaintBox
    Left = 0
    Top = 0
    Width = 443
    Height = 17
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    OnMouseDown = PanelMouseDown
    OnMouseMove = PanelMouseMove
    OnPaint = PanelPaint
  end
end
