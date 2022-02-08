# libraries
library(readxl) # per importare file excel
library(tidyverse)
library(wesanderson) # ci sono le mie palette preferite

# il primo passo è aprire un nuovo progetto (File -> New Project... -> New Directory -> New Project)
# e scegliere una cartella di destinazione e il nome della directory

# importare il file excel del mese di interesse
#(maggiori informazioni sulla struttura del file nel README)
data <- read_excel("gennaio2022.xlsx") # in questo caso si chiama semplicemente "gennaio2022.xlsx" e non ho esplicitato il percorso del file perché questo è presente nella directory del progetto

# Figura 1 - andamento mensile ((da rivedere))


# Figura 2 - andamento settimanale

data_week <- as.data.frame(table(data$Settimana)) # summarize data
data_week                                         # puoi "stampare" il dataframe appena creato per visualizzarlo in Console e scoprire che le due variabili si chiamano "Var1" e "Freq"

fig2 <- data_week %>%                                                     # chiamo il grafico fig2 e lavoro sul dataframe data_week
  ggplot(aes(x = Var1, y = Freq, width = 0.4)) +                          # sfrutto ggplot, scelgo le variabili in x e y e la dimensione delle barre
  geom_bar(stat = "identity", show.legend = FALSE, fill = "#2c7c94") +    # rimuovo la legenda e definisco il colore (fill)
  geom_text(aes(label = Freq), vjust = -0.5) +                            # aggiungo frequenze sulle barre e con vjust regolo la distanza testo/barre
  theme_classic() +                                                       # scelgo il tema che preferisco
  labs(x = "Settimana", y = "N. di segnalazioni") +                       # rinomino gli assi
  theme(axis.title.y = element_text(margin = margin(r = 20))) +           # regolo la distanza labs/ordinata
  theme(axis.title.x = element_text(margin = margin(r = 70)))             # regolo la distanza labs/ascissa

fig2  # stampo il grafico

# Figura 3 - sesso

data$SESSO <- ifelse((data$SESSO=="F"), "Femmine",
                    ifelse((data$SESSO=="M"), "Maschi", "")) # rinomino "F" e "M" con "Femmine" e "Maschi"

table(data$SESSO)                                     # frequenza assoluta (utile per il testo del report)
round (prop.table(table(data$SESSO))*100, digits = 1) # frequenza percentuale (utile per il testo del report)

data_sesso <- as.data.frame(round (prop.table(table(data$SESSO))*100, digits = 1)) # summarize data con frequenze percentuali

rt3 <- rev(data_sesso$Freq)           # semplici operazioni che saranno utili
pos3 <- cumsum(rt3) - rt3/2           # per il testo delle etichette nel grafico
lbs3 <- paste(rt3, "%", sep = "")     # e per la loro posizione

fig3 <- data_sesso %>%
  ggplot(aes(x = factor(1),
             y = Freq,
             fill = Var1)) +
  geom_col() +
  coord_polar(theta = "y",
              direction = -1) +
  theme_void() +
  geom_label(x = 1.3,                                  # per posizionare le etichette all'esterno
             y = pos3,
             aes(label = lbs3),
             fill = "lightyellow",                     # colore di sfondo delle etichette
             size = 3.5) +
  labs(fill = "Sesso") +
  theme(legend.title = element_text(face="bold")) +    # per grassettare il titolo della legenda
  scale_fill_manual(values = c("#a65852", "#2c7c94"))  # scelgo i colori delle due fette di torta

fig3

# Figura 4 - età

data$eta_grp <- data$ETA                                              # aggiungo la variabile eta_grp
data$eta_grp <- ifelse((data$ETA<18), "<18",                          # e raggruppo le età per 3 fasce d'età:
                       ifelse((data$ETA>18 & data$ETA<=65), "18-64",  # <18, 18-64 e 65+
                              ifelse((data$ETA>64), "65+", "")))

data$eta_grp <- factor(data$eta_grp, levels=c("<18", "18-64", "65+")) # ordino le fasce d'età in ordine crescente

table(data$eta_grp)                                    # frequenza assoluta (utile per il testo del report)
round(prop.table(table(data$eta_grp))*100, digits =1)  # frequenza percentuale (utile per il testo del report)

data_eta <- as.data.frame(table(data$eta_grp))         # summarize data

fig4 <- data_eta %>%
  ggplot(aes(x = Var1, y = Freq, width = 0.4)) +
  geom_bar(stat = "identity", show.legend = FALSE, fill = "#a65852") +
  geom_text(aes(label = Freq), vjust = -0.5) +                              # aggiungo frequenze sulle barre
  theme_classic() +
  labs(x = "Fascia d'età (anni)", y = "N. di segnalazioni") +
  theme(axis.title.y = element_text(margin = margin(r = 20))) +
  theme(axis.title.x = element_text(margin = margin(r = 70)))

