# MLP based LBL absorption coefficient model

# Introduction:
The MLP based LBL absorption coefficient model (MLP-LBL) focuses on quickly obtaining the desired gas absorption coefficients through MLP neural network structure. Users can quickly obtain high-resolution spectral absorption coefficients by simply loading the conditions, such as pressure, temperature, etc. So far, this program is able to cover the ABSCO range among atmospheric simulation.(OCO-2 program and Xie's research). 

# Dependencies
Compulsory libraries

GNU Fortran: HDF5, hdf5_utils(https://github.com/jterwin/HDF5_utils)

Python: h5py, numpy, matplotlib

# Quick Start
Instructions (MLP-LBL): 

0) The thermodynamic states for the gas mixture profiles can be changed in "profile.txt"; The model and bands can be changed in "main.f90/main.py"

1) Clean up(skip if using Python)

command: make clean

2) Compile the Fortran program(skip if using Python)

command: make

3) Get the absorption coefficient:

command:   ./mlp    python main.py


# Citation

Please contact: tao.ren@sjtu.edu.cn

