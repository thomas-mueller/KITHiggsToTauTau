      SUBROUTINE SMATRIXHEL(P,HEL,ANS)
      IMPLICIT NONE
C     
C     CONSTANT
C     
      INTEGER    NEXTERNAL
      PARAMETER (NEXTERNAL=5)
      INTEGER                 NCOMB
      PARAMETER (             NCOMB=16)
CF2PY INTENT(OUT) :: ANS
CF2PY INTENT(IN) :: HEL
CF2PY INTENT(IN) :: P(0:3,NEXTERNAL)

C     
C     ARGUMENTS 
C     
      REAL*8 P(0:3,NEXTERNAL),ANS
      INTEGER HEL
C     
C     GLOBAL VARIABLES
C     
      INTEGER USERHEL
      COMMON/HELUSERCHOICE/USERHEL
C     ----------
C     BEGIN CODE
C     ----------
      USERHEL=HEL
      CALL SMATRIX(P,ANS)
      USERHEL=-1

      END

      SUBROUTINE SMATRIX(P,ANS)
C     
C     Generated by MadGraph5_aMC@NLO v. 2.5.2, 2016-12-10
C     By the MadGraph5_aMC@NLO Development Team
C     Visit launchpad.net/madgraph5 and amcatnlo.web.cern.ch
C     
C     MadGraph5_aMC@NLO StandAlone Version
C     
C     Returns amplitude squared summed/avg over colors
C     and helicities
C     for the point in phase space P(0:3,NEXTERNAL)
C     
C     Process: g g > x0 g g QNP<=2 WEIGHTED<=4 @1
C     
      IMPLICIT NONE
C     
C     CONSTANTS
C     
      INTEGER    NEXTERNAL
      PARAMETER (NEXTERNAL=5)
      INTEGER    NINITIAL
      PARAMETER (NINITIAL=2)
      INTEGER NPOLENTRIES
      PARAMETER (NPOLENTRIES=(NEXTERNAL+1)*6)
      INTEGER                 NCOMB
      PARAMETER (             NCOMB=16)
      INTEGER HELAVGFACTOR
      PARAMETER (HELAVGFACTOR=4)
C     
C     ARGUMENTS 
C     
      REAL*8 P(0:3,NEXTERNAL),ANS
CF2PY INTENT(OUT) :: ANS
CF2PY INTENT(IN) :: P(0:3,NEXTERNAL)
C     
C     LOCAL VARIABLES 
C     
      INTEGER NHEL(NEXTERNAL,NCOMB),NTRY
      REAL*8 T
      REAL*8 MATRIX
      INTEGER IHEL,IDEN, I, J
C     For a 1>N process, them BEAMTWO_HELAVGFACTOR would be set to 1.
      INTEGER BEAMS_HELAVGFACTOR(2)
      DATA (BEAMS_HELAVGFACTOR(I),I=1,2)/2,2/
      INTEGER JC(NEXTERNAL)
      LOGICAL GOODHEL(NCOMB)
      DATA NTRY/0/
      DATA GOODHEL/NCOMB*.FALSE./

C     
C     GLOBAL VARIABLES
C     
      INTEGER USERHEL
      COMMON/HELUSERCHOICE/USERHEL
      DATA USERHEL/-1/

      DATA (NHEL(I,   1),I=1,5) /-1,-1, 0,-1,-1/
      DATA (NHEL(I,   2),I=1,5) /-1,-1, 0,-1, 1/
      DATA (NHEL(I,   3),I=1,5) /-1,-1, 0, 1,-1/
      DATA (NHEL(I,   4),I=1,5) /-1,-1, 0, 1, 1/
      DATA (NHEL(I,   5),I=1,5) /-1, 1, 0,-1,-1/
      DATA (NHEL(I,   6),I=1,5) /-1, 1, 0,-1, 1/
      DATA (NHEL(I,   7),I=1,5) /-1, 1, 0, 1,-1/
      DATA (NHEL(I,   8),I=1,5) /-1, 1, 0, 1, 1/
      DATA (NHEL(I,   9),I=1,5) / 1,-1, 0,-1,-1/
      DATA (NHEL(I,  10),I=1,5) / 1,-1, 0,-1, 1/
      DATA (NHEL(I,  11),I=1,5) / 1,-1, 0, 1,-1/
      DATA (NHEL(I,  12),I=1,5) / 1,-1, 0, 1, 1/
      DATA (NHEL(I,  13),I=1,5) / 1, 1, 0,-1,-1/
      DATA (NHEL(I,  14),I=1,5) / 1, 1, 0,-1, 1/
      DATA (NHEL(I,  15),I=1,5) / 1, 1, 0, 1,-1/
      DATA (NHEL(I,  16),I=1,5) / 1, 1, 0, 1, 1/
      DATA IDEN/512/

      INTEGER POLARIZATIONS(0:NEXTERNAL,0:5)
      DATA ((POLARIZATIONS(I,J),I=0,NEXTERNAL),J=0,5)/NPOLENTRIES*-1/
      COMMON/BORN_BEAM_POL/POLARIZATIONS
