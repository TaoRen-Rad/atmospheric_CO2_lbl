# mlp for regression
# define 'model+number'
import numpy as np
from sklearn.model_selection import train_test_split
from tensorflow.keras import Sequential
from tensorflow.keras.layers import Dense
from tensorflow.keras.models import load_model
from tensorflow.keras import regularizers
import matplotlib
from tensorflow.python.keras import callbacks
from tensorflow.python.training.tracking.util import Checkpoint
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
import os
os.environ["CUDA_VISIBLE_DEVICES"]="0"
scaler = StandardScaler()

def read_file(file_name):
	file = open(file_name)
	X = []
	while 1:
		line = file.readline()
		if not line:
			break
		data = line[:-1].split(',')	
		X.append(np.array(data).astype(np.float))
	X= np.array(X)
	return X


y = np.asarray(read_file("../train_data/wco2/absco_model1.dat"))
X = np.asarray(read_file("../train_data/wco2/profile_model1.dat"))
y=np.log(np.abs(y))

Xfit=X[0:1000]
yfit=y[0:1000]
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.05, random_state=1)
X_range = X_test

scaler.fit(Xfit)  
[ux,sx]=[scaler.mean_,scaler.var_]
X_test = scaler.transform(X_test)
X_train = scaler.transform(X_train)

scaler.fit(yfit)  
[uy,sy]=[scaler.mean_,scaler.var_]
y_test = scaler.transform(y_test)
y_train = scaler.transform(y_train)

n_features = X_train.shape[1]
filepath="wco2/model1_best.h5"
model = Sequential()
model.add(Dense(25, activation='relu', kernel_initializer='he_normal', input_shape=(n_features,)))
model.add(Dense(100, activation='relu', kernel_initializer='he_normal'))
model.add(Dense(200, activation='relu', kernel_initializer='he_normal'))
model.add(Dense(10001))
model.compile(optimizer='adam', loss='mse',metrics=['accuracy'])
checkpoint=callbacks.ModelCheckpoint(filepath,monitor='accuracy',verbose=1,save_best_only=True,mode='max')
callbacks_list=[checkpoint]
model.fit(X_train, y_train,epochs=1000, batch_size=50,callbacks=callbacks_list, verbose=1)

res = model.predict(X_test)
res=scaler.inverse_transform(res)  
y_test=scaler.inverse_transform(y_test)
res=np.exp(res)
y_test=np.exp(y_test)
wavenumber = np.linspace(6180, 6280, y.shape[1])
np.savetxt("wco2/ux_model1.dat",ux, fmt="%15.5e",delimiter=',')
np.savetxt("wco2/sx_model1.dat",sx, fmt="%15.5e",delimiter=',')
np.savetxt("wco2/uy_model1.dat",uy, fmt="%15.5e",delimiter=',')
np.savetxt("wco2/sy_model1.dat",sy, fmt="%15.5e",delimiter=',')

LBL=np.array(y_test.flatten())
MLP=np.array(res.flatten())
plt.clf()
plt.figure(figsize=(7,6))
plt.rcParams['xtick.direction'] = 'in'
plt.rcParams['ytick.direction'] = 'in'
plt.rcParams['xtick.major.pad'] = 5
plt.rcParams['ytick.major.pad'] = 5
plt.ylabel('Predicted $\kappa_\eta$ [cm$^{2}$ molecule$^{-1}$]',fontname="serif",fontsize=18)
plt.xlabel('Table $\kappa_\eta$ [cm$^{2}$ molecule$^{-1}$]',fontname="serif",fontsize=18)
plt.loglog(LBL,LBL, 'r-',label='Ideal', linewidth=2)
plt.scatter(LBL, MLP,marker='o', c='b',s=10,label='MLP', alpha=0.5)#facecolors='none',
plt.legend(fontsize=18)
plt.yticks(fontsize=18)
plt.xticks(fontsize=18)
plt.tight_layout()
plt.savefig('wco2/model1.png', dpi=300)