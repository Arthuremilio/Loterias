object dmConexao: TdmConexao
  Height = 180
  Width = 345
  PixelsPerInch = 120
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=D:\Arthur\Delphi\Loterias\Banco\LOTERIA.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'DriverID=FB')
    Left = 79
    Top = 53
  end
  object FDPhysFBDriverLink: TFDPhysFBDriverLink
    Left = 207
    Top = 53
  end
end
