object MainFrm: TMainFrm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'YI Home Clip Merger'
  ClientHeight = 347
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 0
    Width = 250
    Height = 13
    Caption = 'Source Directory containing YI captured files/folders'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 68
    Height = 13
    Caption = 'Files Collected'
  end
  object Timez: TLabel
    Left = 8
    Top = 226
    Width = 73
    Height = 13
    Caption = 'Timezone: GMT'
  end
  object Label3: TLabel
    Left = 8
    Top = 248
    Width = 188
    Height = 13
    Caption = 'Target Directory can store merged files'
  end
  object Label4: TLabel
    Left = 8
    Top = 307
    Width = 318
    Height = 13
    Caption = 'Programmed by Chun Kang (ck@qsok.com) under Apache License.'
  end
  object Label5: TLabel
    Left = 8
    Top = 326
    Width = 266
    Height = 13
    Caption = 'http://qsok.com/display/YIHCM/YI+Home+Clip+Merger'
    DragCursor = crHandPoint
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label5Click
  end
  object eSourceDirectory: TEdit
    Left = 8
    Top = 19
    Width = 353
    Height = 21
    ReadOnly = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 368
    Top = 16
    Width = 97
    Height = 25
    Caption = '&Browse'
    TabOrder = 1
    OnClick = Button1Click
  end
  object listSourceFiles: TListBox
    Left = 8
    Top = 67
    Width = 457
    Height = 150
    ItemHeight = 13
    TabOrder = 2
  end
  object cbTimezone: TComboBox
    Left = 88
    Top = 223
    Width = 49
    Height = 21
    Style = csDropDownList
    ItemIndex = 3
    TabOrder = 3
    Text = '+9'
    Items.Strings = (
      '+12'
      '+11'
      '+10'
      '+9'
      '+8'
      '+7'
      '+6'
      '+5'
      '+4'
      '+3'
      '+2'
      '+1'
      '+0'
      '-1'
      '-2'
      '-3'
      '-4'
      '-5'
      '-6'
      '-7'
      '-8'
      '-9'
      '-10'
      '-11'
      '-12')
  end
  object eTargetDirectory: TEdit
    Left = 8
    Top = 264
    Width = 353
    Height = 21
    ReadOnly = True
    TabOrder = 4
  end
  object Button2: TButton
    Left = 368
    Top = 264
    Width = 97
    Height = 25
    Caption = '&Browse'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 368
    Top = 295
    Width = 97
    Height = 25
    Caption = '&Run'
    TabOrder = 6
    OnClick = Button3Click
  end
end
