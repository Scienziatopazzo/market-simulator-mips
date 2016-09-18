# Progetto Architettura II 2016 - prof: M. Re
# studente: Elvis Nava
# MARKET SIMULATOR
# Simula un mercato con prezzi variabili nel tempo.
# L'utente può vendere e comprare titoli, visualizzare il bilancio e i profitti,
# visualizzare il portfolio, lo storico transazioni e lo storico prezzi.

.data

nomePortfolioPrompt: .asciiz "Inserire il nome a cui associare il nuovo portfolio (max 20 caratteri):\n"
titolo: .asciiz "\nMarket Simulator\n\n"
giornoHome: .asciiz "Giorno "
bilancioContanti: .asciiz "Bilancio contanti: "
valorePortfolioTitolo: .asciiz "Valore portfolio: "
bilancioTotaleTitolo: .asciiz "Bilancio totale: "
dollari: .asciiz "$"
virgola: .asciiz ","
profittoGiornalieroTitolo: .asciiz "Profitto giornaliero: "
piu: .asciiz "+"
meno: .asciiz "-"
perc: .asciiz "%"
tab: .asciiz "	"
aCapo: .asciiz "\n"
prezziOggi: .asciiz "Prezzi di oggi:\n"
google: .asciiz "Google"
amazon: .asciiz "Amazon"
apple: .asciiz "Apple"
tesla: .asciiz "Tesla"
intel: .asciiz "Intel"
microsoft: .asciiz "Microsoft"
facebook: .asciiz "Facebook"
twitter: .asciiz "Twitter"
prezziPunt: .asciiz ":	"
selezioneMainPrompt: .asciiz "Digita: 1 Compra  2 Vendi  3 Portfolio  4 Storico Transazioni  5 Storico Prezzi  6 Giorno successivo  7 Home prezzi  8 Menù Selezione Portfolio  9 Esci\n"
selezioneErrore: .asciiz "Numero non riconosciuto\n\n"
selezioneCompraVendiPrompt1: .asciiz "Seleziona il titolo da "
selezioneCompraVendiPrompt2: .asciiz ": 1 Google  2 Amazon  3 Apple  4 Tesla  5 Intel  6 Microsoft  7 Facebook  8 Twitter\n"
selezioneCompraPrompt: .asciiz "comprare"
selezioneVendiPrompt: .asciiz "vendere"
inserireQuantita: .asciiz "\nInserire la quantità: "
failCompra: .asciiz "Non disponi di sufficiente denaro!\n\n"
failVendi: .asciiz "Non possiedi questa quantità di azioni!\n\n"
successoCompraVendiPrompt1: .asciiz " azioni "
successoCompraVendiPrompt2: .asciiz " con successo per un totale di "
successoCompraPrompt: .asciiz " comprate"
successoVendiPrompt: .asciiz " vendute"
portfolioTitolo: .asciiz "Portfolio\nNome	| q.ta	| Valore totale\n"
separatoreTabella: .asciiz "	| "
storicoTransazioniTitolo: .asciiz "Storico Transazioni\nGiorno	| Compra/vendi	| Nome	| q.ta	| Prezzo	| Prezzo totale\n"
tabellaTransazioniC: .asciiz "Compra"
tabellaTransazioniV: .asciiz "Vendi"
storicoTransazioniVuoto: .asciiz "Non è stata ancora effettuata alcuna transazione!\n"
storicoPrezziPrompt: .asciiz "Digita il numero corrispondente allo storico da visualizzare: 1 Google  2 Amazon  3 Apple  4 Tesla  5 Intel  6 Microsoft  7 Facebook  8 Twitter\n"
storicoPrezziTitolo1: .asciiz "Storico Prezzi "
storicoPrezziTitolo2: .asciiz " - Ultimi 10 giorni\nGiorno	| Prezzo\n"
menuSelezionePortfolioPrompt1: .asciiz "Elenco portfolii creati:\n"
menuSelezionePortfolioSeparatore: .asciiz " - "
menuSelezionePortfolioPrompt2: .asciiz "\nDigita: 1 Cambia Portfolio  2 Nuovo Portfolio  3 Elimina Portfolio  4 Riordina Elenco  5 Indietro\n"
cambiaPortfolioPrompt: .asciiz "Digitare il numero corrispondente al portfolio da utilizzare:\n"
cambiaPortfolioSuccesso: .asciiz "Portfolio selezionato: "
nuovoPortfolioPrompt: .asciiz "Inserire il nome del nuovo portfolio:\n"
eliminaPortfolioPrompt: .asciiz "Digitare il numero corrispondente al portfolio da eliminare:\n"
eliminaPortfolioErroreSelezionatoPrompt: .asciiz "Non è possibile eliminare il portfolio attualmente selezionato (o l'unico nella lista).\n\n"
riordinaPortfolioPrompt: .asciiz "Digitare il numero corrispondente al criterio di riordino:  1 Contanti  2 Valore totale azioni  3 Bilancio totale  4 Profitto giornaliero\n"

giorno:	.word 0		#contatore dei giorni
nomiAziende: .word 0, 0, 0, 0, 0, 0, 0, 0		#riservo spazio per un array di riferimenti ai nomi di azienda
																	#la rappresentazione interna dei prezzi è in CENTESIMI
prezzi: .word 70812, 69624, 9434, 21256, 3032, 5065, 11852, 1502	#prezzi di oggi Google, Amazon, Apple, Tesla, Intel, M$, Fb, Twitter
		.space 288													#alloco spazio per 9 giorni di storico prezzi
percVariazionePrezzi: .word 0, 0, 0, 0, 0, 0, 0, 0		#riservo spazio per la variazione percentuale del prezzo da ieri a oggi

#Jump table programma
proceduraSelezionataMain: .word home			#procedura selezionata nel menù iniziale
proceduraSelezionataMenuPortfolio: .word cambiaPortfolio	#procedura selezionata nel sottomenù dei portfolii
primoPortfolioLista: .word portfolio1			#primo elemento della lista di portfolii
portfolioSelezionato: .word portfolio1			#oggetto portfolio attualmente selezionato (funzionalità che sostituisce il fornire il nome dell'oggetto come argomento ai metodi)