C     
C     FUNCTIONS
C     
      LOGICAL IS_BORN_HEL_SELECTED

C     ----------
C     BEGIN CODE
C     ----------
      IF(USERHEL.EQ.-1) NTRY=NTRY+1
      DO IHEL=1,NEXTERNAL
        JC(IHEL) = +1
      ENDDO
C     When spin-2 particles are involved, the Helicity filtering is
C      dangerous for the 2->1 topology.
C     This is because depending on the MC setup the initial PS points
C      have back-to-back initial states
C     for which some of the spin-2 helicity configurations are zero.
C      But they are no longer zero
C     if the point is boosted on the z-axis. Remember that HELAS
C      helicity amplitudes are no longer
C     lorentz invariant with expternal spin-2 particles (only the
C      helicity sum is).
C     For this reason, we simply remove the filterin when there is
C      only three external particles.
      IF (NEXTERNAL.LE.3) THEN
        DO IHEL=1,NCOMB
          GOODHEL(IHEL)=.TRUE.
        ENDDO
      ENDIF
      ANS = 0D0
      DO IHEL=1,NCOMB
        IF (USERHEL.EQ.-1.OR.USERHEL.EQ.IHEL) THEN
          IF (GOODHEL(IHEL) .OR. NTRY .LT. 20.OR.USERHEL.NE.-1) THEN
            IF(NTRY.GE.2.AND.POLARIZATIONS(0,0).NE.
     $       -1.AND.(.NOT.IS_BORN_HEL_SELECTED(IHEL))) THEN
              CYCLE
            ENDIF
            T=MATRIX(P ,NHEL(1,IHEL),JC(1))
            IF(POLARIZATIONS(0,0).EQ.-1.OR.IS_BORN_HEL_SELECTED(IHEL))
     $        THEN
              ANS=ANS+T
            ENDIF
            IF (T .NE. 0D0 .AND. .NOT.    GOODHEL(IHEL)) THEN
              GOODHEL(IHEL)=.TRUE.
            ENDIF
          ENDIF
        ENDIF
      ENDDO
      ANS=ANS/DBLE(IDEN)
      IF(USERHEL.NE.-1) THEN
        ANS=ANS*HELAVGFACTOR
      ELSE
        DO J=1,NINITIAL
          IF (POLARIZATIONS(J,0).NE.-1) THEN
            ANS=ANS*BEAMS_HELAVGFACTOR(J)
            ANS=ANS/POLARIZATIONS(J,0)
          ENDIF
        ENDDO
      ENDIF
      END


      REAL*8 FUNCTION MATRIX(P,NHEL,IC)
C     
C     Generated by MadGraph5_aMC@NLO v. 2.5.2, 2016-12-10
C     By the MadGraph5_aMC@NLO Development Team
C     Visit launchpad.net/madgraph5 and amcatnlo.web.cern.ch
C     
C     Returns amplitude squared summed/avg over colors
C     for the point with external lines W(0:6,NEXTERNAL)
C     
C     Process: g g > x0 g g QNP<=2 WEIGHTED<=4 @1
C     
      IMPLICIT NONE
C     
C     CONSTANTS
C     
      INTEGER    NGRAPHS
      PARAMETER (NGRAPHS=42)
      INTEGER    NEXTERNAL
      PARAMETER (NEXTERNAL=5)
      INTEGER    NWAVEFUNCS, NCOLOR
      PARAMETER (NWAVEFUNCS=13, NCOLOR=9)
      REAL*8     ZERO
      PARAMETER (ZERO=0D0)
      COMPLEX*16 IMAG1
      PARAMETER (IMAG1=(0D0,1D0))
