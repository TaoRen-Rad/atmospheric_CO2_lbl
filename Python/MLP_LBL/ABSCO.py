import numpy as np
import h5py 
import os

abs_path = os.getcwd()+'/MLP_LBL'

def read_file(file_name):
        file = open(file_name)
        X = []
        while 1:
            line = file.readline()
            if not line:
                break
            data = line[:-1].split(',')	
            X.append(np.array(data).astype(np.float64))
        X= np.array(X)
        return X

def ReLU(x):
    return np.maximum(x,0)

class network:

    def __init__(self, nn_file,profile_file):
        self.profile = np.asarray(read_file(profile_file))
        if self.profile[0][0]<=0.065:
            self.nn_file = abs_path+'/nn/'+nn_file+'/low/model.h5'
        else:
            self.nn_file = abs_path+'/nn/'+nn_file+'/high/model.h5'
        self.nn = h5py.File(self.nn_file,mode='r')

    def constructNN(self):
        return self.nn

class predictABSCO:
    def __init__(self, model, state, path):
        self.profile = np.asarray(read_file(state))
        if self.profile[0][0]<=0.065:
            self.path = path+'/low'
        else:
            self.path = path+'/high'

        if 'zzq' in path:
            self.state = self.profile[0][0:2]
            self.xco2 = self.profile[0][2]
        else:
            self.state = self.profile[0][0:3]
            self.state[0] = self.state[0]*100000
            self.xco2 = 1
        self.model = model
        self.ux = np.loadtxt(abs_path+'/nn/'+self.path+'/ux_model.dat')
        self.uy = np.loadtxt(abs_path+'/nn/'+self.path+'/uy_model.dat')
        self.sx = np.loadtxt(abs_path+'/nn/'+self.path+'/sx_model.dat')
        self.sy = np.loadtxt(abs_path+'/nn/'+self.path+'/sy_model.dat')

    def normal_in(self):
        input = (self.state-self.ux) / (self.sx**0.5)
        return input

    def normal_out(self):
        self.outputt = (self.output * (self.sy**0.5)) + self.uy
        return self.outputt

    def range(self):
        if 'sco2' in self.path:
            wavenumber = np.linspace(4800,4900,num = 10001)
        else:
            wavenumber = np.linspace(6180,6280,num = 10001)
        return wavenumber


    def predict(self,condition):
        output = condition
        for i in range(4):
            if i == 0:
                w = self.model['dense']['dense']['kernel:0']
                b = self.model['dense']['dense']['bias:0']
                output = np.dot(output,w)+b
                print(b.shape)
                # for j in range(b.shape[0]):
                #     output[0,j] = output[0,j]+b[j]
                print(output.shape)
                output = ReLU(output)
            else:
                group_name = 'dense_'+str(i)
                w = self.model[group_name][group_name]['kernel:0']
                b = self.model[group_name][group_name]['bias:0']
                print(output.shape)
                output = np.dot(output,w)+b
                print(output.shape)
                # for j in range(b.shape[0]):
                #     output[0,j] = output[0,j]+b[j]
                
                if i < 3:
                    output = ReLU(output)
        return output

    def spect(self):
        self.inputt = self.normal_in()
        self.output = self.predict(self.inputt)
        spec_value = self.normal_out()
        spec_value = np.exp(spec_value)*self.xco2
        return spec_value

    
