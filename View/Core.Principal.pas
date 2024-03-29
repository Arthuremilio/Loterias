unit Core.Principal;

interface

{$REGION'Uses'}
uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  Data.DB,
  Vcl.Grids,
  Vcl.DBGrids,
  Datasnap.DBClient,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Core.Conexao,
  System.Generics.Collections, Vcl.ComCtrls;
{$ENDREGION}

type
  TfmrPrincipal = class(TForm)
    pnlControle: TPanel;
    sbMega: TSpeedButton;
    gbOpcoes: TGroupBox;
    pnlResultado: TPanel;
    SpeedButton1: TSpeedButton;
    btnMaisSorteados: TSpeedButton;
    btnMenosSorteados: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    edtQtdNumeros: TEdit;
    edtQtdJogos: TEdit;
    qryAuxiliar: TFDQuery;
    mmResultado: TRichEdit;
    GroupBox1: TGroupBox;
    Shape1: TShape;
    Label3: TLabel;
    Shape2: TShape;
    Label4: TLabel;
    Shape3: TShape;
    Label5: TLabel;
    Shape4: TShape;
    Label6: TLabel;
    procedure btnMaisSorteadosClick(Sender: TObject);
    procedure btnMenosSorteadosClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure sbMegaClick(Sender: TObject);
  private
    FTop30MaisSaem: TStringList;
    FTop30MenosSaem: TStringList;
    FTotalNrosSorteados: Integer;

    procedure CarregarTop30MaisSaem;
    procedure CarregarTop30MenosSaem;
    procedure CarregarTotalNrosSorteados;
    procedure validarCampos;
    procedure GerarNrosMaisSorteados;
    procedure GerarNrosMenosSorteados;
    procedure GerarNrosAleatorios;
    procedure ListarTodosSorteios;

  public
    property Top30MaisSaem: TStringList read FTop30MaisSaem write FTop30MaisSaem;
    property Top30MenosSaem: TStringList read FTop30MenosSaem write FTop30MenosSaem;
    property TotalNrosSorteados: Integer read FTotalNrosSorteados write FTotalNrosSorteados;

  end;

var
  fmrPrincipal: TfmrPrincipal;

implementation

{$R *.dfm}

{ TfmrPrincipal }

procedure TfmrPrincipal.btnMenosSorteadosClick(Sender: TObject);
begin
  GerarNrosMenosSorteados;
end;

procedure TfmrPrincipal.CarregarTop30MaisSaem;
const
  SQL_BASE: String = 'SELECT BOLA FROM Top_30_Mais_Saem';

begin
  if Assigned(FTop30MenosSaem) then
    FTop30MaisSaem.Clear
  else
    FTop30MaisSaem := TStringList.Create;
  try
    qryAuxiliar.Close;
    qryAuxiliar.SQL.Text := SQL_BASE;
    qryAuxiliar.Open;

    while not qryAuxiliar.Eof do
    begin
      FTop30MaisSaem.Add(qryAuxiliar.FieldByName('BOLA').AsString);
      qryAuxiliar.Next;
    end;

  except
    on E:Exception do
      raise Exception.Create('E.Message');

  end;
end;

procedure TfmrPrincipal.CarregarTop30MenosSaem;
const
  SQL_BASE: String = 'SELECT BOLA FROM Top_30_Menos_Saem';

begin
  if Assigned(FTop30MenosSaem) then
    FTop30MenosSaem.Clear
  else
    FTop30MenosSaem := TStringList.Create;
  try
    qryAuxiliar.Close;
    qryAuxiliar.SQL.Text := SQL_BASE;
    qryAuxiliar.Open;

    while not qryAuxiliar.Eof do
    begin
      FTop30MenosSaem.Add(qryAuxiliar.FieldByName('BOLA').AsString);
      qryAuxiliar.Next;
    end;

  except
    on E:Exception do
      raise Exception.Create('E.Message');

  end;

end;

function IntegerCompare(Item1, Item2: Pointer): Integer;
begin
  Result := Integer(Item1) - Integer(Item2);
end;

procedure TfmrPrincipal.GerarNrosAleatorios;
const
  SQL_VZS: String = 'SELECT VEZES FROM TODOS_OS_NROS where BOLA = :BOLA';
var
  QtdNumeros, QtdJogos, I, J, VezesNrosSorteados, NumeroSorteado, NumeroAleatorio: Integer;
  NumeroJogo: String;
  NumerosSorteados: TList;
  NumeroComoPointer: Pointer;
  Acertividade, ResultadoAcertividade:Double;
  NumeroJaExiste: Boolean;