C     
C     ARGUMENTS 
C     
      REAL*8 P(0:3,NEXTERNAL)
      INTEGER NHEL(NEXTERNAL), IC(NEXTERNAL)
C     
C     LOCAL VARIABLES 
C     
      INTEGER I,J
      COMPLEX*16 ZTEMP
      REAL*8 DENOM(NCOLOR), CF(NCOLOR,NCOLOR)
      COMPLEX*16 AMP(NGRAPHS), JAMP(NCOLOR)
      COMPLEX*16 W(20,NWAVEFUNCS)
      COMPLEX*16 DUM0,DUM1
      DATA DUM0, DUM1/(0D0, 0D0), (1D0, 0D0)/
C     
C     GLOBAL VARIABLES
C     
      INCLUDE 'coupl.inc'

C     
C     COLOR DATA
C     
      DATA DENOM(1)/6/
      DATA (CF(I,  1),I=  1,  6) /   24,    8,    8,    3,   -1,    8/
      DATA (CF(I,  1),I=  7,  9) /    3,   -1,    8/
C     1 Tr(1,2) Tr(4,5)
      DATA DENOM(2)/6/
      DATA (CF(I,  2),I=  1,  6) /    8,   19,   -2,   -1,   -2,   -2/
      DATA (CF(I,  2),I=  7,  9) /    8,   -2,    4/
C     1 Tr(1,2,4,5)
      DATA DENOM(3)/6/
      DATA (CF(I,  3),I=  1,  6) /    8,   -2,   19,    8,   -2,    4/
      DATA (CF(I,  3),I=  7,  9) /   -1,   -2,   -2/
C     1 Tr(1,2,5,4)
      DATA DENOM(4)/6/
      DATA (CF(I,  4),I=  1,  6) /    3,   -1,    8,   24,    8,    8/
      DATA (CF(I,  4),I=  7,  9) /    3,    8,   -1/
C     1 Tr(1,4) Tr(2,5)
      DATA DENOM(5)/6/
      DATA (CF(I,  5),I=  1,  6) /   -1,   -2,   -2,    8,   19,   -2/
      DATA (CF(I,  5),I=  7,  9) /    8,    4,   -2/
C     1 Tr(1,4,2,5)
      DATA DENOM(6)/6/
      DATA (CF(I,  6),I=  1,  6) /    8,   -2,    4,    8,   -2,   19/
      DATA (CF(I,  6),I=  7,  9) /   -1,   -2,   -2/
C     1 Tr(1,4,5,2)
      DATA DENOM(7)/6/
      DATA (CF(I,  7),I=  1,  6) /    3,    8,   -1,    3,    8,   -1/
      DATA (CF(I,  7),I=  7,  9) /   24,    8,    8/
C     1 Tr(1,5) Tr(2,4)
      DATA DENOM(8)/6/
      DATA (CF(I,  8),I=  1,  6) /   -1,   -2,   -2,    8,    4,   -2/
      DATA (CF(I,  8),I=  7,  9) /    8,   19,   -2/
C     1 Tr(1,5,2,4)
      DATA DENOM(9)/6/
      DATA (CF(I,  9),I=  1,  6) /    8,    4,   -2,   -1,   -2,   -2/
      DATA (CF(I,  9),I=  7,  9) /    8,   -2,   19/
C     1 Tr(1,5,4,2)
C     ----------
C     BEGIN CODE
C     ----------
      CALL VXXXXX(P(0,1),ZERO,NHEL(1),-1*IC(1),W(1,1))
      CALL VXXXXX(P(0,2),ZERO,NHEL(2),-1*IC(2),W(1,2))
      CALL SXXXXX(P(0,3),+1*IC(3),W(1,3))
      CALL VXXXXX(P(0,4),ZERO,NHEL(4),+1*IC(4),W(1,4))
      CALL VXXXXX(P(0,5),ZERO,NHEL(5),+1*IC(5),W(1,5))
