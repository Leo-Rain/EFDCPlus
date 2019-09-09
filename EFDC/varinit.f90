SUBROUTINE VARINIT

  !----------------------------------------------------------------------!  
  ! CHANGE RECORD  
  ! DATE MODIFIED     BY               DESCRIPTION
  !----------------------------------------------------------------------!
  !    2015-06       PAUL M. CRAIG     IMPLEMENTED SIGMA-Z (SGZ) IN EE7.3 

  USE GLOBAL
  USE SCANINPMOD
  IMPLICIT NONE
  
  INTEGER :: NCSER1,NCSER2,NCSER3,NCSER4
  
  KPCM=1
  MDVSM=1
  MTVSM=1
  NDDAM=1
  NDQCLT=1
  NDQCLT2=1
  NDVEGSER=1
  NDWQCSR=1
  NDWQPSR=1
  NGLM=1
  NJPSM=1
  NJUNXM=1
  NJUNYM=1
  NLDAM=1
  NPDM=1
  NSMGM=1
  NSMTSM=1
  NSMZM=1
  NTSM=1
  NTSSMVM=1
  NVEGSERM=1
  NVEGTPM=100
  NWGGM=1
  NWQCSRM=1
  NWQPSM=1
  NWQPSRM=1
  !      NWQTDM=1   NOT USED
  NWQZM=1
  NXYSDATM=1
  NWNDMAP = 1
  NATMMAP = 1
  NICEMAP = 1
  
  ! *** SCAN MAIN CONTROL FILE
  CALL SCANEFDC(NCSER1,NCSER2,NCSER3,NCSER4)
  
  IF( LSEDZLJ ) CALL SCANSEDZLJ

  IF( ISCHAN > 0  ) CALL SCANMODC
  IF( ISGWIT == 2 ) CALL SCANGWSR
  IF( NASER  > 0  ) CALL SCANASER
  IF( NCSER1 > 0  ) CALL SCANSSER(NCSER1)  
  IF( NCSER2 > 0  .OR. ( ISTRAN(5) > 0 .AND. ITOXTEMP > 1 ) ) CALL SCANTSER(NCSER2)
  IF( NCSER3 > 0  ) CALL SCANDSER(NCSER3)
  IF( NCSER4 > 0  ) CALL SCANSFSR(NCSER4)
  IF( NQSER  > 0  ) CALL SCANQSER
  IF( NPSER  > 0  ) CALL SCANPSER
  IF( NWSER  > 0  ) CALL SCANWSER
  IF( NQCTLT >= 1 ) CALL SCANQCTL
  IF( NQWRSR > 0  ) CALL SCANQWSER
  
  ALLOCATE(MSVSED(NSCM))
  ALLOCATE(MSVSND(NSNM))
  ALLOCATE(MSVTOX(NTXM))
  IF( NTOX > 0 .OR. NSED > 0 .OR. NSND > 0 )CALL SCNTXSED
  
  IF( ISTRAN(8) > 0 )CALL SCANWQ
  
  KSM=KCM
  IGM=ICM+1
  JGM=JCM+1
  MGM=2*MTM
  NSTM=MAX(3,NSCM+NSNM+NTXM)             ! *** MAXIMUM NUMBER OF SEDTOX VARIABLES
  NSTVM=MAX(7,4+NSCM+NSNM+NTXM+NWQV)     ! *** MAXIMUM NUMBER OF CONSTITUENTS

  IF( ISTRAN(8) > 0 )THEN
    LCMWQ=LCM
  ELSE
    LCMWQ=1
  ENDIF
  NQINFLM=MAX(1,NQSIJ+NQCTL+NQWR+2*MDCHH)
  
  ! *** CALCULATE SHELL FISH LARVAE AND/OR WATER QUALITY CONSTITUENTS
  ISWQFLUX=0  
  IF( ISTRAN(4) >= 1 )ISWQFLUX=1  
  IF( ISTRAN(8) >= 1 )ISWQFLUX=1  
  IF( ISWASP >= 1 )ISWQFLUX=1
  IF( ISICM >= 1  )ISWQFLUX=1
  IF( ISSSMMT /= 2 )ISWQFLUX=1
  IF (ISLSHA == 1) ISWQFLUX=1

  ! *** ALLOCATE THE ARRAYS
  CALL VARALLOC

  ! ** ZERO ARRAYS
  CALL VARZEROReal
  CALL VARZEROInt
  IF( LSEDZLJ )CALL VARZEROSNL

  LWVMASK=.FALSE.

  IF( ISICE > 0 )THEN
    MITLAST    = 0
    FRAZILICE  = 0.0 
    FRAZILICE1 = 0.0 
    ICECOVER   = 0.0
    ICERATE    = 0.0
    ICETHICK   = 0.0 
    ICETHICK1  = 0.0 
    ICEVOL     = 0.0
    ICETEMP    = 0.
    TCISER     = 0.
    TAISER     = 0.
    RICECOVT   = 0.
    RICETHKT   = 0.
    IF( NISER > 1) RICEWHT = 1.0    
  ENDIF
  ICECELL  = .FALSE.
  RHOW = 1000.
  SHLIM = 44.         ! *** MAXIMUM ANGULAR WAVE NUMBER*DEPTH
  
END