fig4

# Figura 5 - fonte di segnalazione

data$FONTE [ which(data$FONTE == "MEDICO")] <- "Medico" 
data$FONTE [ which(data$FONTE == "PAZIENTE/CITTADINO O ALTRA FIGURA PROFESSIONALE NON SANITARIA")] <- "Paziente/cittadino"
data$FONTE [ which(data$FONTE == "FARMACISTA")] <- "Farmacista"
data$FONTE [ which(data$FONTE == "ALTRO OPERATORE SANITARIO")] <- "Altro operatore sanitario"
data$FONTE [ which(data$FONTE == "LETTERATURA")] <- "Letteratura"
data$FONTE [ which(data$FONTE == "AVVOCATO")] <- "Avvocato"
data$FONTE [ which(data$FONTE == "FORZE ARMATE")] <- "Forze armate"
data$FONTE [ which(data$FONTE == "NON DEFINITO")] <- "Non definito" # modificate i campi della variabile data$FONTE
                                                    
data$FONTE <- factor(data$FONTE,                                                     # ordino le fonti. Preferibile riordinarle all'occorrenza,                                              
                     levels=c("Medico", "Farmacista", "Altro operatore sanitario"))  # in modo da avere un ordine sempre decrescente

table(data$FONTE)                                     # frequenza assoluta (utile per il testo del report)
round (prop.table(table(data$FONTE))*100, digits = 1) # frequenza percentuale (utile per il testo del report)

data_fonte <- as.data.frame(table(data$FONTE)) # summarize data

fig5 <- data_fonte %>%
  ggplot(aes(x = Var1, y = Freq, width = 0.4)) +
  geom_bar(stat = "identity", show.legend = FALSE, fill = "#2c7c94") +
  geom_text(aes(label = Freq), vjust = -0.5) + # aggiungo frequenze sulle barre
  theme_classic() +
  labs(x = "Fonte di segnalazione", y = "N. di segnalazioni") +
  theme(axis.title.y = element_text(margin = margin(r = 20))) +
  theme(axis.title.x = element_text(margin = margin(r = 70)))

fig5

# Figura 6 - gravità

data$subgrave <- data$GRAVITA # aggiungo la variabile eta_grp
data$subgrave <- ifelse((data$GRAVITA=="GRAVE - ALTRA CONDIZIONE CLINICAMENTE RILEVANTE"), "Grave - Altra condizione clinicamente rilevante",
                        ifelse((data$GRAVITA=="GRAVE - ANOMALIE CONGENITE/DEFICIT DEL NEONATO"), "Grave - Anomalie congenite/Deficit del neonato",
                                ifelse((data$GRAVITA=="GRAVE - DECESSO"), "Grave - Decesso",
                                        ifelse((data$GRAVITA=="GRAVE - INVALIDITA' GRAVE O PERMAMENTE"), "Grave - Invalidità grave o permamente",
                                                ifelse((data$GRAVITA=="GRAVE - OSPEDALIZZAZIONE O PROLUNGAMENTO OSPEDALIZZAZIONE"), "Grave - Ospedalizzazione",
                                                        ifelse((data$GRAVITA=="GRAVE - PERICOLO DI VITA"), "Grave - Pericolo di vita",
                                                                ifelse((data$GRAVITA=="NON DEFINITO"), "Non definito",
                                                                        ifelse((data$GRAVITA=="NON GRAVE"), "Non grave", "")))))))) # ho modificato i campi della variabile data$GRAVITA
                              
table(data$subgrave)                                     # frequenza assoluta (utile per il testo del report)
round (prop.table(table(data$subgrave))*100, digits = 1) # frequenza percentuale (utile per il testo del report)

data_gravita <- as.data.frame(round (prop.table(table(data$subgrave))*100, digits = 1))

rt6 <- rev(data_gravita$Freq)
pos6 <- cumsum(rt6) - rt6/2
lbs6 <- paste(rt6, "%", sep = "")

fig6 <- data_gravita %>%
  ggplot(aes(x = factor(1),
             y = Freq,
             fill = Var1)) +
  geom_col() +
  coord_polar(theta = "y",
              direction = -1) +
  theme_void() +
  geom_label(x = 1.4,                                       # etichette all'esterno
             y = pos6,
             aes(label = lbs6),
             fill = "lightyellow", 
             size = 3.5) +
  labs(fill = "Gravità") +
  theme(legend.position = "right",
        legend.title = element_text(face="bold")) +
  scale_fill_manual(values = wes_palette("Darjeeling2"))    # scelgo una palette cromatica, in questo caso quella del film "Il treno per il Darjeeling"

