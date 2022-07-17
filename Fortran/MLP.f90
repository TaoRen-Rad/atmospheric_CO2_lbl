!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module MLP

private
integer,parameter :: Nq=10001
integer,ALLOCATABLE :: input_data_number
public :: get_k_mlp_low,get_k_mlp_high,GasMixInfo


TYPE GasMixInfo
  REAL(8)  :: P,T,x  ! Gas properties
END TYPE GasMixInfo

save


CONTAINS
subroutine get_k_mlp_low(Mix_Info,k,model_name,band_name)
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!use commonData, only : GasMixInfo
use MLP_network
use MLP_layer
use MLP_structure_low

implicit none
  TYPE(GasMixInfo),INTENT(IN) :: Mix_Info ! Local mixture information  
  type(network_type) :: net
  real(8),dimension(Nq),intent(out) :: k ! k-values
  real(8), ALLOCATABLE ::input_data_1(:)
  real(8) ::output_data_1(10001)
  INTEGER :: i,j,n
  INTEGER :: number 
  real(8) ,DIMENSION(:),ALLOCATABLE ::b(:)
  CHARACTER(LEN=3) :: model_name
  CHARACTER(LEN=4) :: band_name

!-------------------------------------------------

  net%layers_size =hidden_layer_sizes
  net%number_of_layer=number_of_layer
!-------------------------------------------------
if (model_name=='oco') then
  input_data_number = 3
  ALLOCATE(input_data_1(input_data_number))
  input_data_1(1)=Mix_Info%P*100000d0
  input_data_1(2)=Mix_Info%T
  input_data_1(3)=Mix_Info%x
  call model_oco_low(model_name,band_name)
ENDIF

if (model_name=='zzq') then
  input_data_number = 2
  ALLOCATE(input_data_1(input_data_number))
  input_data_1(1)=Mix_Info%P
  input_data_1(2)=Mix_Info%T
  call model_zzq_low(model_name,band_name)
ENDIF
!--------------------
  DO i=1,input_data_number
      input_data_1(i)=(input_data_1(i)-u(i))/sqrt(s(i))
  END DO
!--------------------
  net%layers(1)%W=coefs_0
  net%layers(1)%b=intercepts_0
  net%layers(2)%W=coefs_1
  net%layers(2)%b=intercepts_1
  net%layers(3)%W=coefs_2
  net%layers(3)%b=intercepts_2
  net%layers(4)%W=coefs_3
  net%layers(4)%b=intercepts_3


!--------------------input layers----------------
  net%layers(1)%a=input_data_1
!-------------------hidden layers----------------

  do n=2,net%number_of_layer+2
       net%layers(n)%z = matmul(transpose(net%layers(n-1)%W),net%layers(n-1)%a)+ net%layers(n-1)%b
       if (n /=  net%number_of_layer+2)   then
              number=net%layers_size(n)              
              ALLOCATE(b(number))
              call sub1(net%layers(n)%z,b)
              net%layers(n)%a=b
              DEALLOCATE(b)
       end if
  end do
!-------------------ouput layer-----------------
  DO i=1,10001
    k(i)=net%layers(net%number_of_layer+2)%z(i)*sqrt(sy(i))+uy(i)
  END DO
!-----------------------------------------------
RETURN
END SUBROUTINE get_k_mlp_low

subroutine get_k_mlp_high(Mix_Info,k,model_name,band_name)
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!use commonData, only : GasMixInfo
use MLP_network
use MLP_layer
use MLP_structure_high

implicit none
  TYPE(GasMixInfo),INTENT(IN) :: Mix_Info ! Local mixture information  
  type(network_type) :: net
  real(8),dimension(Nq),intent(out) :: k ! k-values
  real(8), ALLOCATABLE ::input_data_1(:)
  real(8) ::output_data_1(10001)
  INTEGER :: i,j,n
  INTEGER :: number 
  real(8) ,DIMENSION(:),ALLOCATABLE ::b(:)
  CHARACTER(LEN=3) :: model_name
  CHARACTER(LEN=4) :: band_name

!-------------------------------------------------

  net%layers_size =hidden_layer_sizes
  net%number_of_layer=number_of_layer
!-------------------------------------------------
if (model_name=='oco') then
  input_data_number = 3
  ALLOCATE(input_data_1(input_data_number))
  input_data_1(1)=Mix_Info%P*100000d0
  input_data_1(2)=Mix_Info%T
  input_data_1(3)=Mix_Info%x
  call model_oco_high(model_name,band_name)
ENDIF

if (model_name=='zzq') then
  input_data_number = 2
  ALLOCATE(input_data_1(input_data_number))
  input_data_1(1)=Mix_Info%P
  input_data_1(2)=Mix_Info%T
  call model_zzq_high(model_name,band_name)
ENDIF

!--------------------
  DO i=1,input_data_number
      input_data_1(i)=(input_data_1(i)-u(i))/sqrt(s(i))
  END DO
!--------------------
  net%layers(1)%W=coefs_0
  net%layers(1)%b=intercepts_0
  net%layers(2)%W=coefs_1
  net%layers(2)%b=intercepts_1
  net%layers(3)%W=coefs_2
  net%layers(3)%b=intercepts_2
  net%layers(4)%W=coefs_3
  net%layers(4)%b=intercepts_3


!--------------------input layers----------------
  net%layers(1)%a=input_data_1
!-------------------hidden layers----------------

  do n=2,net%number_of_layer+2
       net%layers(n)%z = matmul(transpose(net%layers(n-1)%W),net%layers(n-1)%a)+ net%layers(n-1)%b

       if (n /=  net%number_of_layer+2)   then
              number=net%layers_size(n)              
              ALLOCATE(b(number))
              call sub1(net%layers(n)%z,b)
              net%layers(n)%a=b
              DEALLOCATE(b)
       end if
  end do
!-------------------ouput layer-----------------
  DO i=1,10001
    k(i)=net%layers(net%number_of_layer+2)%z(i)*sqrt(sy(i))+uy(i)
  END DO
!-----------------------------------------------
RETURN
END SUBROUTINE get_k_mlp_high

!-------------------------------------------------------------------------
subroutine sub1(x,res)  
IMPLICIT NONE
    real(8), intent(in) :: x(:)
    real(8) ::O=0.0, res(size(x))
    res = max(O, x)
return 
end subroutine
!--------------------

END module MLP