.text
#PROCEDURE Programma
.globl main
	.ent main
		main:
		
		la $t0, nomiAziende	#preparo un array di stringhe nomiAziende
		la $t1, google
		sw $t1, ($t0)
		la $t1, amazon
		sw $t1, 4($t0)
		la $t1, apple
		sw $t1, 8($t0)
		la $t1, tesla
		sw $t1, 12($t0)
		la $t1, intel
		sw $t1, 16($t0)
		la $t1, microsoft
		sw $t1, 20($t0)
		la $t1, facebook
		sw $t1, 24($t0)
		la $t1, twitter
		sw $t1, 28($t0)
		
		li $v0, 4
		la $a0, nomePortfolioPrompt
		syscall							#chiedo di inserire il nome del primo utente
		li $v0, 8
		la $t0, portfolioSelezionato
		lw $t0, ($t0)
		addi $a0, $t0, 96		#indirizzo campo nomePortfolio di portofolio1
		li $a1, 20
		syscall							#read string su max 20 byte nel campo nomePortfolio di portfolio1
		
		li $v0, 4
		la $a0, titolo	#stampo il titolo "Market Simulator"
		syscall

		jal nuovoGiorno		#Avanzo al PRIMO GIORNO, generandone i prezzi e visualizzando HOME


		#PROMPT DI SELEZIONE COMANDI		seleziona il comando da eseuguire basandosi su un input numerico
			selezioneMain:
			li $v0, 4
			la $a0, selezioneMainPrompt		#stampa il prompt "Digita: 1 Compra  2 Vendi  3 Portfolio  4 Storico Transazioni  5 Storico Prezzi  6 Giorno successivo  7 Home prezzi 8 Menù Selezione Portfolio 9 Esci\n"
			syscall

			li $v0, 5		#read int
			syscall
			move $t0, $v0	#int è su $t0
			
			li $v0, 4
			la $a0, aCapo	#\n
			syscall
			
			la $t1, proceduraSelezionataMain	#in $t1 l'indirizzo di jump table dove scrivere l'indirizzo procedura selezionata

			#Jump address table
			ble $t0, $zero, selezioneMainErrore		#se int<=0 è errore

			addi $t0, $t0, -1								#case int=1		COMPRA
			bne $t0, $zero, selezioneMainNot1
				li $a0, 0				#setto COMPRA
				la $t2, metodiPortfolio
				lw $t2, ($t2)			#funzione COMPRAVENDI
				sw $t2, ($t1)			#seleziono
				j selezioneMainEsegui 	#eseguo

			selezioneMainNot1:								#case int=2		VENDI
			addi $t0, $t0, -1
			bne $t0, $zero, selezioneMainNot2
				li $a0, 1				#setto VENDI
				la $t2, metodiPortfolio
				lw $t2, ($t2)			#funzione COMPRAVENDI
				sw $t2, ($t1)			#seleziono
				j selezioneMainEsegui 	#eseguo

			selezioneMainNot2:								#case int=3		PORTFOLIO
			addi $t0, $t0, -1
			bne $t0, $zero, selezioneMainNot3
				la $t2, metodiPortfolio
				lw $t2, 4($t2)			#funzione PORTFOLIO
				sw $t2, ($t1)			#seleziono
				j selezioneMainEsegui 	#eseguo

			selezioneMainNot3:								#case int=4		STORICO TRANSAZIONI
			addi $t0, $t0, -1
			bne $t0, $zero, selezioneMainNot4
				la $t2, metodiPortfolio
				lw $t2, 16($t2) 		#funzione STORICO TRANSAZIONI
				sw $t2, ($t1)			#seleziono
				j selezioneMainEsegui 	#eseguo

			selezioneMainNot4:								#case int=5		STORICO PREZZI
			addi $t0, $t0, -1
			bne $t0, $zero, selezioneMainNot5
				la $t2, storicoPrezzi	#funzione STORICO PREZZI
				sw $t2, ($t1)			#seleziono
				j selezioneMainEsegui 	#eseguo

			selezioneMainNot5:								#case int=6		GIORNO SUCCESSIVO
			addi $t0, $t0, -1
			bne $t0, $zero, selezioneMainNot6
				la $t2, nuovoGiorno		#funzione NUOVO GIORNO
				sw $t2, ($t1)			#seleziono
				j selezioneMainEsegui 	#eseguo

			selezioneMainNot6:								#case int=7		SCHERMATA HOME
			addi $t0, $t0, -1
			bne $t0, $zero, selezioneMainNot7
				la $t2, home 			#funzione HOME
				sw $t2, ($t1)			#seleziono
				j selezioneMainEsegui 	#eseguo
			
			selezioneMainNot7:								#case int=8		MENUSELEZIONEPORTFOLIO
			addi $t0, $t0, -1
			bne $t0, $zero, selezioneMainNot8
				la $t2, menuSelezionePortfolio	#funzione MENUSELEZIONEPORTFOLIO
				sw $t2, ($t1)					#seleziono
				j selezioneMainEsegui 			#eseguo

			selezioneMainNot8:								#case int=9		ESCI
			addi $t0, $t0, -1
			bne $t0, $zero, selezioneMainErrore
				j fineProgramma		#ESCI

			selezioneMainErrore:
			li $v0, 4
			la $a0, selezioneErrore 		#stampa il prompt di errore
			syscall
			j selezioneMain 		#ritorno al prompt
			
			#esecuzione del comando selezionato con successo
			selezioneMainEsegui:
			lw $t2, ($t1)			#in $t2 indirizzo procedura selezionata
			jalr $t2				#eseguo
			j selezioneMain			#ritorno al prompt
		

		fineProgramma:
		li $v0, 10
		syscall
	.end main