C     Amplitude(s) for diagram number 1
      CALL VVVVS1_0(W(1,1),W(1,2),W(1,4),W(1,5),W(1,3),GC_12,AMP(1))
      CALL VVVVS2_0(W(1,1),W(1,2),W(1,4),W(1,5),W(1,3),GC_12,AMP(2))
      CALL VVVVS3_0(W(1,1),W(1,2),W(1,4),W(1,5),W(1,3),GC_12,AMP(3))
      CALL VVV8P0_1(W(1,1),W(1,2),GC_6,ZERO,ZERO,W(1,6))
      CALL VVS2_6P0_1(W(1,4),W(1,3),GC_64,GC_10,ZERO,ZERO,W(1,7))
C     Amplitude(s) for diagram number 2
      CALL VVV8_0(W(1,6),W(1,7),W(1,5),GC_6,AMP(4))
      CALL VVS2_6P0_1(W(1,5),W(1,3),GC_64,GC_10,ZERO,ZERO,W(1,8))
C     Amplitude(s) for diagram number 3
      CALL VVV8_0(W(1,6),W(1,8),W(1,4),GC_6,AMP(5))
      CALL VVV8P0_1(W(1,4),W(1,5),GC_6,ZERO,ZERO,W(1,9))
C     Amplitude(s) for diagram number 4
      CALL VVS2_6_0(W(1,6),W(1,9),W(1,3),GC_64,GC_10,AMP(6))
      CALL VVS2_6_3(W(1,1),W(1,2),GC_64,GC_10,MDL_MX0,MDL_WX0,W(1,10))
C     Amplitude(s) for diagram number 5
      CALL VVSS1_3_0(W(1,4),W(1,5),W(1,3),W(1,10),GC_62,GC_13,AMP(7))
C     Amplitude(s) for diagram number 6
      CALL VVVS1_2_0(W(1,4),W(1,5),W(1,6),W(1,3),GC_65,GC_11,AMP(8))
      CALL VVS2_6P0_1(W(1,1),W(1,3),GC_64,GC_10,ZERO,ZERO,W(1,6))
      CALL VVV8P0_1(W(1,2),W(1,4),GC_6,ZERO,ZERO,W(1,10))
C     Amplitude(s) for diagram number 7
      CALL VVV8_0(W(1,6),W(1,10),W(1,5),GC_6,AMP(9))
      CALL VVV8P0_1(W(1,2),W(1,5),GC_6,ZERO,ZERO,W(1,11))
C     Amplitude(s) for diagram number 8
      CALL VVV8_0(W(1,6),W(1,11),W(1,4),GC_6,AMP(10))
C     Amplitude(s) for diagram number 9
      CALL VVV8_0(W(1,6),W(1,2),W(1,9),GC_6,AMP(11))
C     Amplitude(s) for diagram number 10
      CALL VVVV1_0(W(1,2),W(1,4),W(1,5),W(1,6),GC_8,AMP(12))
      CALL VVVV3_0(W(1,2),W(1,4),W(1,5),W(1,6),GC_8,AMP(13))
      CALL VVVV4_0(W(1,2),W(1,4),W(1,5),W(1,6),GC_8,AMP(14))
      CALL VVV8P0_1(W(1,1),W(1,4),GC_6,ZERO,ZERO,W(1,6))
      CALL VVS2_6P0_1(W(1,2),W(1,3),GC_64,GC_10,ZERO,ZERO,W(1,12))
C     Amplitude(s) for diagram number 11
      CALL VVV8_0(W(1,6),W(1,12),W(1,5),GC_6,AMP(15))
C     Amplitude(s) for diagram number 12
      CALL VVS2_6_0(W(1,6),W(1,11),W(1,3),GC_64,GC_10,AMP(16))
C     Amplitude(s) for diagram number 13
      CALL VVV8_0(W(1,6),W(1,2),W(1,8),GC_6,AMP(17))
      CALL VVS2_6_3(W(1,1),W(1,4),GC_64,GC_10,MDL_MX0,MDL_WX0,W(1,13))
C     Amplitude(s) for diagram number 14
      CALL VVSS1_3_0(W(1,2),W(1,5),W(1,3),W(1,13),GC_62,GC_13,AMP(18))
