FC = gfortran -fmax-array-constructor=10000000 
FFLAGSS = -O0 -Wall -ffree-form -fcheck=all -fconvert=little-endian -shared -fPIC -cpp
LIB = usr/lib/x86_64-linux-gnu/hdf5/serial
INC = usr/include/hdf5/serial
FFLAGS = -L/usr/lib/x86_64-linux-gnu -L/usr/lib/gcc/x86_64-linux-gnu/8 -L/$(LIB) -ldl -lgfortran -lhdf5 -lhdf5_fortran


mlp: hdf5_utils.o MLP_structure_high.o MLP_structure_low.o MLP_layer.o MLP_network.o MLP.o main.o
	$(FC) $(FFLAGS) -I/$(INC) -o $@ $^ $(FFLAGS)

%.o: %.f90
	$(FC) $(FFLAGSS) -I/$(INC) -c -o $@ $<

clean:
	rm -f *.o *.mod mlp