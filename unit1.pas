unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Grids, uArtikel, uLagerService;

type
  TFormMain = class(TForm)
    ButtonHinzufuegen: TButton;
    ButtonBearbeiten: TButton;
    ButtonLoeschen: TButton;
    EditArtikelnummer: TEdit;
    EditBezeichnung: TEdit;
    EditEinzelpreis: TEdit;
    EditMindestbestand: TEdit;
    LabelTitel: TLabel;
    StringGrid1: TStringGrid;

    procedure ButtonHinzufuegenClick(Sender: TObject);
    procedure ButtonBearbeitenClick(Sender: TObject);
    procedure ButtonLoeschenClick(Sender: TObject);

  private
    FLagerService: TLagerService;

    procedure GridEinrichten;
    procedure TabelleAktualisieren;
    procedure EingabenLeeren;
    function EingabenLesen(
      out Preis: Double;
      out Mindestbestand: Integer
    ): Boolean;

  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.lfm}

constructor TFormMain.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);

  FLagerService := TLagerService.Create;

  LabelTitel.Caption := 'Mini-Lagerverwaltung';
  ButtonHinzufuegen.Caption := 'Hinzufügen';
  ButtonBearbeiten.Caption := 'Bearbeiten';
  ButtonLoeschen.Caption := 'Löschen';

  ButtonHinzufuegen.OnClick := @ButtonHinzufuegenClick;
  ButtonBearbeiten.OnClick := @ButtonBearbeitenClick;
  ButtonLoeschen.OnClick := @ButtonLoeschenClick;

  GridEinrichten;
  TabelleAktualisieren;
end;

destructor TFormMain.Destroy;
begin
  FreeAndNil(FLagerService);
  inherited Destroy;
end;

procedure TFormMain.GridEinrichten;
begin
  { Reihenfolge ist wichtig: erst Spalten und feste Zeilen,
    dann die Zeilenanzahl. }
  StringGrid1.FixedCols := 0;
  StringGrid1.ColCount := 5;
  StringGrid1.FixedRows := 1;
  StringGrid1.RowCount := 2;

  StringGrid1.Cells[0, 0] := 'Artikelnummer';
  StringGrid1.Cells[1, 0] := 'Bezeichnung';
  StringGrid1.Cells[2, 0] := 'Einzelpreis';
  StringGrid1.Cells[3, 0] := 'Mindestbestand';
  StringGrid1.Cells[4, 0] := 'Bestand';
end;

function TFormMain.EingabenLesen(
  out Preis: Double;
  out Mindestbestand: Integer
): Boolean;
begin
  Result := False;
  Preis := 0;
  Mindestbestand := 0;

  if not TryStrToFloat(Trim(EditEinzelpreis.Text), Preis) then
  begin
    ShowMessage('Bitte einen gültigen Preis eingeben.');
    EditEinzelpreis.SetFocus;
    Exit;
  end;

  if not TryStrToInt(
    Trim(EditMindestbestand.Text), Mindestbestand
  ) then
  begin
    ShowMessage('Bitte einen gültigen Mindestbestand eingeben.');
    EditMindestbestand.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TFormMain.EingabenLeeren;
begin
  EditArtikelnummer.Clear;
  EditBezeichnung.Clear;
  EditEinzelpreis.Clear;
  EditMindestbestand.Clear;
end;

procedure TFormMain.TabelleAktualisieren;
var
  i, c: Integer;
  Artikel: TArtikel;
  Anzahl: Integer;
  NeueZeilenAnzahl: Integer;
