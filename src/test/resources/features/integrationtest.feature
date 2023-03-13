#language: de

Funktionalität: Führe Integrationtests aus

  @IntegrationTest
  Szenariogrundriss: Anfrage an Konnektor schicken und prüfen, dass alles läuft

    Gegeben sei TGR schick Get Request an "<healthcheckurl>"
    Wenn TGR finde die erste Anfrage mit Pfad "/connector.sds"
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$..ProductVendorName.text" überein mit "KoCo Connector"

    Beispiele:
      | healthcheckurl                       |
      | http://127.0.0.1:11110/connector.sds |
      | http://127.0.0.1:11210/connector.sds |
      | http://127.0.0.1:11310/connector.sds |
      | http://127.0.0.1:11410/connector.sds |
      | http://127.0.0.1:11510/connector.sds |
