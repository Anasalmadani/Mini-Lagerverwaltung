 
unit uArtikel;

{$mode objfpc}{$H+}

interface

type
  TArtikel = class
  private
    FArtikelnummer: string;
    FBezeichnung: string;
    FEinzelpreis: Double;
    FMindestbestand: Integer;
    FBestand: Integer;
  public
    constructor Create(
      const AArtikelnummer: string;
      const ABezeichnung: string;
      AEinzelpreis: Double;
      AMindestbestand: Integer
    );

    property Artikelnummer: string
      read FArtikelnummer;
    property Bezeichnung: string
      read FBezeichnung write FBezeichnung;
    property Einzelpreis: Double
      read FEinzelpreis write FEinzelpreis;
    property Mindestbestand: Integer
      read FMindestbestand write FMindestbestand;
    property Bestand: Integer
      read FBestand write FBestand;
  end;

implementation

constructor TArtikel.Create(
  const AArtikelnummer: string;
  const ABezeichnung: string;
  AEinzelpreis: Double;
  AMindestbestand: Integer
);
begin
  inherited Create;

  FArtikelnummer := Trim(AArtikelnummer);
  FBezeichnung := Trim(ABezeichnung);
  FEinzelpreis := AEinzelpreis;
  FMindestbestand := AMindestbestand;
  FBestand := 0;
end;

end.