begin
  mmResultado.Clear;
  QtdNumeros := StrToIntDef(edtQtdNumeros.Text, 0);
  QtdJogos := StrToIntDef(edtQtdJogos.Text, 0);
  NumerosSorteados := TList.Create;
  CarregarTotalNrosSorteados;

  try
    try
      Randomize;
      for I := 1 to QtdJogos do
      begin
        NumerosSorteados.Clear;
        VezesNrosSorteados := 0;
        NumerosSorteados.Capacity := QtdNumeros;

        while NumerosSorteados.Count < QtdNumeros do
        begin
          NumeroAleatorio := Random(60) + 1;
          NumeroJaExiste := False;
          for J:= 0 to NumerosSorteados.Count - 1 do
          begin
            if NumerosSorteados[J] = Pointer(Integer(NumeroAleatorio)) then
            begin
              NumeroJaExiste := True;
              Break;
            end;
          end;

          if not NumeroJaExiste then

            NumerosSorteados.Add(Pointer(Integer(NumeroAleatorio)));
          end;
        if Assigned(FTop30MaisSaem) then
          FreeAndNil(FTop30MaisSaem);

        NumerosSorteados.Sort(IntegerCompare);

        NumeroJogo := 'Jogo ' + IntToStr(I) + ': ';
        for J := 0 to QtdNumeros - 1 do
        begin

          NumeroJogo := NumeroJogo + Format('%.*d', [2, Integer(NumerosSorteados[J])]);
          if J < QtdNumeros - 1 then
            NumeroJogo := NumeroJogo + ' - ';


          for NumeroComoPointer in NumerosSorteados do
          begin
            NumeroSorteado := Integer(NumeroComoPointer);
            qryAuxiliar.SQL.Text := SQL_VZS;
            qryAuxiliar.ParamByName('BOLA').asInteger := NumeroSorteado;

            qryAuxiliar.Open;
            if not qryAuxiliar.IsEmpty then
              VezesNrosSorteados := VezesNrosSorteados + qryAuxiliar.FieldByName('VEZES').AsInteger;

            qryAuxiliar.Close;
          end;

        end;
        Acertividade := (VezesNrosSorteados * 100.0 / FTotalNrosSorteados) / 6;
        ResultadoAcertividade := StrToFloat(FormatFloat('#.##', Acertividade));
        mmResultado.Font.color := clBlack;
        if Acertividade <= 9.49 then
          mmResultado.SelAttributes.Color := clred;

        if (Acertividade >= 9.50) and (Acertividade <= 10.29)  then
         mmResultado.SelAttributes.Color := clOlive;

        if Acertividade >= 10.30 then
          mmResultado.SelAttributes.Color := clGreen;

          mmResultado.Lines.Add(NumeroJogo + ' - Assertividade: ' + FloatToStr(ResultadoAcertividade) + '%');
      end;
    except
      on E: Exception do
        ShowMessage('Ocorreu um erro: ' + E.Message);

    end;
  finally
    if Assigned(NumerosSorteados) then
      FreeAndNil(NumerosSorteados);

  end;
end;

procedure TfmrPrincipal.GerarNrosMaisSorteados;
const
  SQL_VZS: String = 'SELECT VEZES FROM TOP_30_MAIS_SAEM where BOLA = :BOLA';

var
  QtdNumeros, QtdJogos, I, J, VezesNrosSorteados, NumeroSorteado: Integer;
  IndexAleatorio, Item, NumeroJogo: String;
  NumerosSorteados: TList;
  NumeroComoPointer: Pointer;
  Acertividade, ResultadoAcertividade:Double;

