from MLP_LBL.ABSCO import network
from MLP_LBL.ABSCO import predictABSCO
from matplotlib import pyplot as plt
import numpy as np


if __name__=="__main__":
    
    model = "oco/wco2"

    # Cases :   "zzq/wco2", "oco/sco2", "oco/wco2"

    state = "profile.txt"  

    # Contains : 
    #           Pressure (unit: bar for zzq model; Pa for OCO-2 model),
    #           Temperature (unit: K),
    #           Gas_VMR (unit:-) [CO2-VMR for zzq model; H2O-VMR for OCO-2 model]

    nn = network(model,state)
    absc = predictABSCO(nn.constructNN(),state,model)
    wavenumber = absc.range()
    absco = absc.spect()

    # wavenumber (unit: cm-1)
    # absc :    absorption coefficient (unit: cm-1, for zzq model)
    #           absorption cross section (unit: cm2*molecule-1, for zzq model)

    plt.figure(figsize=(8,6))
    plt.plot(wavenumber,absco[:])
    plt.savefig('absco_test.png',dpi = 300)
    np.savetxt('out_absco_py.dat',absco[:])