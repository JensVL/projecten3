# Lima2

## Omschrijving

Een interne file-server. Zorg voor schijven voor de verschillende afdelingen, zoals aangegeven in tabel2.1. 
Pas toegangsrechten toe zoals aangeven in tabel2.2.

OPGELET!De directories HomeDirs en ProfileDirs zijn toegankelijk voor iedereen.
In de HomeDirs folder zitten alle home directories van alle domeingebruikers. 
Uiteraard kan elke gebruiker enkel in zijn eigen home directory lezen en schrijven.
Alle andere gebruikers krijgen geen toegang. 
Er wordt net hetzelfde gedaan metde profile directories in de ProfileDirs folder.

Stel volgende quota in:
- VerkoopData, DirData en AdminData maximum 100MB per gebruiker!
- OntwikkelingData en ITData maximum 200Mb per gebruiker!
- Stel in dat er voor AdminData dagelijks een schaduwkopie wordt gemaaktvan de data.

Maak een map ShareVerkoop aan die gedeeld wordt met Verkoop en Ontwikkeling
met toegangsrechten zoals in Tabel2.2 aangegeven.

| Disk | Volume | Type    |  File System  | Volume label	    | Share | 
|------|--------|---------|---------------|-------------------|-------|
| 1		 | C:     |	Primair |	NTFS	        |  System           |       |
|		   | D:	    | Primair  | NTFS	        | VerkoopData		    |	X     |
|		   | E:	    | Primair  | NTFS	        | OntwikkelingData  | X     |
| 2		 | F:	    | Primair  |	NTFS	      |	ITData			      | X     |
|		   | G:	    | Primair  |	NTFS	      |	DirData		        |	X     |
|		   | H:	    | Primair  |	NTFS	      |	AdminData	        |	X     |
| 2		 | Y:	    | Primair  |	NTFS	      |	HomeDirs	        |	X     |
|		   | Z:	    | Primair  |	NTFS	      |	ProfileDirs	      |	X     |
		
Tabel 2.1:Overzicht volumes op de file-serverlima2


| Volume				    | Read					        | Write			        |	Full control      |
|-------------------|-----------------------|-------------------|-------------------|
| VerkoopData			  | Verkoop					      | Verkoop		        | IT Administratie  |
| OntwikkelingData  | Ontwikkeling			    | Ontwikkeling      | IT Administratie  |
| ITData				    | IT Administratie	    | IT Administratie  | IT Administratie  |
| DirDATA				    | Directie				      | Directie			    | IT Administratie  |
| AdminData			    | Administratie			    | Administratie     | IT Administratie  |
| HomeDirs			    | Alle Afdelingen		    |	Alle Afdelingen   | IT Administratie  |
| ProfileDirs			  | Alle Afdelingen		    |	Alle Afdelingen   |	IT Administratie  |
| ShareVerkoop		  | Verkoop, Ontwikkeling | Verkoop			      |	IT Administratie  |

Tabel 2.2:Overzicht toegangsrechten per volume op de file-serverlima2
