MiniLagerverwaltung: Projektbeschreibung
1. Überblick

MiniLagerverwaltung ist eine Desktopanwendung zur einfachen Verwaltung eines Lagers. Sie wurde in Lazarus mit Free Pascal (objektorientiert, {$mode objfpc}) entwickelt. Mit dem Programm kann man Lagerartikel erfassen, ändern, löschen und in einer Tabelle anzeigen.

Das Projekt zeigt die Trennung von Oberfläche und Fachlogik und eignet sich als Übungs- oder Schulprojekt für objektorientierte Programmierung.
2. Funktionen

    Artikel hinzufügen: Eingabe von Artikelnummer, Bezeichnung, Einzelpreis und Mindestbestand.
    Artikel bearbeiten: Auswahl in der Tabelle, danach Änderung von Bezeichnung, Preis und Mindestbestand. Leere Felder werden mit den bisherigen Werten gefüllt.
    Artikel löschen: Auswahl in der Tabelle, danach Löschen nach einer Sicherheitsabfrage.
    Tabellenanzeige: Alle Artikel stehen in einem TStringGrid mit den Spalten Artikelnummer, Bezeichnung, Einzelpreis, Mindestbestand und Bestand.

3. Eingabeprüfung

Die Anwendung prüft die Eingaben und zeigt verständliche Meldungen:

    Artikelnummer und Bezeichnung dürfen nicht leer sein.
    Preis und Mindestbestand müssen gültige Zahlen sein.
    Preis und Mindestbestand dürfen nicht negativ sein.
    Eine Artikelnummer darf nur einmal vorkommen (ohne Beachtung der Groß- und Kleinschreibung).

4. Aufbau des Projekts

Das Projekt besteht aus drei Klassen in drei Units:
Unit	Klasse	Aufgabe
uArtikel.pas	TArtikel	Datenklasse mit Artikelnummer, Bezeichnung, Einzelpreis, Mindestbestand und Bestand. Die Artikelnummer ist nur lesbar, damit sie nachträglich nicht verändert wird.
uLagerService.pas	TLagerService	Fachlogik. Verwaltet die Artikelliste (TList), prüft Eingaben und bietet Methoden zum Hinzufügen, Bearbeiten, Löschen und Suchen. Gibt Fehler über Fehlermeldung zurück.
Unit1.pas	TFormMain	Benutzeroberfläche. Liest Eingaben, ruft den Service auf, zeigt Meldungen und aktualisiert die Tabelle.
5. Architektur und Konzepte

    Trennung der Verantwortlichkeiten: Die Oberfläche enthält keine Geschäftsregeln, der Service kennt keine Oberfläche.
    Kapselung: Felder sind privat und nur über Properties erreichbar.
    Speicherverwaltung: Der Service besitzt die Artikelobjekte und gibt sie beim Löschen und im Destruktor frei. Das Formular gibt den Service in seinem Destruktor frei (FreeAndNil).
    Fehlerbehandlung: Methoden liefern Boolean und eine Fehlermeldung als out-Parameter, ohne dass Exceptions für normale Eingabefehler nötig sind.

6. Technische Daten

    Entwicklungsumgebung: Lazarus IDE
    Sprache: Free Pascal (Object Pascal)
    Oberfläche: LCL (TForm, TButton, TEdit, TLabel, TStringGrid)
    Datenhaltung: Nur im Arbeitsspeicher, die Daten gehen beim Schließen verloren.

7. Mögliche Erweiterungen

    Bestandsverwaltung: Wareneingang und Warenausgang im Service.
    Mindestbestand-Warnung: Artikel unter dem Mindestbestand rot markieren.
    Speichern und Laden: Daten in einer Datei (CSV oder JSON) oder in einer Datenbank (SQLite) sichern.
    Suche und Sortierung: Filter nach Bezeichnung, Sortierung per Klick auf die Spaltenüberschrift.
    Gesamtwert des Lagers: Berechnung aus Preis und Bestand.

8. Bedienung

    Programm starten.
    Felder ausfüllen und Hinzufügen klicken.
    Zum Ändern eine Zeile in der Tabelle auswählen, neue Werte eintragen und Bearbeiten klicken.
    Zum Entfernen eine Zeile auswählen und Löschen klicken, dann bestätigen.

Wenn du möchtest, kürze ich die Beschreibung für ein Deckblatt oder eine Präsentation, oder ich schreibe sie als Word- oder PDF-Datei.
