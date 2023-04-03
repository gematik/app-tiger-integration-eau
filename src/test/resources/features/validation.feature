#language: de

@Version:eAUSignature_0.0.9
Funktionalität: Validiere Nachrichten zwischen Primärsystemen and Konnektoren

  @Test @Demo @Kon1 @Kon2 @Kon3 @Kon4 @Kon5 @Kon6
  Szenario: Zeige Testsuite version
    Gegeben sei TGR zeige grünen Banner "eAUSignature_0.0.9"

  @Demo
  Szenario: Demo modus
    Gegeben sei TGR zeige grünen Banner "Demo modus aktiv! Der Testbericht wird im Anschluß unter target/site/serenity/index.html erstellt"
    Und TGR warte auf Abbruch

  @Test @Kon1
  Szenariogrundriss: Signiere für Konnektor kon24
    Gegeben sei TGR setze Anfrage Timeout auf 300 Sekunden
    Und TGR lösche aufgezeichnete Nachrichten
    # Konfiguration des Signierkonnektors am PS
    Und TGR zeige blauen Banner "Bitte Dokument bei Konnektor <SignierKonnektor> auf Port ${tiger.ports.<SignierKonnektor>} (<SignierKonnName>) signieren"
    Und TGR filtere Anfragen nach Server "<SignierKonnektor>.e2e-test.gematik.solutions:443"
    Wenn TGR finde die erste Anfrage mit Pfad "/connector.sds"
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$..ProductVendorName.text" überein mit "<SignierKonnName>"

    # Validierung der Signieranfrage
    Wenn TGR finde die nächste Anfrage mit Pfad "<signsvcpath>" und Knoten "$.body.Envelope.Body.GetJobNumber" der mit ".*" übereinstimmt
    Und TGR speichere Wert des Knotens "$.body.Envelope.Body.GetJobNumberResponse.JobNumber.text" der aktuellen Antwort in der Variable "eau.jobnumber"
    Und TGR finde die nächste Anfrage mit Pfad "<signsvcpath>" und Knoten "$.body.Envelope.Body.SignDocument.JobNumber.text" der mit "${eau.jobnumber}" übereinstimmt
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.SignDocumentResponse.SignResponse.Status.Result.text" überein mit "OK"
    Und TGR speichere Wert des Knotens "$.body.Envelope.Body.SignDocumentResponse.SignResponse.SignatureObject.Base64Signature.text" der aktuellen Antwort in der Variable "eau.signedDocument"
    # deal with invalid responses line breaks in base64 CDATA
    Und TGR replace "\n" with "" in content of variable "eau.signedDocument"

    Beispiele:
      | SignierKonnektor | signsvcpath              | SignierKonnName |
      | kon24            | /service/v75/signservice | KoCo Connector  |

  @Test @Kon1
  Szenariogrundriss: Prüfe Signatur von kon24 gegen <PruefKonnektor>
    # Konfiguration des Prüfkonnektors am PS
    Wenn TGR zeige roten Banner "Bitte Dokument bei Konnektor <PruefKonnektor> auf Port ${tiger.ports.<PruefKonnektor>} (<PruefKonnName>) verifizieren"
    Und TGR filtere Anfragen nach Server "<PruefKonnektor>.e2e-test.gematik.solutions:443"
    Wenn TGR finde die nächste Anfrage mit dem Pfad "/connector.sds"
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$..ProductVendorName.text" überein mit "<PruefKonnName>"

    # Validierung der Verifikationsanfrage
    Wenn TGR finde die nächste Anfrage mit Pfad "<verifysvcpath>" und Knoten "$.body.Envelope.Body.VerifyDocument.SignatureObject.Base64Signature.text" der mit "${eau.signedDocument}" übereinstimmt
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.VerifyDocumentResponse.Status.Result.text" überein mit "OK"
    Und TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.VerifyDocumentResponse.VerificationResult.HighLevelResult.text" überein mit "VALID"
    Und TGR zeige grünen Banner "Test Kombination <SignierKonnektor> <PruefKonnektor> abgeschlossen"

    Beispiele:
      | SignierKonnektor | PruefKonnektor | verifysvcpath                      | PruefKonnName                                       |
      | kon24            | kon24          | /service/v75/signservice           | KoCo Connector                                      |
      | kon24            | kon26          | /webservices/signatureservice/v7.5 | Research Industrial Systems Engineering (RISE) GmbH |
      | kon24            | kon28          | /webservices/signatureservice/v7.5 | Research Industrial Systems Engineering (RISE) GmbH |
      | kon24            | kon29          | /ws/SignatureService               | secunet Security Networks AG                        |
      | kon24            | kon31          | /ws/SignatureService               | secunet Security Networks AG                        |
      | kon24            | kon32          | /service/v75/signservice           | KoCo Connector                                      |

  @Test @Kon2
  Szenariogrundriss: Signiere für Konnektor kon26
    Gegeben sei TGR setze Anfrage Timeout auf 300 Sekunden
    Und TGR lösche aufgezeichnete Nachrichten
    # Konfiguration des Signierkonnektors am PS
    Und TGR zeige blauen Banner "Bitte Dokument bei Konnektor <SignierKonnektor> auf Port ${tiger.ports.<SignierKonnektor>} (<SignierKonnName>) signieren"
    Und TGR filtere Anfragen nach Server "<SignierKonnektor>.e2e-test.gematik.solutions:443"
    Wenn TGR finde die erste Anfrage mit Pfad "/connector.sds"
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$..ProductVendorName.text" überein mit "<SignierKonnName>"

    # Validierung der Signieranfrage
    Wenn TGR finde die nächste Anfrage mit Pfad "<signsvcpath>" und Knoten "$.body.Envelope.Body.GetJobNumber" der mit ".*" übereinstimmt
    Und TGR speichere Wert des Knotens "$.body.Envelope.Body.GetJobNumberResponse.JobNumber.text" der aktuellen Antwort in der Variable "eau.jobnumber"
    Und TGR finde die nächste Anfrage mit Pfad "<signsvcpath>" und Knoten "$.body.Envelope.Body.SignDocument.JobNumber.text" der mit "${eau.jobnumber}" übereinstimmt
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.SignDocumentResponse.SignResponse.Status.Result.text" überein mit "OK"
    Und TGR speichere Wert des Knotens "$.body.Envelope.Body.SignDocumentResponse.SignResponse.SignatureObject.Base64Signature.text" der aktuellen Antwort in der Variable "eau.signedDocument"
    # deal with invalid responses line breaks in base64 CDATA
    Und TGR replace "\n" with "" in content of variable "eau.signedDocument"

    Beispiele:
      | SignierKonnektor | signsvcpath              | SignierKonnName |
      | kon26            | /webservices/signatureservice/v7.5 | Research Industrial Systems Engineering (RISE) GmbH  |

  @Test @Kon2
  Szenariogrundriss: Prüfe Signatur von kon26 gegen <PruefKonnektor>
    # Konfiguration des Prüfkonnektors am PS
    Wenn TGR zeige roten Banner "Bitte Dokument bei Konnektor <PruefKonnektor> auf Port ${tiger.ports.<PruefKonnektor>} (<PruefKonnName>) verifizieren"
    Und TGR filtere Anfragen nach Server "<PruefKonnektor>.e2e-test.gematik.solutions:443"
    Wenn TGR finde die nächste Anfrage mit dem Pfad "/connector.sds"
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$..ProductVendorName.text" überein mit "<PruefKonnName>"

    # Validierung der Verifikationsanfrage
    Wenn TGR finde die nächste Anfrage mit Pfad "<verifysvcpath>" und Knoten "$.body.Envelope.Body.VerifyDocument.SignatureObject.Base64Signature.text" der mit "${eau.signedDocument}" übereinstimmt
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.VerifyDocumentResponse.Status.Result.text" überein mit "OK"
    Und TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.VerifyDocumentResponse.VerificationResult.HighLevelResult.text" überein mit "VALID"
    Und TGR zeige grünen Banner "Test Kombination <SignierKonnektor> <PruefKonnektor> abgeschlossen"

    Beispiele:
      | SignierKonnektor | PruefKonnektor | verifysvcpath                      | PruefKonnName                                       |
      | kon26            | kon24          | /service/v75/signservice           | KoCo Connector                                      |
      | kon26            | kon26          | /webservices/signatureservice/v7.5 | Research Industrial Systems Engineering (RISE) GmbH |
      | kon26            | kon28          | /webservices/signatureservice/v7.5 | Research Industrial Systems Engineering (RISE) GmbH |
      | kon26            | kon29          | /ws/SignatureService               | secunet Security Networks AG                        |
      | kon26            | kon31          | /ws/SignatureService               | secunet Security Networks AG                        |
      | kon26            | kon32          | /service/v75/signservice           | KoCo Connector                                      |

  @Test @Kon3
  Szenariogrundriss: Signiere für Konnektor kon28
    Gegeben sei TGR setze Anfrage Timeout auf 300 Sekunden
    Und TGR lösche aufgezeichnete Nachrichten
    # Konfiguration des Signierkonnektors am PS
    Und TGR zeige blauen Banner "Bitte Dokument bei Konnektor <SignierKonnektor> auf Port ${tiger.ports.<SignierKonnektor>} (<SignierKonnName>) signieren"
    Und TGR filtere Anfragen nach Server "<SignierKonnektor>.e2e-test.gematik.solutions:443"
    Wenn TGR finde die erste Anfrage mit Pfad "/connector.sds"
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$..ProductVendorName.text" überein mit "<SignierKonnName>"

    # Validierung der Signieranfrage
    Wenn TGR finde die nächste Anfrage mit Pfad "<signsvcpath>" und Knoten "$.body.Envelope.Body.GetJobNumber" der mit ".*" übereinstimmt
    Und TGR speichere Wert des Knotens "$.body.Envelope.Body.GetJobNumberResponse.JobNumber.text" der aktuellen Antwort in der Variable "eau.jobnumber"
    Und TGR finde die nächste Anfrage mit Pfad "<signsvcpath>" und Knoten "$.body.Envelope.Body.SignDocument.JobNumber.text" der mit "${eau.jobnumber}" übereinstimmt
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.SignDocumentResponse.SignResponse.Status.Result.text" überein mit "OK"
    Und TGR speichere Wert des Knotens "$.body.Envelope.Body.SignDocumentResponse.SignResponse.SignatureObject.Base64Signature.text" der aktuellen Antwort in der Variable "eau.signedDocument"
    # deal with invalid responses line breaks in base64 CDATA
    Und TGR replace "\n" with "" in content of variable "eau.signedDocument"

    Beispiele:
      | SignierKonnektor | signsvcpath              | SignierKonnName |
      | kon28            | /webservices/signatureservice/v7.5 | Research Industrial Systems Engineering (RISE) GmbH  |

  @Test @Kon3
  Szenariogrundriss: Prüfe Signatur von kon28 gegen <PruefKonnektor>
    # Konfiguration des Prüfkonnektors am PS
    Wenn TGR zeige roten Banner "Bitte Dokument bei Konnektor <PruefKonnektor> auf Port ${tiger.ports.<PruefKonnektor>} (<PruefKonnName>) verifizieren"
    Und TGR filtere Anfragen nach Server "<PruefKonnektor>.e2e-test.gematik.solutions:443"
    Wenn TGR finde die nächste Anfrage mit dem Pfad "/connector.sds"
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$..ProductVendorName.text" überein mit "<PruefKonnName>"

    # Validierung der Verifikationsanfrage
    Wenn TGR finde die nächste Anfrage mit Pfad "<verifysvcpath>" und Knoten "$.body.Envelope.Body.VerifyDocument.SignatureObject.Base64Signature.text" der mit "${eau.signedDocument}" übereinstimmt
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.VerifyDocumentResponse.Status.Result.text" überein mit "OK"
    Und TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.VerifyDocumentResponse.VerificationResult.HighLevelResult.text" überein mit "VALID"
    Und TGR zeige grünen Banner "Test Kombination <SignierKonnektor> <PruefKonnektor> abgeschlossen"

    Beispiele:
      | SignierKonnektor | PruefKonnektor | verifysvcpath                      | PruefKonnName                                       |
      | kon28            | kon24          | /service/v75/signservice           | KoCo Connector                                      |
      | kon28            | kon26          | /webservices/signatureservice/v7.5 | Research Industrial Systems Engineering (RISE) GmbH |
      | kon28            | kon28          | /webservices/signatureservice/v7.5 | Research Industrial Systems Engineering (RISE) GmbH |
      | kon28            | kon29          | /ws/SignatureService               | secunet Security Networks AG                        |
      | kon28            | kon31          | /ws/SignatureService               | secunet Security Networks AG                        |
      | kon28            | kon32          | /service/v75/signservice           | KoCo Connector                                      |



  @Test @Kon4
  Szenariogrundriss: Signiere für Konnektor kon29
    Gegeben sei TGR setze Anfrage Timeout auf 300 Sekunden
    Und TGR lösche aufgezeichnete Nachrichten
    # Konfiguration des Signierkonnektors am PS
    Und TGR zeige blauen Banner "Bitte Dokument bei Konnektor <SignierKonnektor> auf Port ${tiger.ports.<SignierKonnektor>} (<SignierKonnName>) signieren"
    Und TGR filtere Anfragen nach Server "<SignierKonnektor>.e2e-test.gematik.solutions:443"
    Wenn TGR finde die erste Anfrage mit Pfad "/connector.sds"
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$..ProductVendorName.text" überein mit "<SignierKonnName>"

    # Validierung der Signieranfrage
    Wenn TGR finde die nächste Anfrage mit Pfad "<signsvcpath>" und Knoten "$.body.Envelope.Body.GetJobNumber" der mit ".*" übereinstimmt
    Und TGR speichere Wert des Knotens "$.body.Envelope.Body.GetJobNumberResponse.JobNumber.text" der aktuellen Antwort in der Variable "eau.jobnumber"
    Und TGR finde die nächste Anfrage mit Pfad "<signsvcpath>" und Knoten "$.body.Envelope.Body.SignDocument.JobNumber.text" der mit "${eau.jobnumber}" übereinstimmt
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.SignDocumentResponse.SignResponse.Status.Result.text" überein mit "OK"
    Und TGR speichere Wert des Knotens "$.body.Envelope.Body.SignDocumentResponse.SignResponse.SignatureObject.Base64Signature.text" der aktuellen Antwort in der Variable "eau.signedDocument"
    # deal with invalid responses line breaks in base64 CDATA
    Und TGR replace "\n" with "" in content of variable "eau.signedDocument"

    Beispiele:
      | SignierKonnektor | signsvcpath              | SignierKonnName |
      | kon29            | /ws/SignatureService | secunet Security Networks AG  |

  @Test @Kon4
  Szenariogrundriss: Prüfe Signatur von kon29 gegen <PruefKonnektor>
    # Konfiguration des Prüfkonnektors am PS
    Wenn TGR zeige roten Banner "Bitte Dokument bei Konnektor <PruefKonnektor> auf Port ${tiger.ports.<PruefKonnektor>} (<PruefKonnName>) verifizieren"
    Und TGR filtere Anfragen nach Server "<PruefKonnektor>.e2e-test.gematik.solutions:443"
    Wenn TGR finde die nächste Anfrage mit dem Pfad "/connector.sds"
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$..ProductVendorName.text" überein mit "<PruefKonnName>"

    # Validierung der Verifikationsanfrage
    Wenn TGR finde die nächste Anfrage mit Pfad "<verifysvcpath>" und Knoten "$.body.Envelope.Body.VerifyDocument.SignatureObject.Base64Signature.text" der mit "${eau.signedDocument}" übereinstimmt
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.VerifyDocumentResponse.Status.Result.text" überein mit "OK"
    Und TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.VerifyDocumentResponse.VerificationResult.HighLevelResult.text" überein mit "VALID"
    Und TGR zeige grünen Banner "Test Kombination <SignierKonnektor> <PruefKonnektor> abgeschlossen"

    Beispiele:
      | SignierKonnektor | PruefKonnektor | verifysvcpath                      | PruefKonnName                                       |
      | kon29            | kon24          | /service/v75/signservice           | KoCo Connector                                      |
      | kon29            | kon26          | /webservices/signatureservice/v7.5 | Research Industrial Systems Engineering (RISE) GmbH |
      | kon29            | kon28          | /webservices/signatureservice/v7.5 | Research Industrial Systems Engineering (RISE) GmbH |
      | kon29            | kon29          | /ws/SignatureService               | secunet Security Networks AG                        |
      | kon29            | kon31          | /ws/SignatureService               | secunet Security Networks AG                        |
      | kon29            | kon32          | /service/v75/signservice           | KoCo Connector                                      |


  @Test @Kon5
  Szenariogrundriss: Signiere für Konnektor kon31
    Gegeben sei TGR setze Anfrage Timeout auf 300 Sekunden
    Und TGR lösche aufgezeichnete Nachrichten
    # Konfiguration des Signierkonnektors am PS
    Und TGR zeige blauen Banner "Bitte Dokument bei Konnektor <SignierKonnektor> auf Port ${tiger.ports.<SignierKonnektor>} (<SignierKonnName>) signieren"
    Und TGR filtere Anfragen nach Server "<SignierKonnektor>.e2e-test.gematik.solutions:443"
    Wenn TGR finde die erste Anfrage mit Pfad "/connector.sds"
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$..ProductVendorName.text" überein mit "<SignierKonnName>"

    # Validierung der Signieranfrage
    Wenn TGR finde die nächste Anfrage mit Pfad "<signsvcpath>" und Knoten "$.body.Envelope.Body.GetJobNumber" der mit ".*" übereinstimmt
    Und TGR speichere Wert des Knotens "$.body.Envelope.Body.GetJobNumberResponse.JobNumber.text" der aktuellen Antwort in der Variable "eau.jobnumber"
    Und TGR finde die nächste Anfrage mit Pfad "<signsvcpath>" und Knoten "$.body.Envelope.Body.SignDocument.JobNumber.text" der mit "${eau.jobnumber}" übereinstimmt
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.SignDocumentResponse.SignResponse.Status.Result.text" überein mit "OK"
    Und TGR speichere Wert des Knotens "$.body.Envelope.Body.SignDocumentResponse.SignResponse.SignatureObject.Base64Signature.text" der aktuellen Antwort in der Variable "eau.signedDocument"
    # deal with invalid responses line breaks in base64 CDATA
    Und TGR replace "\n" with "" in content of variable "eau.signedDocument"

    Beispiele:
      | SignierKonnektor | signsvcpath              | SignierKonnName |
      | kon31            | /ws/SignatureService | secunet Security Networks AG  |

  @Test @Kon5
  Szenariogrundriss: Prüfe Signatur von kon31 gegen <PruefKonnektor>
    # Konfiguration des Prüfkonnektors am PS
    Wenn TGR zeige roten Banner "Bitte Dokument bei Konnektor <PruefKonnektor> auf Port ${tiger.ports.<PruefKonnektor>} (<PruefKonnName>) verifizieren"
    Und TGR filtere Anfragen nach Server "<PruefKonnektor>.e2e-test.gematik.solutions:443"
    Wenn TGR finde die nächste Anfrage mit dem Pfad "/connector.sds"
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$..ProductVendorName.text" überein mit "<PruefKonnName>"

    # Validierung der Verifikationsanfrage
    Wenn TGR finde die nächste Anfrage mit Pfad "<verifysvcpath>" und Knoten "$.body.Envelope.Body.VerifyDocument.SignatureObject.Base64Signature.text" der mit "${eau.signedDocument}" übereinstimmt
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.VerifyDocumentResponse.Status.Result.text" überein mit "OK"
    Und TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.VerifyDocumentResponse.VerificationResult.HighLevelResult.text" überein mit "VALID"
    Und TGR zeige grünen Banner "Test Kombination <SignierKonnektor> <PruefKonnektor> abgeschlossen"

    Beispiele:
      | SignierKonnektor | PruefKonnektor | verifysvcpath                      | PruefKonnName                                       |
      | kon31           | kon24          | /service/v75/signservice           | KoCo Connector                                      |
      | kon31           | kon26          | /webservices/signatureservice/v7.5 | Research Industrial Systems Engineering (RISE) GmbH |
      | kon31           | kon28          | /webservices/signatureservice/v7.5 | Research Industrial Systems Engineering (RISE) GmbH |
      | kon31           | kon29          | /ws/SignatureService               | secunet Security Networks AG                        |
      | kon31           | kon31          | /ws/SignatureService               | secunet Security Networks AG                        |
      | kon31           | kon32          | /service/v75/signservice           | KoCo Connector                                      |


  @Test @Kon6
  Szenariogrundriss: Signiere für Konnektor kon32
    Gegeben sei TGR setze Anfrage Timeout auf 300 Sekunden
    Und TGR lösche aufgezeichnete Nachrichten
    # Konfiguration des Signierkonnektors am PS
    Und TGR zeige blauen Banner "Bitte Dokument bei Konnektor <SignierKonnektor> auf Port ${tiger.ports.<SignierKonnektor>} (<SignierKonnName>) signieren"
    Und TGR filtere Anfragen nach Server "<SignierKonnektor>.e2e-test.gematik.solutions:443"
    Wenn TGR finde die erste Anfrage mit Pfad "/connector.sds"
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$..ProductVendorName.text" überein mit "<SignierKonnName>"

    # Validierung der Signieranfrage
    Wenn TGR finde die nächste Anfrage mit Pfad "<signsvcpath>" und Knoten "$.body.Envelope.Body.GetJobNumber" der mit ".*" übereinstimmt
    Und TGR speichere Wert des Knotens "$.body.Envelope.Body.GetJobNumberResponse.JobNumber.text" der aktuellen Antwort in der Variable "eau.jobnumber"
    Und TGR finde die nächste Anfrage mit Pfad "<signsvcpath>" und Knoten "$.body.Envelope.Body.SignDocument.JobNumber.text" der mit "${eau.jobnumber}" übereinstimmt
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.SignDocumentResponse.SignResponse.Status.Result.text" überein mit "OK"
    Und TGR speichere Wert des Knotens "$.body.Envelope.Body.SignDocumentResponse.SignResponse.SignatureObject.Base64Signature.text" der aktuellen Antwort in der Variable "eau.signedDocument"
    # deal with invalid responses line breaks in base64 CDATA
    Und TGR replace "\n" with "" in content of variable "eau.signedDocument"

    Beispiele:
      | SignierKonnektor | signsvcpath              | SignierKonnName |
      | kon32            | /service/v75/signservice | KoCo Connector  |

  @Test @Kon6
  Szenariogrundriss: Prüfe Signatur von kon32 gegen <PruefKonnektor>
    # Konfiguration des Prüfkonnektors am PS
    Wenn TGR zeige roten Banner "Bitte Dokument bei Konnektor <PruefKonnektor> auf Port ${tiger.ports.<PruefKonnektor>} (<PruefKonnName>) verifizieren"
    Und TGR filtere Anfragen nach Server "<PruefKonnektor>.e2e-test.gematik.solutions:443"
    Wenn TGR finde die nächste Anfrage mit dem Pfad "/connector.sds"
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$..ProductVendorName.text" überein mit "<PruefKonnName>"

    # Validierung der Verifikationsanfrage
    Wenn TGR finde die nächste Anfrage mit Pfad "<verifysvcpath>" und Knoten "$.body.Envelope.Body.VerifyDocument.SignatureObject.Base64Signature.text" der mit "${eau.signedDocument}" übereinstimmt
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.VerifyDocumentResponse.Status.Result.text" überein mit "OK"
    Und TGR prüfe aktuelle Antwort stimmt im Knoten "$.body.Envelope.Body.VerifyDocumentResponse.VerificationResult.HighLevelResult.text" überein mit "VALID"
    Und TGR zeige grünen Banner "Test Kombination <SignierKonnektor> <PruefKonnektor> abgeschlossen"

    Beispiele:
      | SignierKonnektor | PruefKonnektor | verifysvcpath                      | PruefKonnName                                       |
      | kon32           | kon24          | /service/v75/signservice           | KoCo Connector                                      |
      | kon32           | kon26          | /webservices/signatureservice/v7.5 | Research Industrial Systems Engineering (RISE) GmbH |
      | kon32           | kon28          | /webservices/signatureservice/v7.5 | Research Industrial Systems Engineering (RISE) GmbH |
      | kon32           | kon29          | /ws/SignatureService               | secunet Security Networks AG                        |
      | kon32           | kon31          | /ws/SignatureService               | secunet Security Networks AG                        |
      | kon32           | kon32          | /service/v75/signservice           | KoCo Connector                                      |

  @IntegrationsTest
  Szenario: IntegrationsTest
    Gegeben sei TGR setze Anfrage Timeout auf 30 Sekunden
    Und TGR filtere Anfragen nach Server "kon2.e2e-test.gematik.solutions:443"
    Wenn TGR finde die erste Anfrage mit Pfad "/connector.sds"
    Dann TGR prüfe aktuelle Antwort stimmt im Knoten "$..ProductVendorName.text" überein mit "KoCo Connector"
