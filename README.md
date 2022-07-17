# MLP based LBL absorption coefficient model

# Introduction:
Space-based remote sensing, which is used to infer  CO$_2$ concentration from the satellite-measured atmospheric spectral absorption signals, is an effective way to obtain CO$_2$ concentration data for greenhouse gas monitoring. The next-generation greenhouse gases monitoring satellites mainly address the challenge of improving the spatial and temporal resolutions of observations, which will dramatically increase the computational power required for the CO$_2$ retrievals. One of the bottlenecks is the high computational cost for the high-resolution (usually requires a line-by-line spectral resolution) spectral modeling. Therefore, developing a fast and accurate spectral modeling method becomes necessary to tackle this problem. In the present study, we presented a machine learning based line-by-line absorption coefficient calculation (prediction) method for CO$_2$ in the applications of atmospheric remote sensing. By training an artificial neural network with data randomly generated from a line-by-line CO$_2$ absorption coefficient look-up table, a compact, accurate and efficient absorption coefficient prediction model can be developed, which only takes the CO$_2$ thermodynamic states as input. The proposed method has been tested by developing an absorption coefficient prediction model for the CO$_2$ 1.6um spectral band, which was later used to simulate the measured spectra for clear sky conditions from the Greenhouse gases Observing SATellite (GOSAT) for several different locations around the world. Results have shown that the model is both accurate and efficient. In addition, the same approach has been applied to fit the absorption coefficient tables provided by the Orbiting Carbon Observatory (OCO)-2 mission and an accurate prediction model was also presented.

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

command(Fortran):   ./mlp 
command(Python):    python main.py


# Citation

@article{xrz22,
title={A machine learning based line-by-line absorption coefficient model for the application of atmospheric carbon dioxide remote sensing},
author={Xie, Fengxin and Ren, Tao  and Zhao, Ziqing and Zhao, Changying},
journal = {submitted to JQSRT for review},
year={2022}}
