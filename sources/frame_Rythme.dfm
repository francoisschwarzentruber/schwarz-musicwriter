object frameRythme: TframeRythme
  Left = 0
  Top = 0
  Width = 104
  Height = 55
  TabOrder = 0
  object txtRythmeNum: TEdit
    Left = 0
    Top = 0
    Width = 41
    Height = 25
    BevelInner = bvLowered
    BevelKind = bkTile
    BevelOuter = bvSpace
    BorderStyle = bsNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    MaxLength = 3
    ParentFont = False
    TabOrder = 0
    Text = '4'
    OnChange = txtRythmeNumChange
    OnKeyDown = txtIntegerLocalKeyDown
    OnKeyPress = txtIntegerLocalKeyPressed
  end
  object txtRythmeDenom: TEdit
    Left = 0
    Top = 28
    Width = 41
    Height = 25
    BevelInner = bvLowered
    BevelKind = bkTile
    BevelOuter = bvSpace
    BorderStyle = bsNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    MaxLength = 3
    ParentFont = False
    TabOrder = 1
    Text = '4'
    OnChange = txtRythmeDenomChange
    OnKeyDown = txtIntegerLocalKeyDown
    OnKeyPress = txtIntegerLocalKeyPressed
  end
end