C     Amplitude(s) for diagram number 15
      CALL VVVS1_2_0(W(1,2),W(1,5),W(1,6),W(1,3),GC_65,GC_11,AMP(19))
      CALL VVV8P0_1(W(1,1),W(1,5),GC_6,ZERO,ZERO,W(1,6))
C     Amplitude(s) for diagram number 16
      CALL VVV8_0(W(1,6),W(1,12),W(1,4),GC_6,AMP(20))
C     Amplitude(s) for diagram number 17
      CALL VVS2_6_0(W(1,6),W(1,10),W(1,3),GC_64,GC_10,AMP(21))
C     Amplitude(s) for diagram number 18
      CALL VVV8_0(W(1,6),W(1,2),W(1,7),GC_6,AMP(22))
      CALL VVS2_6_3(W(1,1),W(1,5),GC_64,GC_10,MDL_MX0,MDL_WX0,W(1,13))
C     Amplitude(s) for diagram number 19
      CALL VVSS1_3_0(W(1,2),W(1,4),W(1,3),W(1,13),GC_62,GC_13,AMP(23))
C     Amplitude(s) for diagram number 20
      CALL VVVS1_2_0(W(1,2),W(1,4),W(1,6),W(1,3),GC_65,GC_11,AMP(24))
C     Amplitude(s) for diagram number 21
      CALL VVV8_0(W(1,1),W(1,12),W(1,9),GC_6,AMP(25))
C     Amplitude(s) for diagram number 22
      CALL VVV8_0(W(1,1),W(1,10),W(1,8),GC_6,AMP(26))
C     Amplitude(s) for diagram number 23
      CALL VVV8_0(W(1,1),W(1,11),W(1,7),GC_6,AMP(27))
      CALL VVSS1_3_3(W(1,1),W(1,2),W(1,3),GC_62,GC_13,MDL_MX0,MDL_WX0
     $ ,W(1,11))
C     Amplitude(s) for diagram number 24
      CALL VVS2_6_0(W(1,4),W(1,5),W(1,11),GC_64,GC_10,AMP(28))
      CALL VVVS1_2P0_1(W(1,1),W(1,2),W(1,3),GC_65,GC_11,ZERO,ZERO,W(1
     $ ,11))
C     Amplitude(s) for diagram number 25
      CALL VVV8_0(W(1,4),W(1,5),W(1,11),GC_6,AMP(29))
      CALL VVVV1P0_1(W(1,1),W(1,2),W(1,4),GC_8,ZERO,ZERO,W(1,11))
      CALL VVVV3P0_1(W(1,1),W(1,2),W(1,4),GC_8,ZERO,ZERO,W(1,7))
      CALL VVVV4P0_1(W(1,1),W(1,2),W(1,4),GC_8,ZERO,ZERO,W(1,10))
C     Amplitude(s) for diagram number 26
      CALL VVS2_6_0(W(1,5),W(1,11),W(1,3),GC_64,GC_10,AMP(30))
      CALL VVS2_6_0(W(1,5),W(1,7),W(1,3),GC_64,GC_10,AMP(31))
      CALL VVS2_6_0(W(1,5),W(1,10),W(1,3),GC_64,GC_10,AMP(32))
      CALL VVVV1P0_1(W(1,1),W(1,2),W(1,5),GC_8,ZERO,ZERO,W(1,10))
      CALL VVVV3P0_1(W(1,1),W(1,2),W(1,5),GC_8,ZERO,ZERO,W(1,7))
      CALL VVVV4P0_1(W(1,1),W(1,2),W(1,5),GC_8,ZERO,ZERO,W(1,11))
C     Amplitude(s) for diagram number 27
      CALL VVS2_6_0(W(1,4),W(1,10),W(1,3),GC_64,GC_10,AMP(33))
      CALL VVS2_6_0(W(1,4),W(1,7),W(1,3),GC_64,GC_10,AMP(34))
      CALL VVS2_6_0(W(1,4),W(1,11),W(1,3),GC_64,GC_10,AMP(35))
      CALL VVSS1_3_3(W(1,1),W(1,4),W(1,3),GC_62,GC_13,MDL_MX0,MDL_WX0
     $ ,W(1,11))
C     Amplitude(s) for diagram number 28
      CALL VVS2_6_0(W(1,2),W(1,5),W(1,11),GC_64,GC_10,AMP(36))
      CALL VVVS1_2P0_1(W(1,1),W(1,4),W(1,3),GC_65,GC_11,ZERO,ZERO,W(1
     $ ,11))