begin
  validarCampos;
  mmResultado.Clear;
  QtdNumeros := StrToIntDef(edtQtdNumeros.Text, 0);
  QtdJogos := StrToIntDef(edtQtdJogos.Text, 0);
  NumerosSorteados := TList.Create;
  CarregarTotalNrosSorteados;

  try
    try
      Randomize;

      for I := 1 to QtdJogos do
      begin
        CarregarTop30MaisSaem;
        NumerosSorteados.Clear;
        VezesNrosSorteados := 0;
        for J := 1 to QtdNumeros do
        begin
          IndexAleatorio := FTop30MaisSaem[Random(FTop30MaisSaem.Count -1)];
          NumerosSorteados.Add(Pointer(StrToInt(IndexAleatorio)));
          for Item in FTop30MaisSaem do
            begin
              if Item = IndexAleatorio then
              begin
                FTop30MaisSaem.Delete(FTop30MaisSaem.IndexOf(IndexAleatorio));
                Break;
              end;
            end;
        end;

        if Assigned(FTop30MaisSaem) then
          FreeAndNil(FTop30MaisSaem);

        NumerosSorteados.Sort(IntegerCompare);
        NumeroJogo := 'Jogo ' + IntToStr(I) + ': ';
        for J := 0 to QtdNumeros - 1 do
        begin
          NumeroJogo := NumeroJogo + Format('%.*d', [2, Integer(NumerosSorteados[J])]);
          if J < QtdNumeros - 1 then
            NumeroJogo := NumeroJogo + ' - ';


          for NumeroComoPointer in NumerosSorteados do
          begin
            NumeroSorteado := Integer(NumeroComoPointer);
            qryAuxiliar.SQL.Text := SQL_VZS;
            qryAuxiliar.ParamByName('BOLA').asInteger := NumeroSorteado;

            qryAuxiliar.Open;
            if not qryAuxiliar.IsEmpty then
              VezesNrosSorteados := VezesNrosSorteados + qryAuxiliar.FieldByName('VEZES').AsInteger;

            qryAuxiliar.Close;
          end;

        end;

        Acertividade := (VezesNrosSorteados * 100.0 / FTotalNrosSorteados) / 6;
        ResultadoAcertividade := StrToFloat(FormatFloat('#.##', Acertividade));
        if Acertividade <= 9.49 then
          mmResultado.SelAttributes.Color := clred;

        if (Acertividade >= 9.50) and (Acertividade <= 10.29)  then
         mmResultado.SelAttributes.Color := clOlive;

        if Acertividade >= 10.30 then
          mmResultado.SelAttributes.Color := clGreen;

          mmResultado.Lines.Add(NumeroJogo + ' - Assertividade: ' + FloatToStr(ResultadoAcertividade) + '%');

      end;

  except
    on E: Exception do
      ShowMessage('Ocorreu um erro: ' + E.Message);
  end;

finally
  if Assigned(NumerosSorteados) then
    FreeAndNil(NumerosSorteados);

  if Assigned(FTop30MaisSaem) then
    FreeAndNil(FTop30MaisSaem);

end;
end;


procedure TfmrPrincipal.GerarNrosMenosSorteados;
const
  SQL_VZS: String = 'SELECT VEZES FROM TOP_30_MENOS_SAEM where BOLA = :BOLA';

var
  QtdNumeros, QtdJogos, I, J, VezesNrosSorteados, NumeroSorteado: Integer;
  IndexAleatorio, Item, NumeroJogo: String;
  NumerosSorteados: TList;
  NumeroComoPointer: Pointer;
  Acertividade, ResultadoAcertividade:Double;

begin
  validarCampos;
  mmResultado.Clear;
  QtdNumeros := StrToIntDef(edtQtdNumeros.Text, 0);
  QtdJogos := StrToIntDef(edtQtdJogos.Text, 0);
  NumerosSorteados := TList.Create;
  CarregarTotalNrosSorteados;

  try
    try
      Randomize;

      for I := 1 to QtdJogos do
      begin
        CarregarTop30MenosSaem;
        NumerosSorteados.Clear;
        VezesNrosSorteados := 0;
        for J := 1 to QtdNumeros do
        begin
          IndexAleatorio := FTop30MenosSaem[Random(FTop30MenosSaem.Count -1)];
          NumerosSorteados.Add(Pointer(StrToInt(IndexAleatorio)));
          for Item in FTop30MenosSaem do
            begin
              if Item = IndexAleatorio then
              begin
                FTop30MenosSaem.Delete(FTop30MenosSaem.IndexOf(IndexAleatorio));
                Break;
              end;
            end;
        end;

        if Assigned(FTop30MenosSaem) then
          FreeAndNil(FTop30MenosSaem);

        NumerosSorteados.Sort(IntegerCompare);
        NumeroJogo := 'Jogo ' + IntToStr(I) + ': ';
        for J := 0 to QtdNumeros - 1 do
        begin
          NumeroJogo := NumeroJogo + Format('%.*d', [2, Integer(NumerosSorteados[J])]);
          if J < QtdNumeros - 1 then
            NumeroJogo := NumeroJogo + ' - ';


          for NumeroComoPointer in NumerosSorteados do
          begin
            NumeroSorteado := Integer(NumeroComoPointer);
            qryAuxiliar.Close;
            qryAuxiliar.SQL.Clear;
            qryAuxiliar.SQL.Add(SQL_VZS);
            qryAuxiliar.ParamByName('BOLA').asInteger := NumeroSorteado;

            qryAuxiliar.Open;
            if not qryAuxiliar.IsEmpty then
              VezesNrosSorteados := VezesNrosSorteados + qryAuxiliar.FieldByName('VEZES').AsInteger;

            qryAuxiliar.Close;
          end;

        end;

        Acertividade := (VezesNrosSorteados * 100.0 / FTotalNrosSorteados) / 6;
        ResultadoAcertividade := StrToFloat(FormatFloat('#.##', Acertividade));
        if Acertividade <= 9.49 then
          mmResultado.SelAttributes.Color := clred;

        if (Acertividade >= 9.50) and (Acertividade <= 10.29)  then
         mmResultado.SelAttributes.Color := clOlive;

        if Acertividade >= 10.30 then
          mmResultado.SelAttributes.Color := clGreen;

          mmResultado.Lines.Add(NumeroJogo + ' - Assertividade: ' + FloatToStr(ResultadoAcertividade) + '%');
      end;

      except
        on E: Exception do
          ShowMessage('Ocorreu um erro: ' + E.Message);
      end;

    finally
      if Assigned(NumerosSorteados) then
        FreeAndNil(NumerosSorteados);

      if Assigned(FTop30MenosSaem) then
        FreeAndNil(FTop30MenosSaem);

    end;
