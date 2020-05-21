object frameTransposition: TframeTransposition
  Left = 0
  Top = 0
  Width = 343
  Height = 118
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object lblExpliquer: TLabel
    Left = 256
    Top = 88
    Width = 61
    Height = 14
    Caption = 'Explique moi!'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 80
    Top = 16
    Width = 50
    Height = 14
    Caption = 'octave(s) '
  end
  object Label2: TLabel
    Left = 24
    Top = 56
    Width = 38
    Height = 14
    Caption = 'et d'#39'une'
  end
  object ComboBox1: TComboBox
    Left = 24
    Top = 16
    Width = 49
    Height = 22
    ItemHeight = 14
    TabOrder = 0
    Text = '0'
    Items.Strings = (
      '-5'
      '-4'
      '-3'
      '-2'
      '-1'
      '0'
      '1'
      '2'
      '3'
      '4'
      '5')
  end
  object ComboBox2: TComboBox
    Left = 72
    Top = 56
    Width = 153
    Height = 22
    ItemHeight = 14
    TabOrder = 1
    Text = 'd'#39'une seconde mineure'
    Items.Strings = (
      'd'#39'une seconde mineure'
      'd'#39'une seconde'
      'd'#39'une seconde augment'#233'e'
      'd'#39'une tierce mineure'
      'd'#39'une tierce majeure'
      'd'#39'une tierce augment'#233'e'
      'd'#39'une quarte diminu'#233'e'
      'd'#39'une quarte'
      'd'#39'une quarte augment'#233'e'
      'd'#39'une quinte diminu'#233'e'
      'd'#39'une quinte'
      'd'#39'une quinte augment'#233'e'
      'd'#39'une sixte mineure'
      'd'#39'une sixte majeure'
      'd'#39'une sixte augment'#233'e'
      'd'#39'une septi'#232'me mineure'
      'd'#39'une septi'#232'me majeure')
  end
  object cboVers: TComboBox
    Left = 232
    Top = 56
    Width = 89
    Height = 22
    ItemHeight = 14
    TabOrder = 2
    Text = 'Vers le haut'
    Items.Strings = (
      'Vers le haut'
      'Vers le bas')
  end
  object ComboBox3: TComboBox
    Left = 136
    Top = 16
    Width = 89
    Height = 22
    ItemHeight = 14
    TabOrder = 3
    Text = 'Vers le haut'
    Items.Strings = (
      'Vers le haut'
      'Vers le bas')
  end
end
