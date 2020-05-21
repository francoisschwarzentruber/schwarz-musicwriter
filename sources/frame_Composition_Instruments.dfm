object frameComposition_Instruments: TframeComposition_Instruments
  Left = 0
  Top = 0
  Width = 283
  Height = 238
  TabOrder = 0
  object list: TListBox
    Left = 0
    Top = 0
    Width = 283
    Height = 238
    Style = lbOwnerDrawFixed
    Align = alClient
    ItemHeight = 20
    TabOrder = 0
    OnClick = listClick
    OnDrawItem = listDrawItem
    OnMouseMove = listMouseMove
    OnMouseUp = listMouseUp
  end
end