fig6

# Figura 7 - esito

data$ESITO <- ifelse((data$ESITO=="DECESSO"), "Decesso",
                     ifelse((data$ESITO=="MIGLIORAMENTO"), "Miglioramento",
                            ifelse((data$ESITO=="NON ANCORA GUARITO"), "Non ancora guarito",
                                   ifelse((data$ESITO=="NON DISPONIBILE"), "Non disponibile",
                                          ifelse((data$ESITO=="RISOLUZIONE COMPLETA ADR IL"), "Risoluzione completa",
                                                 ifelse((data$ESITO=="RISOLUZIONE CON POSTUMI"), "Risoluzione con postumi", "")))))) # ho modificato i campi della variabile data$ESITO

table(data$ESITO)                                     # frequenza assoluta (utile per il testo del report)
round (prop.table(table(data$ESITO))*100, digits = 1) # frequenza percentuale (utile per il testo del report)

data_esito <- as.data.frame(round (prop.table(table(data$ESITO))*100, digits = 1))
rt7 <- rev(data_esito$Freq)
pos7 <- cumsum(rt7) - rt7/2
lbs7 <- paste(rt7, "%", sep = "")

fig7 <- data_esito %>%
  ggplot(aes(x = factor(1),
             y = Freq,
             fill = Var1)) +
  geom_col() +
  coord_polar(theta = "y",
              direction = -1) +
  theme_void() +
  geom_label(x = 1.4,                                   # etichette all'esterno
             y = pos7,
             aes(label = lbs7),
             fill = "lightyellow", 
             size = 3.5) +
  labs(fill = "Esito") +
  theme(legend.position = "right",
        legend.title = element_text(face="bold")) +
  scale_fill_manual(values = wes_palette("Moonrise3"))  # scelgo una palette cromatica, in questo caso quella del film "Moonrise Kingdom"
fig7

# Figura 8 - ATC

atc_set <- tidyr::separate_rows(data = data, ATC, sep =",") # separo i codici ATC sfruttando il separatore "virgola"

table(atc_set$ATC)                                  # frequenza assoluta (utile per il testo del report)
round(prop.table(table(atc_set$ATC))*100, digits=1) # frequenza percentuale (utile per il testo del report)

data_atc <- as.data.frame(table(atc_set$ATC))

fig8 <- data_atc %>%
  ggplot(aes(x = Var1, y = Freq, width = 0.4)) +
  geom_bar(stat = "identity", show.legend = FALSE, fill = "#2c7c94") +
  geom_text(aes(label = Freq), vjust = -0.5) +                              # aggiungo frequenze sulle barre
  theme_classic() +
  labs(x = "Classe ATC", y = "N. di segnalazioni") +
  theme(axis.title.y = element_text(margin = margin(r = 20))) +
  theme(axis.title.x = element_text(margin = margin(r = 70)))

fig8

# export figure (scelgo di esportarle in .png senza esplicitare la directory, quindi finirà nella directory del progetto)

ggsave(fig2, file = "Fig2.png")
ggsave(fig3, file = "Fig3.png")
ggsave(fig4, file = "Fig4.png")
ggsave(fig5, file = "Fig5.png")
ggsave(fig6, file = "Fig6.png", width = 7, height = 4) # nel caso delle figure 6 e 7 scelgo manualmente le dimensioni
ggsave(fig7, file = "Fig7.png", width = 7, height = 4) # perché le dimensioni di default non erano adatte al tipo di grafico
ggsave(fig8, file = "Fig8.png")

# A questo punto abbiamo tutti i grafici necessari per redigere il report mensile
# ma nel testo del report possono essere utili altre informazioni, ad esempio:

# nessi
data$NESSO <- ifelse((data$NESSO=="CORRELABILE"), "correlabile",
                     ifelse((data$NESSO=="INDETERMINATO"), "indeterminato",
                            ifelse((data$NESSO=="NON CLASSIFICABILE"), "non classificabile",
                                   ifelse((data$NESSO=="POSSIBILE"), "possibile",
                                          ifelse((data$NESSO=="PROBABILE"), "probabile",
                                                 data$NESSO)))))

n_vax <- sum(data$NESSO == "correlabile" | data$NESSO == "indeterminato" | data$NESSO == "non correlabile") # numero di schede con vaccini
n_vax

table(data$NESSO)

# richieste inviate
sum(data$MAIL != 0, na.rm = TRUE) # numero email inviate