.globl nuovoGiorno				#Avanza di un giorno, salva il bilancio totale di ieri, scorre l'array dello storico e genera nuovi prezzi,
	.ent nuovoGiorno			#calcola le percentuali di variazione, calcola il bilancio totale di oggi e la perc di profitto e chiama home
		nuovoGiorno:
		addi $sp, $sp, -16	#preserve registers
		sw $s0, ($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $ra, 12($sp)

		la $t0, giorno 		#giorno++
		lw $t1, ($t0)
		addi $t1, $t1, 1
		sw $t1, ($t0)
		
		la $t0, portfolioSelezionato
		lw $t0, ($t0)	
		lw $t1, 76($t0)		#porto il bilancio totale di oggi su quello di ieri
		sw $t1, 80($t0)
		la $t1, giorno
		lw $t1, ($t1)		#giorno di oggi su $t1
		sw $t1, 92($t0)		#ultimoGiornoAggiornato = giorno	(il portfolio in uso durante la transizione di giorno puà fare uso del valore di bilancio di ieri appena salvato)

		#SHIFT PREZZI NELLO STORICO
		la $s0, prezzi 		#indirizzo array prezzi
		addi $s0, $s0, 284	#indirizzo array a partire dall'ultimo valore del 9° giorno
		li $s1, 9			#index i=9
		shiftPrezziLoopGiorni:
			li $s2, 8		#index j=8
			shiftPrezziLoopValori:
				lw $t0, ($s0)
				sw $t0, 32($s0)		#copio il prezzo dell'azione da un giorno a quello successivo

				addi $s2, $s2, -1	#j--
				addi $s0, $s0, -4	#array index--
				bgt $s2, $zero, shiftPrezziLoopValori	#loop per j>0
			addi $s1, $s1, -1	#i--
			bgt $s1, $zero, shiftPrezziLoopGiorni	#loop per i>0

		jal generaPrezzi	#generazione nuovi prezzi giornalieri
			
		#Aggiorno il valore portfolio e lo uso per ottenere il nuovo bilancio totale
		la $t0, portfolioSelezionato
		lw $t0, ($t0)			#setto portfolioModificato a 1
		li $t1, 1
		sw $t1, 72($t0)
			
		la $t0, metodiPortfolio
		lw $t0, 8($t0)
		jalr $t0			#funzione calcValorePortfolio
		
		la $t0, metodiPortfolio
		lw $t0, 12($t0)
		jalr $t0			#funzione calcBilancioTotaleEProfitto
		
		jal home			#schermata home

		lw $s0, ($sp)		#restore registers
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16
		jr $ra
	.end nuovoGiorno

.globl home			#Schermata con giorno, bilanci vari e prezzi odierni
	.ent home
		home:
		addi $sp, $sp, -20		#preserve registers
		sw $s0, ($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $s3, 12($sp)
		sw $ra, 16($sp)
		
		li $v0, 4
		la $a0, giornoHome	#stampo "Giorno "
		syscall
		li $v0, 1
		la $t0, giorno		#stampo il giorno corrente
		lw $a0, ($t0)
		syscall
		li $v0, 4
		la $a0, aCapo
		syscall
		
		la $t0, portfolioSelezionato
		lw $t0, ($t0)		#carico l'indirizzo oggetto portfolio
		addi $a0, $t0, 96	#nomePortfolio
		syscall
		
		la $a0, bilancioContanti	#stampo "Bilancio contanti: "
		syscall
		lw $a0, ($t0)		#stampo i contanti
		li $a1, 0
		jal printValue
		li $v0, 4
		la $a0, tab
		syscall
		
		la $a0, valorePortfolioTitolo		#stampo "Valore portfolio: "
		syscall
		la $t0, metodiPortfolio
		lw $t0, 8($t0)
		jalr $t0				#funzione calcValorePortfolio, aggiorno val portfolio
		la $t0, portfolioSelezionato
		lw $t0, ($t0)				#stampo valore portfolio
		lw $a0, 68($t0)
		li $a1, 0
		jal printValue
		li $v0, 4
		la $a0, aCapo
		syscall
		
		la $a0, bilancioTotaleTitolo	#stampo "Bilancio totale: "
		syscall
		la $t0, portfolioSelezionato
		lw $t0, ($t0)		
		lw $a0, 76($t0)		#stampo il bilancio totale
		li $a1, 0
		jal printValue
		li $v0, 4
		la $a0, tab
		syscall
		
		la $a0, profittoGiornalieroTitolo		#stampo "Profitto giornaliero: "
		syscall
		la $t0, portfolioSelezionato
		lw $t0, ($t0)
		lw $a0, 84($t0)		#stampo il profitto giornaliero
		li $a1, 1
		jal printValue
		li $v0, 4
		la $a0, aCapo
		syscall
		syscall
		
		la $a0, prezziOggi		#stampo "Prezzi di oggi:\n"
		syscall
		li $s0, 8	#index di nomiAziende e di prezzi
		la $s1, nomiAziende
		la $s2, prezzi
		la $s3, percVariazionePrezzi
		homePrezziLoop:		#loop che elenca i prezzi di oggi
			li $v0, 4
			lw $a0, ($s1)	#load indirizzo stringa nome
			syscall					#stampo nome
			la $a0, prezziPunt		#stampo ":  "
			syscall
			lw $a0, ($s2)	#load prezzo
			li $a1, 0		#stampo prezzo
			jal printValue
			li $v0, 4
			la $a0, tab				#tab
			syscall
			lw $a0, ($s3)	#load perc
			li $a1, 1		#stampo perc
			jal printValue
			li $v0, 4
			la $a0, aCapo			#\n
			syscall
			addi $s0, $s0, -1	#index--
			addi $s1, $s1, 4	#index array++
			addi $s2, $s2, 4
			addi $s3, $s3, 4
			bgt $s0, $zero, homePrezziLoop	#loop per i>0
			
		li $v0, 4
		la $a0, aCapo	#\n
		syscall
		
		lw $s0, ($sp)			#restore registers
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $ra, 16($sp)
		addi $sp, $sp, 20
		jr $ra
	.end home
	
.globl storicoPrezzi
	.ent storicoPrezzi
		storicoPrezzi:
		addi $sp, $sp, -4		#preserve registers
		sw $ra, ($sp)
		
		li $v0, 4
		la $a0, storicoPrezziPrompt	#stampa "Digita il numero corrispondente allo storico da visualizzare: 1 Google  2 Amazon  3 Apple  4 Tesla  5 Intel  6 Microsoft  7 Facebook  8 Twitter\n"
		syscall
		li $v0, 5	#read int
		syscall
		addi $t2, $v0, -1
		blt $t2, $zero, storicoPrezziErrore	#check numero corretto
		li $t0, 7
		bgt $t2, $t0, storicoPrezziErrore
		sll $t2, $t2, 2		#index array aziende su $t2
		
		li $v0, 4
		la $a0, storicoPrezziTitolo1	#stampo "Storico Prezzi "
		syscall
		la $t0, nomiAziende
		add $t0, $t0, $t2
		lw $a0, ($t0)		#stampo nome azienda
		syscall
		la $a0, storicoPrezziTitolo2	#stampo " - Ultimi 10 giorni\nGiorno	| Prezzo\n"
		syscall
		
		li $t0, 10		#index i=10 (10 giorni di storico)
		la $t3, giorno
		lw $t1, ($t3)	#giorno di oggi su $t1
		la $t3, prezzi	#array storico prezzi
		add $t2, $t3, $t2	#index array prezzi corrisp. al prezzo dell'azienda scelta su $t2
		storicoPrezziPrintLoop:
			li $v0, 1
			move $a0, $t1	#stampo il giorno
			syscall
			li $v0, 4
			la $a0, separatoreTabella	#"	| "
			syscall
			lw $a0, ($t2)	#stampo $ prezzo del giorno
			li $a1, 0
			jal printValue
			li $v0, 4
			la $a0, aCapo
			syscall
			
			addi $t0, $t0, -1	#index--
			addi $t1, $t1, -1	#giorno--
			addi $t2, $t2, 32	#index array prezzi azienda++
			blt $t1, $zero, storicoPrezziEnd	#finisco il loop se raggiungo il giorno 0
			ble $t0, $zero, storicoPrezziEnd	#loop per i>0
			j storicoPrezziPrintLoop
		
		
		storicoPrezziErrore:
		li $v0, 4
		la $a0, selezioneErrore	#stampo "Numero non riconosciuto"
		syscall
		
		storicoPrezziEnd:
		li $v0, 4
		la $a0, aCapo
		syscall
		
		lw $ra, ($sp)			#restore registers
		addi $sp, $sp, 4
		jr $ra
	.end storicoPrezzi

.globl generaPrezzi			#genera pseudo-randomicamente nuovi prezzi giornalieri variando in percentuale quelli precedenti
	.ent generaPrezzi
		generaPrezzi:
		addi $sp, $sp, -24 		#preserve registers
		sw $s0, ($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $s3, 12($sp)
		sw $s4, 16($sp)
		sw $ra, 20($sp)
		
		li $s0, 8			#index i=8 per passare tutti i prezzi
		la $s1, prezzi		#su $s1 l'indirizzo array prezzi
		move $s2, $s1		#seed1
		la $t0, portfolioSelezionato
		lw $t0, ($t0)
		lw $s3, 88($t0)		#ottengo su $s3 l'indirizzo corrispondente al record dell'ultima operazione dello storico, il contenuto del record costituirà il seed3 (che è l'unico a variare con l'input dell'utente)
		bne $s3, $zero, generaPrezziSiOp	#se $s3 è zero l'utente non ha effettuato alcuna operazione, prendo anche seed3 dall'array prezzi
			addi $s3, $s1, 8
		generaPrezziSiOp:
		la $s4, percVariazionePrezzi	#su $s4 l'array delle percentuali
		
		generaPrezziLoop:
			#genero un numero casuale su $t0, XORSHIFT
			lw $t0, ($s2)	#seed1 $t0
			lw $t1, 4($s2)	#seed2 $t1
			lw $t2, ($s3)	#seed3 $t2
			
			sll $t3, $t0, 6
			xor $t0, $t0, $t3
			srl $t3, $t0, 8
			xor $t0, $t0, $t3
			xor $t1, $t1, $t2
			srl $t3, $t1, 19
			xor $t1, $t1, $t3
			xor $t0, $t0, $t1	#pseudorandom su $t0
			
			#ottengo a partire da esso un valore tra -1000 e 1000
			li $t1, 2000
			div $t0, $t1
			mfhi $t0
			bge $t0, $zero, generaPrezziLoopL1Mod	#val ass
				li $t1, -1
				mult $t0, $t1
				mflo $t0
			generaPrezziLoopL1Mod:		#in $t0 resto mod 2000
			addi $t0, $t0, -1000
			
			#aggiorno i prezzi usando il valore generato
			li $t1, 10000
			lw $t2, ($s1)		#load prezzo di ieri (è ancora salvato nella casella di oggi)
			bgt $t0, $zero, generaPrezziLoopPercPositiva #modifico il prezzo odierno usando la percentuale ((($t0+10000) * prezzoieri)/10000) se $t0 neg
				sw $t0, ($s4)		#store perc (il valore è già corretto)
				add $t0, $t0, $t1
				mult $t0, $t2
				mflo $t0
				div $t0, $t0, $t1
				sw $t0, ($s1)		#store prezzo di oggi
				j generaPrezziLoopAggSeed
			generaPrezziLoopPercPositiva:		#uso la percentuale come percentuale sul prezzo di ieri rispetto a quello di oggi ((prezzoieri * 10000)/(10000-$t0)) se $t0 pos
				move $a1, $t2
				mult $t2, $t1
				mflo $t2
				sub $t0, $t1, $t0
				div $t0, $t2, $t0
				sw $t0, ($s1)		#store prezzo di oggi
				move $a0, $t0
				jal calcoloPercentuale	#calcolo su $v0 la perc vera e propria
				sw $v0, ($s4)			#store perc
			
			#modifico l'index array del seed
			generaPrezziLoopAggSeed:
			addi $s2, $s2, 4		#seed1++
			la $t0, portfolioSelezionato
			lw $t0, ($t0)
			lw $t0, 88($t0)			#$t0 indirizzo inizio record
			beq $t0, $zero, generaPrezziLoopNotOutOfBounds		#se seed3 è preso dal record delle op, devo evitare che vada out of bounds
				addi $t1, $t0, 24	#$t1 indirizzo fine record
				blt $s3, $t1, generaPrezziLoopNotOutOfBounds	#se indirizzoseed è minore dell'indirizzofinerecord allora non è outofbounds
					move $s3, $t0	#ricomincio dall'inizio del record
					j generaPrezziLoopAggIndex
			generaPrezziLoopNotOutOfBounds:
				addi $s3, $s3, 4	#seed3++
			
			#aggiorno gli index
			generaPrezziLoopAggIndex:
			addi $s0, $s0, -1		#i--
			addi $s1, $s1, 4		#array prezzi++
			addi $s4, $s4, 4		#array perc++
			bgt $s0, $zero, generaPrezziLoop	#loop per i>0
		
		lw $s0, ($sp)			#restore registers
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $ra, 20($sp)
		addi $sp, $sp, 24
		jr $ra
	.end generaPrezzi
	
.globl menuSelezionePortfolio	#sottomenù che visualizza la lista dei portfolii e permette di selezionarne uno, crearne uno ed eseguire altre operazioni
	.ent menuSelezionePortfolio
		menuSelezionePortfolio:
		addi $sp, $sp, -4		#preserve registers
		sw $ra, ($sp)
		
		menuSelezionePortfolioElenco:
		li $v0, 4
		la $a0, menuSelezionePortfolioPrompt1	#stampo "Elenco portfolii creati:\n\n"
		syscall
		
		li $t0, 1						#index lista su $t0
		la $t1, primoPortfolioLista
		lw $t1, ($t1)					#indirizzo elemento della lista su $t1
		
		menuSelezionePortfolioLoop:
			li $v0, 1
			move $a0, $t0		#stampo index
			syscall
			li $v0, 4
			la $a0, menuSelezionePortfolioSeparatore	#" - "
			syscall
			addi $a0, $t1, 96	#stampo il nomePortfolio
			syscall
			
			addi $t0, $t0, 1	#index++
			lw $t1, 116($t1)	#nuovo indirizzo elemento
			bne $t1, $zero, menuSelezionePortfolioLoop	#continuo a elencare se la lista non è finita
		
		menuSelezionePortfolioInizio:
		li $v0, 4
		la $a0, menuSelezionePortfolioPrompt2	#stampo "\nDigita: 1 Cambia Portfolio  2 Nuovo Portfolio  3 Elimina Portfolio  4 Riordina Elenco  5 Indietro"
		syscall
		
		li $v0, 5		#read int
		syscall
		move $t0, $v0	#int è su $t0	
		li $v0, 4
		la $a0, aCapo	#\n
		syscall
			
		la $t1, proceduraSelezionataMenuPortfolio	#in $t1 l'indirizzo di jump table dove scrivere l'indirizzo procedura selezionata

		#Jump address table
		ble $t0, $zero, menuSelezionePortfolioErrore	#se int<=0 è errore

		addi $t0, $t0, -1								#case int=1		CAMBIAPORTFOLIO
		bne $t0, $zero, menuSelezionePortfolioNot1
			la $t2, cambiaPortfolio		#funzione CAMBIAPORTFOLIO
			sw $t2, ($t1)
			j menuSelezionePortfolioEsegui
		
		menuSelezionePortfolioNot1:
		addi $t0, $t0, -1								#case int=2		NUOVOPORTFOLIO
		bne $t0, $zero, menuSelezionePortfolioNot2
			la $t2, nuovoPortfolio		#funzione NUOVOPORTFOLIO
			sw $t2, ($t1)
			j menuSelezionePortfolioEsegui
		
		menuSelezionePortfolioNot2:
		addi $t0, $t0, -1								#case int=3		ELIMINAPORTFOLIO
		bne $t0, $zero, menuSelezionePortfolioNot3
			la $t2, eliminaPortfolio	#funzione ELIMINAPORTFOLIO
			sw $t2, ($t1)
			j menuSelezionePortfolioEsegui
		
		menuSelezionePortfolioNot3:
		addi $t0, $t0, -1								#case int=4		RIORDINAPORTFOLIO
		bne $t0, $zero, menuSelezionePortfolioNot4
			la $t2, riordinaPortfolio	#funzione RIORDINAPORTFOLIO
			sw $t2, ($t1)
			j menuSelezionePortfolioEsegui
			
		menuSelezionePortfolioNot4:
		addi $t0, $t0, -1								#case int=5		INDIETRO
		bne $t0, $zero, menuSelezionePortfolioErrore
			j menuSelezionePortfolioFine	#fine procedura
		
		menuSelezionePortfolioErrore:
		li $v0, 4
		la $a0, selezioneErrore		#stampo errore
		syscall
		j menuSelezionePortfolioInizio
		
		menuSelezionePortfolioEsegui:
		lw $t2, ($t1)
		jalr $t2							#eseguo procedura selezionata
		j menuSelezionePortfolioElenco		#ricomincio con l'elenco
		
		menuSelezionePortfolioFine:
		lw $ra, ($sp)			#restore registers
		addi $sp, $sp, 4
		jr $ra
	.end menuSelezionePortfolio

.globl cambiaPortfolio			#modifico portfolio su cui operare
	.ent cambiaPortfolio
		cambiaPortfolio:
		addi $sp, $sp, -4		#preserve registers
		sw $ra, ($sp)
		
		li $v0, 4
		la $a0, cambiaPortfolioPrompt #stampa "Digitare il numero corrispondente al portfolio da utilizzare"
		syscall
		
		li $v0, 5	#read int i
		syscall
		move $t0, $v0
		blt $t0, $zero, cambiaPortfolioErrore	#i<0 errore
		la $t1, primoPortfolioLista
		lw $t1, ($t1)						#su $t1 l'indirizzo del portfolio passato in loop
		la $t2, portfolioSelezionato		#su $t2 l'indirizzo della jump table dove salvare l'indirizzo oggetto portfolio
		
		cambiaPortfolioLoop:
		addi $t0, $t0, -1
		beq $t0, $zero, continuaCambiaPortfolio		#se i corrente è 1, allora sono arrivato al portfolio corretto da selezionare
		lw $t1, 116($t1)							#indirizzo portfolio successivo su $t1
		bne $t1, $zero, cambiaPortfolioLoop			#se il nuovo portfolio esiste continuo il loop, altrimenti errore
		
		cambiaPortfolioErrore:
		li $v0, 4
		la $a0, selezioneErrore		#stampa messaggio di errore
		syscall
		j endCambiaPortfolio
		
		continuaCambiaPortfolio:
		sw $t1, ($t2)		#salvo in portfolioSelezionato l'indirizzo del nuovo portfolio selezionato
		li $v0, 4
		la $a0, cambiaPortfolioSuccesso	#stampo "Portfolio selezionato: "
		syscall
		addi $a0, $t1, 96				#stampo nome
		syscall
		la $a0, aCapo
		syscall
		
		jal aggiornaPortfolioSelezionato	#aggiorno i valori del portfolio selezionato
		
		endCambiaPortfolio:
		lw $ra, ($sp)			#restore registers
		addi $sp, $sp, 4
		jr $ra
	.end cambiaPortfolio
	
.globl nuovoPortfolio			#creo un nuovo portfolio in fondo alla lista dei portfolii, una sorta di "costruttore" degli oggetti senza argomenti, che però chiede in input il nuovo nome
	.ent nuovoPortfolio
		nuovoPortfolio:
		la $t0, primoPortfolioLista
		lw $t1, ($t0)			#su $t1 il portfolio passato in loop
		nuovoPortfolioLoop:
			move $t0, $t1
			lw $t1, 116($t0)
			bne $t1, $zero, nuovoPortfolioLoop	#loop finchè su $t0 ho l'ultimo elemento della lista
		
		li $v0, 9			#alloco 120 byte per il nuovo portfolio
		li $a0, 120
		syscall
		sw $v0, 116($t0)	#inserisco il link al nuovo portfolio in fondo all'ultimo della lista
		move $t0, $v0		#in $t0 indirizzo del nuovo portfolio creato
		
		li $t1, 1000000
		sw $t1, ($t0)		#inizializzo 1000000 nel campo contanti
		sw $t1, 76($t0)		#inizializzo 1000000 nel campo bilancioTotale (di oggi)
		sw $t1, 80($t0)		#idem nel campo bilancioTotale (di ieri)
		
		la $t1, giorno
		lw $t1, ($t1)		#in $t1 giorno di oggi
		sw $t1, 92($t0)		#giorno di oggi nel campo ultimoGiornoAggiornato
		
		li $v0, 4
		la $a0, nuovoPortfolioPrompt	#stampo "Inserire il nome del nuovo portfolio"
		syscall
		li $v0, 8
		addi $a0, $t0, 96	#read string con buffer nel campo nomePortfolio del nuovo portfolio
		li $a1, 20
		syscall
		li $v0, 4
		la $a0, aCapo
		syscall
		
		jr $ra
	.end nuovoPortfolio
	
.globl eliminaPortfolio		#elimino dalla lista il portfolio scelto, se è quello attualmente selezionato dò errore
	.ent eliminaPortfolio
		eliminaPortfolio:
		li $v0, 4
		la $a0, eliminaPortfolioPrompt	#stampo "Digitare il numero corrispondente al portfolio da eliminare:"
		syscall
		li $v0, 5		#read int i
		syscall
		move $t0, $v0	#int è su $t0
		
		li $v0, 4
		la $a0, aCapo
		syscall
		
		blt $t0, $zero, eliminaPortfolioErrore		#i<0 dà errore
		
		la $t2, primoPortfolioLista		#su $t2 l'indirizzo dove si salva il link al primo portfolio della lista
		lw $t1, ($t2)					#su $t1 primo portfolio della lista
		la $t3, portfolioSelezionato
		lw $t3, ($t3)					#su $t3 il portfolio attualmente selezionato
		addi $t0, $t0, -1
		bne $t0, $zero, eliminaPortfolioPreLoop		#loop normale se i>1, altrimenti se i=1 routine speciale che cambia il link al primo el. della lista
			beq $t1, $t3, eliminaPortfolioErroreSelezionato	#se il portfolio è quello selezionato, non si può eliminare
			lw $t1, 116($t1)
			sw $t1, ($t2)		#salvo l'indirizzo del secondo elemento al posto del primo elemento
			j eliminaPortfolioEnd
		
		eliminaPortfolioPreLoop:
		lw $t4, 116($t1)		#in $t4 il portfolio da passare in loop, in $t1 quello precedente
		beq $t4, $zero, eliminaPortfolioErrore
		
		eliminaPortfolioLoop:
			addi $t0, $t0, -1
			beq $t0, $zero, eliminaPortfolioContinua		#rompo il loop quando ho selezionato in $t4 il portfolio da rimuovere e in $t1 quello precedente
			move $t1, $t4									#portfolio attuale diventa quello precedente
			lw $t4, 116($t4)								#nuovo portfolio loop
			bne $t4, $zero, eliminaPortfolioLoop			#se il nuovo portfolio esiste continuo il loop, altrimenti errore
			
		eliminaPortfolioErrore:
		li $v0, 4
		la $a0, selezioneErrore
		syscall
		j eliminaPortfolioEnd
			
		eliminaPortfolioContinua:
		beq $t4, $t3, eliminaPortfolioErroreSelezionato		#se il portfolio è quello selezionato, non si può rimuovere
		lw $t4, 116($t4)		#in $t4 portfolio successivo a quello da rimuovere
		sw $t4, 116($t1)		#salvo il suo indirizzo al posto del portfolio da rimuovere alla fine del portfolio precedente
								#ho eliminato tutti i link al portfolio rimosso, non posso fare altro essendo impossibile deallocare la memoria
		j eliminaPortfolioEnd
		
		eliminaPortfolioErroreSelezionato:
		li $v0, 4
		la $a0, eliminaPortfolioErroreSelezionatoPrompt
		syscall
		
		eliminaPortfolioEnd:
		jr $ra
	.end eliminaPortfolio
	
.globl riordinaPortfolio		#seleziono una proprietà per la quale ordinare la lista di portfolii, utilizzo il bubble sort
	.ent riordinaPortfolio
		riordinaPortfolio:
		addi $sp, $sp, -20		#preserve registers
		sw $s0, ($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $s3, 12($sp)
		sw $ra, 16($sp)
		
		li $v0, 4
		la $a0, riordinaPortfolioPrompt		#stampo "Digitare il numero corrispondente al criterio di riordino:  1 Contanti  2 Valore totale azioni  3 Bilancio totale  4 Profitto giornaliero\n"
		syscall
		li $v0, 5			#read int
		syscall
		move $t0, $v0		#int su $t0
		li $v0, 4
		la $a0, aCapo
		syscall
		
		ble $t0, $zero, riordinaPortfolioSelezioneErrore		#errore per i<0
		
		addi $t0, $t0, -1										#case int=1, contanti
		bne $t0, $zero, riordinaPortfolioSelezioneNot1	
			li $s0, 0						#in $s0 l'indirizzo del campo dell'oggetto da confrontare: contanti
			j riordinaPortfolioContinua		#i contanti non hanno bisogno di un aggiornamento dei valori interni dei portfolii
		
		riordinaPortfolioSelezioneNot1:
		addi $t0, $t0, -1										#case int=2, valore totale azioni
		bne $t0, $zero, riordinaPortfolioSelezioneNot2
			li $s0, 68						#campo da confrontare: valore totale azioni
			j riordinaPortfolioPreLoopAggiornamento		#devo aggiornare i valori interni di ogni portfolio
		
		riordinaPortfolioSelezioneNot2:
		addi $t0, $t0, -1										#case int=3, bilancio totale
		bne $t0, $zero, riordinaPortfolioSelezioneNot3
			li $s0, 76						#campo da confrontare: bilancio totale
			j riordinaPortfolioPreLoopAggiornamento
		
		riordinaPortfolioSelezioneNot3:
		addi $t0, $t0, -1										#case int=4, profitto giornaliero
		bne $t0, $zero, riordinaPortfolioSelezioneErrore
			li $s0, 84						#campo da confrontare: profitto giornaliero
			j riordinaPortfolioPreLoopAggiornamento

		riordinaPortfolioSelezioneErrore:
		li $v0, 4
		la $a0, selezioneErrore
		syscall
		j riordinaPortfolioEnd
		
		riordinaPortfolioPreLoopAggiornamento:
		la $s2, portfolioSelezionato	#in $s2 l'indirizzo dove salvare il portfolio selezionato
		lw $s1, ($s2)					#in $s1 backup del portfolio selezionato
		la $t0, primoPortfolioLista
		lw $s3, ($t0)					#in $s3 il portfolio passato in loop
		riordinaPortfolioLoopAggiornamento:
			sw $s3, ($s2)						#seleziono il portfolio attuale
			jal aggiornaPortfolioSelezionato	#aggiorno il portfolio
			lw $s3, 116($s3)					#passo in $s3 il portfolio successivo
			bne $s3, $zero, riordinaPortfolioLoopAggiornamento	#se il nuovo portfolio esiste continuo il loop
		sw $s1, ($s2)		#ripristino il backup del portfolio selezionato
		
		#BUBBLE SORT
		riordinaPortfolioContinua:
		la $s1, primoPortfolioLista			#in $s1 indirizzo dove salvare il primo elemento
		lw $t1, ($s1)						#in $t1 primo elemento
		lw $t2, 116($t1)					#in $t2 secondo elemento
		beq $t2, $zero, riordinaPortfolioEnd	#se esiste un solo elemento nella lista, allora è già ordinata
		#ciclo while "scambio effettuato" = true
		riordinaPortfolioLoopSort1:
			li $s2, 0						#in $s2 scambio effettuato = false
			lw $t1, ($s1)					#in $t1 elemento1 passato in loop2
			lw $t2, 116($t1)				#in $t2 elemento2 passato in loop2
			lw $t3, 116($t2)				#in $t3 succ elemento2
			add $t4, $t1, $s0
			lw $t4, ($t4)			#in $t4 campo da confrontare di elemento1
			add $t5, $t2, $s0
			lw $t5, ($t5)			#in $t5 campo da confrontare di elemento2
			bge $t4, $t5, riordinaPortfolioLoopSort2	#if campo1 <= campo2 scambio gli elementi
				sw $t2, ($s1)		#scambio i link
				sw $t1, 116($t2)
				sw $t3, 116($t1)
				move $t6, $t1		#scambio $t1 e $t2 per lo shift successivo
				move $t1, $t2
				move $t2, $t6
				li $s2, 1
			#ciclo for per tutti gli elemento1 ed elemento2 a partire da elemento1=secondo elemento della lista
			riordinaPortfolioLoopSort2:
				beq $t3, $zero, riordinaPortfolioLoopSort2End	#fine loop2 se il prossimo el. a essere elemento2 non esiste
				move $t0, $t1				#in $t0 precedente di elemento1
				move $t1, $t2				#shift in elemento1 di elemento2
				move $t2, $t3				#shift in elemento2 del succ di elemento2
				lw $t3, 116($t2)			#in $t3 succ elemento2
				add $t4, $t1, $s0
				lw $t4, ($t4)			#in $t4 campo da confrontare di elemento1
				add $t5, $t2, $s0
				lw $t5, ($t5)			#in $t5 campo da confrontare di elemento2
				bge $t4, $t5, riordinaPortfolioLoopSort2	#if campo1 <= campo2 scambio gli elementi
					sw $t2, 116($t0)		#scambio i link
					sw $t1, 116($t2)
					sw $t3, 116($t1)
					move $t6, $t1			#scambio $t1 e $t2 per lo shift successivo
					move $t1, $t2
					move $t2, $t6
					li $s2, 1
					j riordinaPortfolioLoopSort2
			riordinaPortfolioLoopSort2End:
			bne $s2, $zero, riordinaPortfolioLoopSort1		#loop1 continua se scambio effettuato = true
		
		riordinaPortfolioEnd:
		lw $s0, ($sp)			#restore registers
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $ra, 16($sp)
		addi $sp, $sp, 20
		jr $ra
	.end riordinaPortfolio
	
.globl aggiornaPortfolioSelezionato		#chiama tutti i metodi del portfolio per aggiornare i suoi valori interni
	.ent aggiornaPortfolioSelezionato
		aggiornaPortfolioSelezionato:
		addi $sp, $sp, -4		#preserve registers
		sw $ra, ($sp)
		
		la $t1, portfolioSelezionato
		lw $t1, ($t1)		#in $t1 il portfolio selezionato
		la $t0, giorno
		lw $t0, ($t0)		#in $t0 giorno di oggi
		lw $t3, 92($t1)		#in $t3 ultimoGiornoAggiornato
		beq $t0, $t3, continuaAggiornaPortfolioSelezionato		#se non è stato aggiornato oggi, allora in ogni caso portfolioModificato=1
			li $t4, 1
			sw $t4, 72($t1)
		continuaAggiornaPortfolioSelezionato:
		la $t0, metodiPortfolio
		lw $t0, 8($t0)
		jalr $t0				#funzione calcValorePortfolio, aggiorno i valori tot delle azioni portfolio
		la $t0, metodiPortfolio
		lw $t0, 12($t0)
		jalr $t0				#funzione calcBilancioTotaleEProfitto, aggiorno il bilancio tot e il profitto
		
		lw $ra, ($sp)			#restore registers
		addi $sp, $sp, 4
		jr $ra
	.end aggiornaPortfolioSelezionato
	
.globl calcoloPercentuale	#riceve in $a0 il valore di oggi, in $a1 il valore di ieri (rappr. interna in cent) e restituisce in $v0 la percentuale (rappr. interna in %oo)
	.ent calcoloPercentuale
		calcoloPercentuale:
		sub $v0, $a0, $a1		#calcolo percentuale (((oggi - ieri) * 10000)/ieri) su $v0
		li $t9, 10000
		mult $v0, $t9
		mflo $v0
		div $v0, $a1
		mflo $v0
		
		jr $ra
	.end calcoloPercentuale

.globl printValue		#Stampa a schermo un valore in dollari formattato "xxx,xx$" o una percentuale "+/-xxx,xx%", prendendo in $a0 la rappresentazione interna senza virgola, e in %a1 0 se dollari, 1 se percentuale
	.ent printValue
		printValue:
		move $t9, $a0	#preserve $a0 argomento su $t9
		blt $a0, $zero, printValueMinusSign		#se è una perc ed è positiva allora prima di tutto stampo +
			beq $a1, $zero, printValueStart			#già superato check positività, se è perc non faccio nulla e continuo
			li $v0, 4
			la $a0, piu		#stampo "+"
			syscall
			j printValueStart
		printValueMinusSign:				#se è neg stampo subito - e trasformo in pos
			li $v0, 4
			la $a0, meno	#stampo "-"
			syscall
			li $t8, -1		#rendo il valore positivo
			mult $t9, $t8
			mflo $t9
		
		printValueStart:
		li $t8, 100
		div $t9, $t8
		mflo $a0		#previrgola
		mfhi $t9		#postvirgola
		
		li $v0, 1
		syscall			#stampo il previrgola
		li $v0, 4
		la $a0, virgola #stampo ","
		syscall
		li $v0, 1		#stampo il postvirgola
		li $t8, 9
		bgt $t9, $t8, printValueCent		#se postvirgola<10 stampo uno 0 davanti per la formattazione
			li $a0, 0
			syscall
		printValueCent:
		move $a0, $t9
		syscall
		
		li $v0, 4
		bne $a1, $zero printValuePerc	#se $a0!=0, allora è una perc, altrimenti è un dollaro
			la $a0, dollari		#stampo "$"
			syscall
			j printValueEnd
		printValuePerc:
			la $a0, perc		#stampo "%"
			syscall
		
		printValueEnd:
		jr $ra
	.end printValue
	
	
#OGGETTI
.data
#jump table dei metodi di Portfolio, in comune agli oggetti invece che essere ripetuta in cima ad ogni oggetto
metodiPortfolio:
	.word compraVendi					#pos 0
	.word portfolio						#pos 4
	.word calcValorePortfolio			#pos 8
	.word calcBilancioTotaleEProfitto	#pos 12
	.word storicoTransazioni			#pos 16

	
#OGGETTI Portfolio
portfolio1:
	#contanti				pos 0
	.word 1000000						#inizio con 10000,00$ in contanti, rappresentazione interna in cent
	#qtaAzioni				pos 4
	.word 0, 0, 0, 0, 0, 0, 0, 0		#quantità azioni Google, Amazon, Apple, Tesla, Intel, M$, Fb, Twitter in portfolio
	#valoreAzioni			pos 36
	.word 0, 0, 0, 0, 0, 0, 0, 0		#spazio di memoria dove è salvato il valore azioni in portfolio calcolato per azienda
	#valorePortfolio		pos 68
	.word 0								#valore totale del portfolio azioni
	#portfolioModificato	pos 72
	.word 0								#1 se è stata precedentemente effettuata un'operazione e i valori del portfolio sono da aggiornare
	#bilancioTotale			pos 76
	.word 1000000						#bilancio totale di oggi, che non cambia durante il giorno (può essere quindi anche calcolato solo all'inizio del giorno)
	.word 0								#bilancio totale di ieri (alla fine del giorno il bilancio totale è salvato, per poter calcolare la percentuale di profitti/perdite totali giornaliera)
	#profittoGiornaliero	pos 84
	.word 0								#percentuale di profitto totale rispetto a ieri (rappresentazione interna in %oo)
	#indirizzoUltimaOperazione	pos 88
	.word 0								#contiene l'indirizzo dell'ultimo nodo della lista di operazioni, dal quale è possibile risalire all'intera lista
	#ultimoGiornoAggiornato	pos 92
	.word 0								#l'ultimo giorno in cui il portfolio è stato utilizzato dall'utente (serve per aggiornare i valori o meno quando si cambia selezione)
	#nomePortfolio			pos 96
	.space 20							#20 byte di spazio per il nome del portfolio (funzionalità aggiunta per gestire portfolii multipli)
	#portfolioSuccessivo	pos 116
	.word 0								#i portfolii sono in una lista concatenata, quelli successivi al primo creato sono allocati dinamicamente


.text
#METODI portfolio
.globl compraVendi		#riceve argomento $a0=0 COMPRA, $a0=1 VENDI
	.ent compraVendi	#richiede all'utente di scegliere un'azienda e inserire la quantità di azioni da comprare/vendere, per poi effettuare l'operazione se i soldi sono sufficienti e salvare i dettagli nello storico
		compraVendi:
		addi $sp, $sp, -28			#preserve registers
		sw $s0, ($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $s3, 12($sp)
		sw $s4, 16($sp)
		sw $s5, 20($sp)
		sw $ra, 24($sp)
		
		move $s0, $a0 	#salvo su $s0 l'argomento COMPRA/VENDI
		
		#selezione azienda
		compraVendiSelezioneAzienda:
		li $v0, 4
		la $a0, selezioneCompraVendiPrompt1	#stampo "Seleziona il titolo da"
		syscall
		bne $s0, $zero, vendiSelezioneAzienda
			la $a0, selezioneCompraPrompt		#stampo " comprare"
			syscall
			j continuaSelezioneAzienda
		vendiSelezioneAzienda:
			la $a0, selezioneVendiPrompt		#stampo " vendere"
			syscall
		continuaSelezioneAzienda:
		la $a0, selezioneCompraVendiPrompt2 #stampo ": 1 Google  2 Amazon  3 Apple  4 Tesla  5 Intel  6 Microsoft  7 Facebook  8 Twitter\n"
		syscall
		li $v0, 5		#read int
		syscall
		move $s1, $v0
		addi $s1, $s1, -1	#salvo su $s1 l'id dell'azienda (contate a partire da 0)
		
		blt $s1, $zero, compraVendiSelezioneErrore	#check numero corretto
		li $t0, 7
		bgt $s1, $t0, compraVendiSelezioneErrore
		
		sll $s5, $s1, 2		#shift left 2x dell'id azienda su $s5 per ottenere i byte da sommare agli indirizzi array
		
		#selezione quantità
		li $v0, 4
		la $a0, inserireQuantita	#stampo "Inserire la quantità: "
		syscall
		li $v0, 5		#read int
		syscall
		move $s2, $v0	#salvo su $s2 la qta
		
		ble $s2, $zero, compraVendiSelezioneErrore	#check se 0 o negativo
		
		#controllo quantità se vendo
		beq $s0, $zero, compraVendiCalcoloPrezzo	#se è COMPRA salto il controllo
		la $t0, portfolioSelezionato
		lw $t0, ($t0)
		addi $t0, $t0, 4	#indirizzo qta azioni in portfolio
		add $t0, $t0, $s5	#indirizzo qta azione
		lw $t1, ($t0)		#load qta portfolio in $t1
		ble $s2, $t1, compraVendiCalcoloPrezzo	#supero il controllo se qta venduta <= qta in portfolio
			li $v0, 4
			la $a0, failVendi	#stampo "Non possiedi questa quantità di azioni!\n"
			syscall
			j compraVendiEnd
		
		#calcolo prezzo
		compraVendiCalcoloPrezzo:
		la $t0, prezzi		#indirizzo prezzi
		add $t0, $t0, $s5	#indirizzo prezzo azione
		lw $s3, ($t0)		#load prezzo azione in $s3
		mult $s2, $s3
		mflo $s4			#prezzo totale in $s4
		
		la $t0, portfolioSelezionato
		lw $t0, ($t0)		#carico l'indirizzo contanti
		lw $t1, ($t0)		#contanti in $t1
		
		#controllo prezzo se compro
		bne $s0, $zero, compraVendiEsecuzione	#se è VENDI salto il controllo
		ble $s4, $t1, compraVendiEsecuzione		#supero il controllo se prezzo totale <= contanti
			li $v0, 4
			la $a0, failCompra	#stampo "Non disponi di sufficiente denaro!\n"
			syscall
			j compraVendiEnd
		
		#eseguo operazione
		compraVendiEsecuzione:
		#COMPRA
		bne $s0, $zero, vendiEsecuzione		#se è vendi passa a VENDI
			sub $t1, $t1, $s4		#tolgo ai contanti il prezzo totale
			sw $t1, ($t0)			#store contanti
			la $t0, portfolioSelezionato
			lw $t0, ($t0)
			addi $t0, $t0, 4		#indirizzo qta azioni in portfolio
			add $t0, $t0, $s5		#indirizzo qta azione in $t0
			lw $t1, ($t0)			#load qta azione in $t1
			add $t1, $t1, $s2		#aggiungo a qta la qta comprata
			sw $t1, ($t0)			#store qta azione
			j compraVendiAggiornoPortfolioMod
		#VENDI
		vendiEsecuzione:
			add $t1, $t1, $s4		#aggiungo ai contanti il prezzo totale
			sw $t1, ($t0)			#store contanti
			la $t0, portfolioSelezionato
			lw $t0, ($t0)
			addi $t0, $t0, 4		#indirizzo qta azioni in portfolio
			add $t0, $t0, $s5		#indirizzo qta azione in $t0
			lw $t1, ($t0)			#load qta azione in $t1
			sub $t1, $t1, $s2		#sottraggo alla qta la qta venduta
			sw $t1, ($t0)			#store qta azione
		
		#aggiorno portfolioModificato = 1
		compraVendiAggiornoPortfolioMod:
		la $t0, portfolioSelezionato
		lw $t0, ($t0)
		li $t1, 1
		sw $t1, 72($t0)		#store 1 in portfolioModificato
		
		#stampo conferma
		li $v0, 4
		la $a0, aCapo
		syscall
		li $v0, 1
		move $a0, $s2	#stampo la qta
		syscall
		li $v0, 4
		la $a0, successoCompraVendiPrompt1		#stampo " azioni "
		syscall
		la $t0, nomiAziende
		add $t0, $t0, $s5		#indirizzo nome azienda su $t0
		lw $a0, ($t0)			#stampo nome azienda
		syscall
		bne $s0, $zero, vendiStampoSuccesso
			la $a0, successoCompraPrompt		#stampo " comprate "
			syscall
			j continuaStampoSuccesso
		vendiStampoSuccesso:
			la $a0, successoVendiPrompt			#stampo " vendute "
			syscall
		continuaStampoSuccesso:
		la $a0, successoCompraVendiPrompt2		#stampo " con successo per un totale di "
		syscall
		move $a0, $s4		#stampo il totale dei dollari
		li $a1, 0
		jal printValue
		li $v0, 4
		la $a0, aCapo
		syscall
		syscall
			
		#salva nello storico
		li $v0, 9		#alloco
		li $a0, 28		#28 byte
		syscall		#in $v0 indirizzo del record della nuova entry
		la $t0, giorno
		lw $t1, ($t0)
		sw $t1, ($v0)		#giorno					pos 0
		sw $s0, 4($v0)		#C/V 					pos 4
		sw $s1, 8($v0)		#id azienda 			pos 8
		sw $s2, 12($v0)		#qta azioni 			pos 12
		sw $s3, 16($v0)		#prezzo singola azione 	pos 16
		sw $s4, 20($v0)		#prezzo totale 			pos 20
		
		la $t0, portfolioSelezionato
		lw $t0, ($t0)
		lw $t1, 88($t0)		#indirizzo dell'ultimo nodo dello storico operazioni in $t1
		sw $t1, 24($v0)		#indirizzo nodo preced 	pos 24
		
		sw $v0, 88($t0)		#salvo in indirizzoUltimaOperazione l'indirizzo di questo nodo
		
		#fine procedura
		j compraVendiEnd

		compraVendiSelezioneErrore:
		li $v0, 4
		la $a0, selezioneErrore	#stampo "Numero non riconosciuto"
		syscall
		j compraVendiSelezioneAzienda	#ritorno al prompt selezione azienda
		
		compraVendiEnd:
		lw $s0, ($sp)			#restore registers
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $ra, 24($sp)
		addi $sp, $sp, 28
		jr $ra
	.end compraVendi

.globl portfolio				#visualizza le azioni in portfolio
	.ent portfolio
		portfolio:
		addi $sp, $sp, -4		#preserve registers
		sw $ra, ($sp)
		
		la $t0, metodiPortfolio
		lw $t0, 8($t0)
		jalr $t0			#funzione calcValorePortfolio, aggiorno i val portfolio
		
		li $v0, 4
		la $a0, portfolioTitolo		#stampo "Portfolio\nNome | q.ta | Valore totale\n"
		syscall
		
		li $t0, 8				#index i=8
		la $t1, nomiAziende		#array nomi
		la $t4, portfolioSelezionato
		lw $t4, ($t4)			#indirizzo oggetto portfolio in $t4
		addi $t2, $t4, 4		#indirizzo qta azioni in portfolio
		addi $t3, $t4, 36		#array valore totale azioni azienda
		portfolioPrintLoop:
			li $v0, 4
			lw $a0, ($t1)			#stampo nome azienda
			syscall
			la $a0, separatoreTabella	#"	| "
			syscall
			li $v0, 1
			lw $a0, ($t2)			#print int qta azioni
			syscall
			li $v0, 4
			la $a0, separatoreTabella	#"	| "
			syscall
			lw $a0, ($t3)			#stampo $ val tot
			li $a1, 0
			jal printValue
			li $v0, 4
			la $a0, aCapo			#"\n"
			syscall
			
			addi $t0, $t0, -1		#i--
			addi $t1, $t1, 4		#array index++
			addi $t2, $t2, 4
			addi $t3, $t3, 4
			bgt $t0, $zero, portfolioPrintLoop	#loop per i>0
			
		li $v0, 4
		la $a0, aCapo
		syscall
		
		lw $ra, ($sp)			#restore registers
		addi $sp, $sp, 4
		jr $ra
	.end portfolio

.globl calcValorePortfolio	#Calcola il valore totale del portfolio aggiornando i valori in memoria
	.ent calcValorePortfolio
		calcValorePortfolio:
		la $t8, portfolioSelezionato		#oggetto portfolio in $t8
		lw $t8, ($t8)
		lw $t1, 72($t8)				#controllo che i valori non siano già aggiornati, se lo sono non faccio niente
		beq $t1, $zero, noAggiornaPortfolio
		
		li $t0, 0				#index
		li $t6, 8				#sup index
		addi $t1, $t8, 4		#memory address qta da leggere
		la $t2, prezzi			#memory address prezzi da leggere
		addi $t3, $t8, 36		#memory address valori da aggiornare
		li $t7, 0				#tot
		
		calcValorePortfolioLoop:
			lw $t4, ($t1)		#load qta
			lw $t5, ($t2)		#load prezzo
			mult $t4, $t5	#salvo valore totale azioni del tipo x in $t4
			mflo $t4
			sw $t4, ($t3)		#store valore
			add $t7, $t7, $t4	#aggiungo il valore al tot
			addi $t0, $t0, 1		#index++
			addi $t1, $t1, 4		#index array++
			addi $t2, $t2, 4
			addi $t3, $t3, 4
			blt $t0, $t6, calcValorePortfolioLoop	#loop per i<8
		
		sw $t7, 68($t8)			#salvo il tot valore portfolio
		
		li $t1, 0			#portfolioModificato = 0
		sw $t1, 72($t8)
		
		noAggiornaPortfolio:
		jr $ra
	.end calcValorePortfolio

.globl calcBilancioTotaleEProfitto			#calcolo il bilancio totale e il profitto rispetto a ieri (se ultimoGiornoAggiornato!=giorno si deve ricalcolare il bilancio di ieri)
	.ent calcBilancioTotaleEProfitto
		calcBilancioTotaleEProfitto:
		addi $sp, $sp, -4		#preserve registers
		sw $ra, ($sp)
		
		la $t0, portfolioSelezionato
		lw $t0, ($t0)				#oggetto portfolio su $t0
		
		lw $t1, 68($t0)		#tot valore portfolio su $t1
		lw $t2, ($t0)		#contanti su $t2
		add $a0, $t1, $t2	#bilancio totale su $a0
		sw $a0, 76($t0)		#store bilancio totale
		
		lw $t1, 92($t0)		#ultimoGiornoAggiornato su $t1
		la $t2, giorno
		lw $t2, ($t2)		#giorno di oggi su $t2
		bne $t1, $t2, riCalcBilancioIeri	#se il portfolio non è stato aggiornato al passaggio del giorno, ricalcolo il bilancio di ieri
			lw $a1, 80($t0)		#load bilancio totale di ieri su $a1
			j continuaCalcBilancio
		
		riCalcBilancioIeri:
		li $t8, 0				#index
		li $t6, 8				#sup index
		addi $t1, $t0, 4		#memory address qta da leggere
		la $t2, prezzi			#memory address prezzi da leggere
		addi $t2, $t2, 32		#prezzi + 32 = prezzi di ieri
		li $t7, 0				#tot
		
		calcValorePortfolioIeriLoop:
			lw $t4, ($t1)		#load qta
			lw $t5, ($t2)		#load prezzo
			mult $t4, $t5	#salvo valore totale azioni del tipo x in $t4
			mflo $t4
			add $t7, $t7, $t4	#aggiungo il valore al tot
			addi $t8, $t8, 1		#index++
			addi $t1, $t1, 4		#index array++
			addi $t2, $t2, 4
			addi $t3, $t3, 4
			blt $t8, $t6, calcValorePortfolioIeriLoop	#loop per i<8
		
							#tot valore portfolio ieri su $t7
		lw $t2, ($t0)		#contanti su $t2
		add $a1, $t7, $t2	#bilancio totale di ieri su $a1
		sw $a1, 80($t0)		#store bilancio totale di ieri
		la $t2, giorno
		lw $t2, ($t2)		#giorno di oggi su $t2
		sw $t2, 92($t0)		#ultimoGiornoAggiornato = oggi
		
		continuaCalcBilancio:
		jal calcoloPercentuale		#calcolo percentuale in $v0
		la $t0, portfolioSelezionato
		lw $t0, ($t0)
		sw $v0, 84($t0)		#store profitto giornaliero
		
		
		lw $ra, ($sp)			#restore registers
		addi $sp, $sp, 4
		jr $ra
	.end calcBilancioTotaleEProfitto
	
.globl storicoTransazioni
	.ent storicoTransazioni
		storicoTransazioni:
		addi $sp, $sp, -4		#preserve registers
		sw $ra, ($sp)
		
		la $t0, portfolioSelezionato
		lw $t0, ($t0)
		lw $t1, 88($t0)			#link al primo nodo della lista storico in $t1
		la $t2, nomiAziende		#array nomi aziende in $t2
		bne $t1, $zero, storicoTransazioniContinua	#se l'indirizzo è vuoto non c'è stata nessuna transazione
			li $v0, 4
			la $a0, storicoTransazioniVuoto	#stampo "Non è stata effettuata alcuna transazione!"
			syscall
			j storicoTransazioniEnd
		
		storicoTransazioniContinua:
		li $v0, 4
		la $a0, storicoTransazioniTitolo	#stampo "Storico Transazioni\nGiorno	| Compra/vendi	| Nome	| q.ta	| Prezzo	| Prezzo totale\n"
		syscall
		
		storicoTransazioniPrintLoop:
			li $v0, 1
			lw $a0, ($t1)	#print giorno
			syscall
			li $v0, 4
			la $a0, separatoreTabella	#"	| "
			syscall
			lw $t3, 4($t1)	#compra=0, vendi=1 in $t3
			bne $t3, $zero, storicoTransazioniPrintLoopVendi	#se compra stampo "Compra", se vendi stampo "Vendi"
				la $a0, tabellaTransazioniC
				syscall
				j storicoTransazioniPrintLoopContinua
			storicoTransazioniPrintLoopVendi:
				la $a0, tabellaTransazioniV
				syscall
			storicoTransazioniPrintLoopContinua:
			la $a0, tab
			syscall
			la $a0, separatoreTabella
			syscall
			lw $t3, 8($t1)		#id nome azienda in $t3
			sll $t3, $t3, 2		#index array nome azienda
			add $t3, $t2, $t3	#array nomi aziende + index
			lw $a0, ($t3)		#stampo nome azienda
			syscall
			la $a0, separatoreTabella
			syscall
			li $v0, 1
			lw $a0, 12($t1)		#stampo qta
			syscall
			li $v0, 4
			la $a0, separatoreTabella
			syscall
			lw $a0, 16($t1)		#stampo $ prezzo
			li $a1, 0
			jal printValue
			li $v0, 4
			la $a0, separatoreTabella
			syscall
			lw $a0, 20($t1)		#stampo $ prezzo tot
			li $a1, 0
			jal printValue
			li $v0, 4
			la $a0, aCapo
			syscall
			
			lw $t3, 24($t1)		#prossimo indirizzo
			beq $t3, $zero, storicoTransazioniEnd	#se l'indirizzo è vuoto (ultimo nodo) finisco il ciclo
			move $t1, $t3		#nuovo nodo lista
			j storicoTransazioniPrintLoop
		
		storicoTransazioniEnd:
		li $v0, 4
		la $a0, aCapo
		syscall
		
		lw $ra, ($sp)			#restore registers
		addi $sp, $sp, 4
		jr $ra
	.end storicoTransazioni