end;

procedure TfmrPrincipal.ListarTodosSorteios;
const
  SQL_BASE: String = 'SELECT DT_CONCURSO, BOLA1, BOLA2, BOLA3, BOLA4, BOLA5, BOLA6 from MEGA ORDER BY DT_CONCURSO ASC';
var
  Data: TDateTime;
  BOLA1, BOLA2, BOLA3, BOLA4, BOLA5, BOLA6: Integer;
begin
  try
    qryAuxiliar.Close;
    qryAuxiliar.SQL.Text := SQL_BASE;
    qryAuxiliar.Open;

    mmResultado.Lines.BeginUpdate; 
    mmResultado.Lines.Clear;
    mmResultado.Lines.Add('**Todos os resultados da mega-sena atualizados!**'); 
    while not qryAuxiliar.Eof do
    begin
      Data := qryAuxiliar.FieldByName('DT_CONCURSO').AsDateTime;
      BOLA1 := qryAuxiliar.FieldByName('BOLA1').AsInteger;
      BOLA2 := qryAuxiliar.FieldByName('BOLA2').AsInteger;
      BOLA3 := qryAuxiliar.FieldByName('BOLA3').AsInteger;
      BOLA4 := qryAuxiliar.FieldByName('BOLA4').AsInteger;
      BOLA5 := qryAuxiliar.FieldByName('BOLA5').AsInteger;
      BOLA6 := qryAuxiliar.FieldByName('BOLA6').AsInteger;
      mmResultado.Lines.Add('Data: ' + FormatDateTime('DD/MM/YYYY', Data) + ' Resultado: ' + IntToStr(BOLA1) + ' - ' + IntToStr(BOLA2) + ' - ' + IntToStr(BOLA3) + ' - ' + IntToStr(BOLA4) + ' - ' + IntToStr(BOLA5) + ' - ' + IntToStr(BOLA6));

      qryAuxiliar.Next;
    end;

    qryAuxiliar.Close;
    mmResultado.SetFocus;
    mmResultado.SelStart := 0;
    edtQtdNumeros.SetFocus;
  finally
    mmResultado.Lines.EndUpdate; 
  end;
end;

procedure TfmrPrincipal.sbMegaClick(Sender: TObject);
begin
  ListarTodosSorteios;
end;

procedure TfmrPrincipal.SpeedButton1Click(Sender: TObject);
begin
  GerarNrosAleatorios;
end;

procedure TfmrPrincipal.validarCampos;
begin
  if Trim(edtQtdNumeros.Text).IsEmpty then
  begin
    edtQtdNumeros.SetFocus;
    raise Exception.Create('Escolha uma quantidade de n�meros para gerar um jogo!');
  end;

  if Trim(edtQtdJogos.Text).IsEmpty then
  begin
    edtQtdJogos.SetFocus;
    raise Exception.Create('Determine a quantidade de jogos que voc� deseja gerar!');
  end;
end;

procedure TfmrPrincipal.CarregarTotalNrosSorteados;
const
  SQL_BASE: String = 'SELECT COUNT (*) FROM MEGA';

begin
  try
    qryAuxiliar.Close;
    qryAuxiliar.SQL.Text := SQL_BASE;
    qryAuxiliar.Open;
    FTotalNrosSorteados := (qryAuxiliar.FieldByName('COUNT').AsInteger) * 6;

  except
    on E:Exception do
      raise Exception.Create('E.Message');

  end;
end;

procedure TfmrPrincipal.btnMaisSorteadosClick(Sender: TObject);
begin
  GerarNrosMaisSorteados;
end;

end.
