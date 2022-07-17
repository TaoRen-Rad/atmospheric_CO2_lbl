MODULE MLP_structure_low
IMPLICIT NONE
INTEGER,public ::number_of_layer= 3

integer,parameter :: Nabsco=10001
real(8),public,ALLOCATABLE :: u(:)
real(8),public,ALLOCATABLE :: s(:)
real(8),public :: uy(Nabsco)
real(8),public :: sy(Nabsco)
real(8),public :: intercepts_0(25)
real(8),public :: intercepts_1(100)
real(8),public :: intercepts_2(200)
real(8),public :: intercepts_3(10001)
real(8),public,ALLOCATABLE :: coefs_0(:,:)
real(8),public, dimension(25,100) :: coefs_1
real(8),public, dimension(100,200) :: coefs_2
real(8),public, dimension(200,10001) :: coefs_3
INTEGER,public :: hidden_layer_sizes(5)=(/2,25,100,200,10001/)



CONTAINS

subroutine model_zzq_low(model_name,band_name)
use hdf5_utils
IMPLICIT NONE
CHARACTER(LEN=3):: model_name
CHARACTER(LEN=4):: band_name
CHARACTER(LEN=30):: cut_combine_path
CHARACTER(LEN=30):: cut_combine_group
INTEGER::ierr, i

ALLOCATE(u(2))
ALLOCATE(s(2))
ALLOCATE(coefs_0(2,25))
hidden_layer_sizes(1) = INT(2.d0 + 1.E-6)

