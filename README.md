# Report mensile
## Prerequisiti
Lo script funziona con R, quindi serve scaricare e installare R e RStudio.
Sarà necessario utilizzare 3 pacchetti di R:  
1. `readxl`: permette di importare file Excel,  
2. `tidyverse`: raccoglie tutti i pacchetti dell'universo di tidy (da qui il nome), tra cui `ggplot2`, il più efficiente pacchetto per graficare,
3. `wesanderson`: include palette cromatiche ispirate ai film di Wes Anderson; ovviamente l'installazione di questo pacchetto è facoltativa.  

Sul come installare i pacchetti non c'è da preoccuparsi, è tutto riportato nelle prime righe dello script.
## Struttura del dataset di partenza
Il dataset di partenza, che nello script d'esempio si chiama `gennaio2022.xlsx`, è un file Excel identico a quello che si ottiene da RNF con le classiche aggiunte dei prospetti personali: codice ATC, notorietà, nesso, mail inviate, numero di lotto, settimana di riferimento, ecc.
Per il corretto funzionamento dello scritpt, è necessaria la presenza delle seguenti variabili nominate nel seguente modo:  
- _ATC_: una colonna che raccoglie tutte le ATC; quando una scheda di segnalazione include più farmaci, quindi più ATC, è preferibile avere la seguente formattazione: "ATC1,ATC2" (ad esempio: B,J);
- _Settimana_: una colonna con le settimane di riferimento, ad esempio: "17/01 - 23/01";
- _MAIL_: una colonna che riporta informazioni sulle richieste inviate al RLFV (quando non si inviano mail, non va scritto "NO" ma va lasciata la cella vuota);
- _NESSO_: una colonna con il risultato della valutazione del nesso di causalità.  

Inoltre, è preferibile che la colonna _ETA_ raccolga le età senza " anni"; questa operazione si può svolgere con R o con un trova/sostituisci su Excel prima dell'importazione.  
Nota bene: per evitare di modificare lo script di R, è obbligatorio rispettare le minuscole e le maiuscole dei nomi delle suddette variabili.  
## Alcuni possibili problemi e possibili soluzioni  
**Problema 1**: R non va molto d'accordo con Excel, quindi potrebbero manifestarsi errori nell'importazione del dataset.  
_Soluzione A_: Prova a importare il dataset con l'aiuto di di RStudio, cliccando su "import dataset", solitamente presente nel quadrante in alto a destra, e segui le istruzioni.  
_Soluzione B_: R va molto d'accordo con i file in formato .csv, quindi si potrebbe salvare il proprio dataset in .csv e importarlo in .csv.  
**Problema 2**: Si potrebbe manifestare un errore grafico di qualunque tipo.  
_Soluzione_: Non c'è una soluzione univoca, quindi nel peggiore dei casi contattami.