begin
  Anzahl := FLagerService.ArtikelAnzahl;

  NeueZeilenAnzahl := Anzahl + 1;
  if NeueZeilenAnzahl < 2 then
    NeueZeilenAnzahl := 2;

  StringGrid1.BeginUpdate;
  try
    StringGrid1.ColCount := 5;
    StringGrid1.RowCount := NeueZeilenAnzahl;

    StringGrid1.Cells[0, 0] := 'Artikelnummer';
    StringGrid1.Cells[1, 0] := 'Bezeichnung';
    StringGrid1.Cells[2, 0] := 'Einzelpreis';
    StringGrid1.Cells[3, 0] := 'Mindestbestand';
    StringGrid1.Cells[4, 0] := 'Bestand';

    { Alle Datenzellen leeren, damit nach dem Löschen
      keine alten Daten stehen bleiben. }
    for i := 1 to StringGrid1.RowCount - 1 do
      for c := 0 to StringGrid1.ColCount - 1 do
        StringGrid1.Cells[c, i] := '';

    for i := 0 to Anzahl - 1 do
    begin
      Artikel := FLagerService.ArtikelAnIndex(i);

      if Artikel <> nil then
      begin
        StringGrid1.Cells[0, i + 1] := Artikel.Artikelnummer;
        StringGrid1.Cells[1, i + 1] := Artikel.Bezeichnung;
        StringGrid1.Cells[2, i + 1] :=
          FormatFloat('0.00', Artikel.Einzelpreis);
        StringGrid1.Cells[3, i + 1] :=
          IntToStr(Artikel.Mindestbestand);
        StringGrid1.Cells[4, i + 1] :=
          IntToStr(Artikel.Bestand);
      end;
    end;
  finally
    StringGrid1.EndUpdate;
  end;
end;

procedure TFormMain.ButtonHinzufuegenClick(Sender: TObject);
var
  Preis: Double;
  Mindestbestand: Integer;
  Fehlermeldung: string;
begin
  if not EingabenLesen(Preis, Mindestbestand) then
    Exit;

  if FLagerService.ArtikelHinzufuegen(
    EditArtikelnummer.Text,
    EditBezeichnung.Text,
    Preis,
    Mindestbestand,
    Fehlermeldung
  ) then
  begin
    TabelleAktualisieren;
    EingabenLeeren;
    ShowMessage('Artikel wurde hinzugefügt.');
  end
  else
    ShowMessage(Fehlermeldung);
end;

procedure TFormMain.ButtonBearbeitenClick(Sender: TObject);
var
  Artikel: TArtikel;
  Preis: Double;
  Mindestbestand: Integer;
  Fehlermeldung: string;
  Nummer: string;
begin
  if (StringGrid1.Row < 1) or
     (StringGrid1.Row > FLagerService.ArtikelAnzahl) then
  begin
    ShowMessage('Bitte zuerst einen Artikel in der Tabelle auswählen.');
    Exit;
  end;

  Nummer := StringGrid1.Cells[0, StringGrid1.Row];
  Artikel := FLagerService.ArtikelSuchen(Nummer);

  if Artikel = nil then
  begin
    ShowMessage('Artikel wurde nicht gefunden.');
    Exit;
  end;

  if Trim(EditBezeichnung.Text) = '' then
    EditBezeichnung.Text := Artikel.Bezeichnung;

  if Trim(EditEinzelpreis.Text) = '' then
    EditEinzelpreis.Text := FloatToStr(Artikel.Einzelpreis);

  if Trim(EditMindestbestand.Text) = '' then
    EditMindestbestand.Text := IntToStr(Artikel.Mindestbestand);

  if not EingabenLesen(Preis, Mindestbestand) then
    Exit;

  if FLagerService.ArtikelBearbeiten(
    Nummer,
    EditBezeichnung.Text,
    Preis,
    Mindestbestand,
    Fehlermeldung
  ) then
  begin
    TabelleAktualisieren;
    EingabenLeeren;
    ShowMessage('Artikel wurde bearbeitet.');
  end
  else
    ShowMessage(Fehlermeldung);
end;

procedure TFormMain.ButtonLoeschenClick(Sender: TObject);
var
  Nummer: string;
  Fehlermeldung: string;
begin
  if (StringGrid1.Row < 1) or
     (StringGrid1.Row > FLagerService.ArtikelAnzahl) then
  begin
    ShowMessage('Bitte zuerst einen Artikel in der Tabelle auswählen.');
    Exit;
  end;

  Nummer := StringGrid1.Cells[0, StringGrid1.Row];

  if MessageDlg(
    'Soll der Artikel ' + Nummer + ' wirklich gelöscht werden?',
    mtConfirmation,
    [mbYes, mbNo],
    0
  ) <> mrYes then
    Exit;

  if FLagerService.ArtikelLoeschen(Nummer, Fehlermeldung) then
  begin
    TabelleAktualisieren;
    EingabenLeeren;
    ShowMessage('Artikel wurde gelöscht.');
  end
  else
    ShowMessage(Fehlermeldung);
end;

end.