C     Amplitude(s) for diagram number 29
      CALL VVV8_0(W(1,2),W(1,5),W(1,11),GC_6,AMP(37))
      CALL VVSS1_3_3(W(1,1),W(1,5),W(1,3),GC_62,GC_13,MDL_MX0,MDL_WX0
     $ ,W(1,11))
C     Amplitude(s) for diagram number 30
      CALL VVS2_6_0(W(1,2),W(1,4),W(1,11),GC_64,GC_10,AMP(38))
      CALL VVVS1_2P0_1(W(1,1),W(1,5),W(1,3),GC_65,GC_11,ZERO,ZERO,W(1
     $ ,11))
C     Amplitude(s) for diagram number 31
      CALL VVV8_0(W(1,2),W(1,4),W(1,11),GC_6,AMP(39))
      CALL VVVV1P0_1(W(1,1),W(1,4),W(1,5),GC_8,ZERO,ZERO,W(1,11))
      CALL VVVV3P0_1(W(1,1),W(1,4),W(1,5),GC_8,ZERO,ZERO,W(1,7))
      CALL VVVV4P0_1(W(1,1),W(1,4),W(1,5),GC_8,ZERO,ZERO,W(1,10))
C     Amplitude(s) for diagram number 32
      CALL VVS2_6_0(W(1,2),W(1,11),W(1,3),GC_64,GC_10,AMP(40))
      CALL VVS2_6_0(W(1,2),W(1,7),W(1,3),GC_64,GC_10,AMP(41))
      CALL VVS2_6_0(W(1,2),W(1,10),W(1,3),GC_64,GC_10,AMP(42))
      JAMP(1)=+4D0*(+AMP(7)+AMP(28))
      JAMP(2)=+2D0*(+AMP(3)-AMP(1)-AMP(4)+AMP(5)-AMP(6)-AMP(8)-AMP(9)
     $ -AMP(11)-AMP(12)+AMP(14)+AMP(20)+AMP(21)+AMP(22)+AMP(24)-AMP(25)
     $ -AMP(26)-AMP(29)+AMP(32)-AMP(30)-AMP(35)-AMP(34)+AMP(39)+AMP(41)
     $ +AMP(40))
      JAMP(3)=+2D0*(+AMP(1)+AMP(2)+AMP(4)-AMP(5)+AMP(6)+AMP(8)-AMP(10)
     $ +AMP(11)-AMP(13)-AMP(14)+AMP(15)+AMP(16)+AMP(17)+AMP(19)+AMP(25)
     $ -AMP(27)+AMP(29)-AMP(32)-AMP(31)+AMP(35)-AMP(33)+AMP(37)+AMP(42)
     $ -AMP(40))
      JAMP(4)=+4D0*(+AMP(18)+AMP(36))
      JAMP(5)=+2D0*(-AMP(3)-AMP(2)+AMP(9)+AMP(10)+AMP(13)+AMP(12)
     $ -AMP(15)-AMP(16)-AMP(17)-AMP(19)-AMP(20)-AMP(21)-AMP(22)-AMP(24)
     $ +AMP(26)+AMP(27)+AMP(31)+AMP(30)+AMP(34)+AMP(33)-AMP(37)-AMP(39)
     $ -AMP(42)-AMP(41))
      JAMP(6)=+2D0*(+AMP(1)+AMP(2)+AMP(4)-AMP(5)+AMP(6)+AMP(8)-AMP(10)
     $ +AMP(11)-AMP(13)-AMP(14)+AMP(15)+AMP(16)+AMP(17)+AMP(19)+AMP(25)
     $ -AMP(27)+AMP(29)-AMP(32)-AMP(31)+AMP(35)-AMP(33)+AMP(37)+AMP(42)
     $ -AMP(40))
      JAMP(7)=+4D0*(+AMP(23)+AMP(38))
      JAMP(8)=+2D0*(-AMP(3)-AMP(2)+AMP(9)+AMP(10)+AMP(13)+AMP(12)
     $ -AMP(15)-AMP(16)-AMP(17)-AMP(19)-AMP(20)-AMP(21)-AMP(22)-AMP(24)
     $ +AMP(26)+AMP(27)+AMP(31)+AMP(30)+AMP(34)+AMP(33)-AMP(37)-AMP(39)
     $ -AMP(42)-AMP(41))
      JAMP(9)=+2D0*(+AMP(3)-AMP(1)-AMP(4)+AMP(5)-AMP(6)-AMP(8)-AMP(9)
     $ -AMP(11)-AMP(12)+AMP(14)+AMP(20)+AMP(21)+AMP(22)+AMP(24)-AMP(25)
     $ -AMP(26)-AMP(29)+AMP(32)-AMP(30)-AMP(35)-AMP(34)+AMP(39)+AMP(41)
     $ +AMP(40))

      MATRIX = 0.D0
      DO I = 1, NCOLOR
        ZTEMP = (0.D0,0.D0)
        DO J = 1, NCOLOR
          ZTEMP = ZTEMP + CF(J,I)*JAMP(J)
        ENDDO
        MATRIX = MATRIX+ZTEMP*DCONJG(JAMP(I))/DENOM(I)
      ENDDO

      END

      SUBROUTINE GET_ME(P, ALPHAS, NHEL ,ANS)
      IMPLICIT NONE
