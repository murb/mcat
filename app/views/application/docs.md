# Documentatie MultiCAT

### Introductie

Deze documentatie beschrijft de globale werking van de adaptieve test 'Kwaliteit van leven bij COPD', een [multidimensional computerized adaptive test](https://en.wikipedia.org/wiki/Computerized_adaptive_testing).

### Gebruikers

Er worden in het systeem drie soorten gebruikers onderscheiden: administratoren, examinatoren en deelnemers.


#### Administratoren

Administratoren beheren de applicatie. Ze kunnen vragenlijsten bijwerken, resultaten inzien van alle gebruikers en daarnaast kunnen administratoren examinatoren toevoegen die vervolgens deelnemers kunnen uitnodigen om deel te nemen aan de test.

#### Examinatoren

Examinatoren kunnen deelnemers uitnodigen om deel te nemen aan de test middels een speciaal voor deze deelnemer gegenereerde uitnodigingscode. Deelnemers kunnen achteraf ook door een examinator toegevoegd worden als 'genodigde' wanneer de deelnemer zijn resultaten deelt met de examinator.

#### Deelnemers

Deelnemers kunnen al dan niet geinitieerd door de examniator deelnemen aan deze test en de resultaten van hun test inzien. De resultaten kunnen ze doorsturen naar een examinator zodat hij/zij de resultaten kan inzien. Mocht de deelnemer overigens uitgenodigd zijn door een examinator, dan kan hij/zij de deelnemer ook al terug zien in diens overzicht van genodigden.

Een deelnemer is op het moment van deelname nooit een administrator of examinator; wanneer een van beide is ingelogd worden beide uitgelogd: zo is het ook onmogelijk om 'per ongeluk' andere gegevens in te zien.

### Administratie functies

#### Genodigden

Een administrator kan hier alle uitnodigingen zien van alle examinatoren, en alle resultaten downloaden.

#### Itembanks

Een administrator kan hier een nieuw itembank-bestand uploaden om zo een nieuwe vragenlijst te installeren. Het formaat van dit bestand is een excel bestand met de juiste kop- en voetteksten en werkbladvolgorde, [zie het voorbeeldbestand](/voorbeeld_bestand.xlsx).


#### Examinatoren toevoegen

Een administrator kan een examinator toevoegen door deze te registreren onder 'Nieuwe examinator'. De inloggegevens kunnen dan verstuurd worden aan de examinator.

### Examinator functies

#### Genodigden

Een examinator kan nieuwe deelnemers uitnodigen door een nieuwe uitnodiging te maken. Een uitnodiging kan eventueel geannoteerd worden met een eigen codering en/of commentaar. Zodra de uitnodigingscode is gegenereerd kan een deelnemer worden uitgenodigd met een speciale uitnodigingslink. Vanuit de applicatie kan een standaard e-mail applicatie worden geopend met een concepttekst om een deelnemer uit te nodigen. De applicatie zelf slaat geen e-mailadressen op en de examaminator is zelf, indien wenselijk, verantwoordelijk voor het koppelen van patientgegevens en de uitkomsten van de vragenlijsten.

### Deelnemer functies

Een deelnemer kan slechts een vragenlijst invullen. Registratie, anders dan het invullen van basisgegevens, is niet van toepassing. Persoonsidentificerende gegevens worden niet vastgelegd om identificatie van de deelnemer niet mogelijk te maken.

#### Deelnemer die niet gekoppeld is aan een uitnodiging

Een deelnemer kan een vragenlijst zijn gestart zonder dat hij/zij de uitnodigingslink heeft gebruikt die hij/zij heeft ontvangen van een examinator. In dat geval dient de deelnemer de eindpagina-url door te sturen naar de examinator.

### Technische documentatie

De technische documentatie is een afgeleide van de source code en gegenereerd via YARD. [Open de technische documentatie](http://cat.murb.nl/yarddocs/index.html).

## Image

Om de werking lokaal mogelijk te maken en te testen zonder internet verbinding is er een image voorbereid. Dit is een VirtualBox image gebaseerd op debian.

### Vereisten

Je hebt VirtualBox nodig om de image te gebruiken, deze is beschikbaar voor Mac, Windows, Linux en Solaris: [VirtualBox downloaden](https://www.virtualbox.org/wiki/Downloads)
Een virtuele machine draaien kost bij voorkeur 2GB aan extra geheugen.

### Image toevoegen

1. Start Virtualbox
2. Selecteer Nieuw/New
3. Voer een willekeurige naam in, kies Type Linux, en systeem Debian 64bit
4. Geheugegrootte minimaal 1GB (1024MB), idealiter 2048MB
5. Selecteer de virtuele machine en ga naar Instellingen
6. Ga naar het tabblad Netwerk en klik op Netwerk 2
7. Schakel netwerk 2 in en kies Host only adapter, de defaults zijn verder goed. Klik op Ok.
8. Start de machine en wacht totdat je een bericht lijkend op het volgende ziet:

    Bezoek een van de volgende urls (waarschijnlijk de laatste) om de applicatie te starten:

    10.0.0.5
    192.168.56.101

9. Open je favoriete browser en typ de url, 4x max 3 nummers, over in je browser

