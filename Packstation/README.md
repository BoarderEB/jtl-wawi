# Dotliquid Packstation Adressen per Workflow korrigieren in JTL-Wawi

## Checken ob es eine regelkonforme Packstation enthalten ist:
Erweitere Eigenschaften\IstPackstation Enthält True
> file: 0_IstPackstation.liquid

## Als Hinweis setzten das die Adresse geändert wurde.
Als Hinweis wird auch die alte Adresse eingefügt
> Wert setzen Variable Auftrag\Sonstiges\Hinweis
file: 1_Hinweis.liquid

## Wenn Adresszusatz weder Post Nr. noch PackstationsNr hänge an Firmenzusatz an.
> Wert setzen Variable Auftrag\Lieferung\Lieferadresse\Firmenzusatz
file: 2_Firmenzusatz.liquid

## In den Adresszusatz "PackstationsNr,PostnummerNr" (mit komma getrennt) setzen:
> Wert setzen Variable Auftrag\Lieferung\Lieferadresse\Adresszusatz
file: 3_Adresszusatz.liquid

## Die (Packstation + Nr) gehört immer in Straße:
Aus Adresszusatz die PackstationsNr extrahieren und in Straße setzen
> Wert setzen Variable Auftrag\Lieferung\Lieferadresse\Straße
file: 4_Straße.liquid

## Die PostNr gehört immer in den Adresszusatz nur als Zahl ohne "Postnummer"
Aus Adresszusatz die Postnummer extrahieren und in Adresszusatz setzen
> Wert setzen Variable Auftrag\Lieferung\Lieferadresse\Adresszusatz
file: 5_Adresszusatz.liquid