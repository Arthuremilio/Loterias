program Loterias;

uses
  Vcl.Forms,
  Core.Principal in 'View\Core.Principal.pas' {fmrPrincipal},
  Core.Conexao in 'DM\Core.Conexao.pas' {dmConexao: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown := True;
  Application.CreateForm(TfmrPrincipal, fmrPrincipal);
  Application.CreateForm(TdmConexao, dmConexao);
  Application.Run;
end.
