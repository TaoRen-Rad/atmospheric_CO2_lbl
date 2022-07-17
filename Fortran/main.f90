program mlp_lbl
!use commonData
use MLP
implicit none
  
integer :: ii, jj, ierr
real(8) :: absco(10001)
real(8) :: absco_out(2,10001)
real(8) :: wavenumber(10001)
REAL(8), PARAMETER:: resolution = 0.01d0
REAL(8):: wave_b
REAL(8):: wave_e
INTEGER:: wavesize=10001
CHARACTER(LEN=3), PARAMETER :: model_name = "oco"   ! Cases: "oco", "zzq"
CHARACTER(LEN=4), PARAMETER :: band_name = "wco2"   ! Cases: "wco2", "sco2"
REAL(8) :: state(3)


TYPE(GasMixInfo) :: locMix_f        ! Local mixture information


OPEN(UNIT = 11, FILE= 'profile.dat', STATUS='OLD',ACTION='READ', IOSTAT = ierr)
IF(ierr /= 0) THEN
  WRITE(*,*) 'Error! Could not open output file!'
ENDIF
READ(11,*)(state(ii),ii=1,3)
! Contains : 
!           Pressure (unit: bar),
!           Temperature (unit: K),
!           Gas_VMR (unit:-) [CO2-VMR for zzq model; H2O-VMR for OCO-2 model]


OPEN(UNIT = 12, FILE= 'out_absco.dat', STATUS = 'REPLACE', ACTION = 'WRITE', IOSTAT = ierr)
IF(ierr /= 0) THEN
    WRITE(*,*) 'Error! Could not open output file!'
ENDIF



! Absorption coefficients calculating......
if (model_name == 'zzq') then
  locMix_f%P=state(1)
  locMix_f%T=state(2)
  if (locMix_f%P<=0.065) then    
    CALL get_k_mlp_low(locMix_f,absco,model_name,band_name)
    write(*,*) 'model:zzq'
  else
    CALL get_k_mlp_high(locMix_f,absco,model_name,band_name)
    write(*,*) 'model:zzq'
  endif
  absco(:)=state(3)*exp(absco(:))
ENDIF

if (model_name == 'oco') then
  locMix_f%P=state(1)
  locMix_f%T=state(2)
  locMix_f%x=state(3)
  if (locMix_f%P<=0.065) then      
    CALL get_k_mlp_low(locMix_f,absco,model_name,band_name)
    write(*,*) 'model:oco'
  else
    CALL get_k_mlp_high(locMix_f,absco,model_name,band_name)
    write(*,*) 'model:oco'
  endif
  absco(:)=exp(absco(:))
ENDIF


! Wavenumber calculating......
if (band_name == 'wco2') then
  wave_b = 6180.d0
  wave_e = 6280.d0
endif

if (band_name == 'sco2') then
  wave_b = 4800.d0
  wave_e = 4900.d0
endif

wavenumber(1) = wave_b
do ii = 1, wavesize-1
  wavenumber(ii+1) = wavenumber(ii) + resolution
end do

absco_out(1,:) = wavenumber
absco_out(2,:) = absco

DO ii= 1 , wavesize
WRITE(12,"(*(E11.4,:,','))") (absco_out(jj,ii) , jj = 1,2)
end do


end program mlp_lbl