C     
C     CONSTANT
C     
      INTEGER    NEXTERNAL
      PARAMETER (NEXTERNAL=5)
C     
C     ARGUMENTS 
C     
      REAL*8 P(0:3,NEXTERNAL),ANS
      INTEGER NHEL
      DOUBLE PRECISION ALPHAS
      REAL*8 PI
CF2PY INTENT(OUT) :: ANS
CF2PY INTENT(IN) :: NHEL
CF2PY INTENT(IN) :: P(0:3,NEXTERNAL)
CF2PY INTENT(IN) :: ALPHAS
C     ROUTINE FOR F2PY to read the benchmark point.    
C     the include file with the values of the parameters and masses 
      INCLUDE 'coupl.inc'

      PI = 3.141592653589793D0
      G = 2* DSQRT(ALPHAS*PI)
      CALL UPDATE_AS_PARAM()
      IF (NHEL.NE.0) THEN
        CALL SMATRIXHEL(P, NHEL, ANS)
      ELSE
        CALL SMATRIX(P, ANS)
      ENDIF
      RETURN
      END

      SUBROUTINE INITIALISE(PATH)
C     ROUTINE FOR F2PY to read the benchmark point.    
      IMPLICIT NONE
      CHARACTER*180 PATH
CF2PY INTENT(IN) :: PATH
      CALL SETPARA(PATH)  !first call to setup the paramaters    
      RETURN
      END

      LOGICAL FUNCTION IS_BORN_HEL_SELECTED(HELID)
      IMPLICIT NONE
C     
C     CONSTANTS
C     
      INTEGER    NEXTERNAL
      PARAMETER (NEXTERNAL=5)
      INTEGER    NCOMB
      PARAMETER (NCOMB=16)
C     
C     ARGUMENTS
C     
      INTEGER HELID
C     
C     LOCALS
C     
      INTEGER I,J
      LOGICAL FOUNDIT
C     
C     GLOBALS
C     
      INTEGER HELC(NEXTERNAL,NCOMB)
      COMMON/BORN_HEL_CONFIGS/HELC

      INTEGER POLARIZATIONS(0:NEXTERNAL,0:5)
      COMMON/BORN_BEAM_POL/POLARIZATIONS
C     ----------
C     BEGIN CODE
C     ----------

      IS_BORN_HEL_SELECTED = .TRUE.
      IF (POLARIZATIONS(0,0).EQ.-1) THEN
        RETURN
      ENDIF

      DO I=1,NEXTERNAL
        IF (POLARIZATIONS(I,0).EQ.-1) THEN
          CYCLE
        ENDIF
        FOUNDIT = .FALSE.
        DO J=1,POLARIZATIONS(I,0)
          IF (HELC(I,HELID).EQ.POLARIZATIONS(I,J)) THEN
            FOUNDIT = .TRUE.
            EXIT
          ENDIF
        ENDDO
        IF(.NOT.FOUNDIT) THEN
          IS_BORN_HEL_SELECTED = .FALSE.
          RETURN
        ENDIF
      ENDDO

      RETURN
      END