OPEN(UNIT = 21, FILE= 'nn/'//model_name//'/'//band_name//'/low/ux_model.dat', STATUS='OLD',ACTION='READ', IOSTAT = ierr)
READ(21,*)(u(i),i=1,2)

OPEN(UNIT = 22, FILE= 'nn/'//model_name//'/'//band_name//'/low/sx_model.dat', STATUS='OLD',ACTION='READ', IOSTAT = ierr)
READ(22,*)(s(i),i=1,2)

OPEN(UNIT = 23, FILE= 'nn/'//model_name//'/'//band_name//'/low/uy_model.dat', STATUS='OLD',ACTION='READ', IOSTAT = ierr)
READ(23,*)(uy(i),i=1,Nabsco)

OPEN(UNIT = 24, FILE= 'nn/'//model_name//'/'//band_name//'/low/sy_model.dat', STATUS='OLD',ACTION='READ', IOSTAT = ierr)
READ(24,*)(sy(i),i=1,Nabsco)

cut_combine_path = model_name//band_name//'/low'
cut_combine_group = 'dense/dense/bias:0'
call read_mlp_dataset_vector(model_name//'/'//band_name//'/low',cut_combine_group,1,25,intercepts_0)
call read_mlp_dataset_vector(model_name//'/'//band_name//'/low','dense_1/dense_1/bias:0',1,100,intercepts_1)
call read_mlp_dataset_vector(model_name//'/'//band_name//'/low','dense_2/dense_2/bias:0',1,200,intercepts_2)
call read_mlp_dataset_vector(model_name//'/'//band_name//'/low','dense_3/dense_3/bias:0',1,Nabsco,intercepts_3)

cut_combine_group = 'dense/dense/kernel:0'
call read_mlp_dataset_matrix(model_name//'/'//band_name//'/low',cut_combine_group,2,25,coefs_0)
call read_mlp_dataset_matrix(model_name//'/'//band_name//'/low','dense_1/dense_1/kernel:0',25,100,coefs_1)
call read_mlp_dataset_matrix(model_name//'/'//band_name//'/low','dense_2/dense_2/kernel:0',100,200,coefs_2)
call read_mlp_dataset_matrix(model_name//'/'//band_name//'/low','dense_3/dense_3/kernel:0',200,Nabsco,coefs_3)

end subroutine model_zzq_low


subroutine model_oco_low(model_name,band_name)
use hdf5_utils
IMPLICIT NONE
CHARACTER(LEN=3) :: model_name
CHARACTER(LEN=4) :: band_name
CHARACTER(LEN=30):: cut_combine_path
CHARACTER(LEN=30):: cut_combine_group
INTEGER::ierr, i
ALLOCATE(u(3))
ALLOCATE(s(3))
ALLOCATE(coefs_0(3,25))
hidden_layer_sizes(1) = INT(3.d0 + 1.E-6)



OPEN(UNIT = 21, FILE= 'nn/'//model_name//'/'//band_name//'/low/ux_model.dat', STATUS='OLD',ACTION='READ', IOSTAT = ierr)
READ(21,*)(u(i),i=1,3)

OPEN(UNIT = 22, FILE= 'nn/'//model_name//'/'//band_name//'/low/sx_model.dat', STATUS='OLD',ACTION='READ', IOSTAT = ierr)
READ(22,*)(s(i),i=1,3)

OPEN(UNIT = 23, FILE= 'nn/'//model_name//'/'//band_name//'/low/uy_model.dat', STATUS='OLD',ACTION='READ', IOSTAT = ierr)
READ(23,*)(uy(i),i=1,Nabsco)

OPEN(UNIT = 24, FILE= 'nn/'//model_name//'/'//band_name//'/low/sy_model.dat', STATUS='OLD',ACTION='READ', IOSTAT = ierr)
READ(24,*)(sy(i),i=1,Nabsco)

cut_combine_path = model_name//band_name//'/low'
cut_combine_group = 'dense/dense/bias:0'
call read_mlp_dataset_vector(model_name//'/'//band_name//'/low',cut_combine_group,1,25,intercepts_0)
call read_mlp_dataset_vector(model_name//'/'//band_name//'/low','dense_1/dense_1/bias:0',1,100,intercepts_1)
call read_mlp_dataset_vector(model_name//'/'//band_name//'/low','dense_2/dense_2/bias:0',1,200,intercepts_2)
call read_mlp_dataset_vector(model_name//'/'//band_name//'/low','dense_3/dense_3/bias:0',1,Nabsco,intercepts_3)

cut_combine_group = 'dense/dense/kernel:0'

call read_mlp_dataset_matrix(model_name//'/'//band_name//'/low',cut_combine_group,3,25,coefs_0)
call read_mlp_dataset_matrix(model_name//'/'//band_name//'/low','dense_1/dense_1/kernel:0',25,100,coefs_1)
call read_mlp_dataset_matrix(model_name//'/'//band_name//'/low','dense_2/dense_2/kernel:0',100,200,coefs_2)
call read_mlp_dataset_matrix(model_name//'/'//band_name//'/low','dense_3/dense_3/kernel:0',200,Nabsco,coefs_3)

end subroutine model_oco_low

subroutine read_mlp_dataset_matrix(modelname,groupname,row,colomn,hyperparameter)
    use hdf5_utils
    integer(HID_T) :: file_id
    CHARACTER(LEN=12) :: modelname
    CHARACTER(LEN=24) :: groupname
    CHARACTER(LEN=30) :: cut_combine_modelname
    integer :: row
    integer :: colomn
    real(8), dimension(row,colomn),intent(out) :: hyperparameter
    real(8), dimension(colomn,row) :: hyperparameter_trans
    integer :: ii, jj
    ! open file

    cut_combine_modelname = 'nn/'//modelname//'/model.h5'
    call hdf_open_file(file_id, cut_combine_modelname, STATUS='OLD', ACTION='READ')
    ! read in some datasets 
    call hdf_read_dataset(file_id, groupname, hyperparameter_trans)
    ! close file
    call hdf_close_file(file_id)
    do ii = 1, row
        do jj = 1, colomn
            hyperparameter(ii,jj)=hyperparameter_trans(jj,ii)
        end do
    end do

end subroutine read_mlp_dataset_matrix

subroutine read_mlp_dataset_vector(modelname,groupname,row,colomn,hyperparameter)
    use hdf5_utils
    integer(HID_T) :: file_id
    CHARACTER(LEN=12) :: modelname
    CHARACTER(LEN=30) :: cut_combine_modelname
    CHARACTER(LEN=22) :: groupname
    integer :: row
    integer :: colomn
    real(8), dimension(colomn), intent(out) :: hyperparameter
    real(8), dimension(:), ALLOCATABLE :: hyperparameter_trans
    integer :: ii, jj

    cut_combine_modelname = 'nn/'//modelname//'/model.h5'
    ! open file
    call hdf_open_file(file_id, cut_combine_modelname, STATUS='OLD', ACTION='READ')
    ALLOCATE(hyperparameter_trans(colomn))
    call hdf_read_dataset(file_id, groupname, hyperparameter)
    ! close file
    call hdf_close_file(file_id)

end subroutine read_mlp_dataset_vector


END MODULE MLP_structure_low