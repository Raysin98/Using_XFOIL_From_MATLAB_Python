import os
import numpy as np
import matplotlib.pyplot as plt

# %% CREATE LOADING FILE

# Knowns
NACA       = '4412'
AoA        = '0'
re         = '3000000'
mach       = '0.1'
it         = '250'
numNodes   = '170'
saveFlnmAF = 'Save_Airfoil.txt'
saveFlnmCl = 'Save_Cl.txt'
xfoilFlnm  = 'xfoil_input.txt'

# Delete files if they exist
if os.path.exists(saveFlnmAF):
    os.remove(saveFlnmAF)

if os.path.exists(saveFlnmCl):
    os.remove(saveFlnmCl)
    
# Create the airfoil
fid = open(xfoilFlnm,"w")
fid.write("NACA " + NACA + "\n")
fid.write("PPAR\n")
# fid.write("N " + numNodes + "\n")
fid.write("\n\n")
fid.write("PSAV " + saveFlnmAF + "\n")

fid.write("OPER\n")
fid.write("iter " + it + " \n")
fid.write("visc\n\n")
fid.write("re " + re + "\n")
fid.write("m " + mach + "\n")
fid.write("seqp\n")
fid.write("pacc\n")
fid.write( saveFlnmCl + "\n\n")
fid.write("aseq -20 20 1 \n")
fid.close()

# Run the XFoil calling command
os.system("xfoil.exe < xfoil_input.txt")

# Delete file after running
if os.path.exists(xfoilFlnm):
    os.remove(xfoilFlnm)

# %% READ DATA FILE: AIRFOIL

flpth = "C:/Users/KCW/Documents/MATLAB/python_xfoil/"
flnm  = flpth + saveFlnmAF
    
# Load the data from the text file
dataBuffer = np.loadtxt(flnm, skiprows=0)

# Extract data from the loaded dataBuffer array
XB = dataBuffer[:,0]
YB = dataBuffer[:,1]

# Delete file after loading
if os.path.exists(saveFlnmAF):
    os.remove(saveFlnmAF)

# %% READ DATA FILE: LIFT COEFFICIENT

# Load the data from the text file
DataBuffer = np.loadtxt(saveFlnmCl, skiprows=12)

# Extract data from the loaded dataBuffer array
AP  = DataBuffer[:,0]
CL  = DataBuffer[:,1]
CD  = DataBuffer[:,2]
CDp  = DataBuffer[:,3]
CM  = DataBuffer[:,4]
X_t  = DataBuffer[:,5]
X_b  = DataBuffer[:,6]

# Delete file after loading
if os.path.exists(saveFlnmCl):
    os.remove(saveFlnmCl)

# %% EXTRACT UPPER AND LOWER AIRFOIL DATA

# Split airfoil into (U)pper and (L)ower
XB_U = XB[YB >= 0]
XB_L = XB[YB < 0]
YB_U = YB[YB >= 0]
YB_L = YB[YB < 0]

# Split XFoil results into (U)pper and (L)ower
# Cp_U = Cp_0[YB >= 0]
# Cp_L = Cp_0[YB < 0]
# X_U  = X_0[YB >= 0]
# X_L  = X_0[YB < 0]

# %% PLOT DATA

# Plot airfoil
font = {'color': 'g',
        'size': 17}

fig = plt.figure()
ax = fig.add_subplot(2,2,1)
plt.cla()
ax.plot(XB_U,YB_U,'b.-',label='Upper')
ax.plot(XB_L,YB_L,'r.-',label='Lower')
ax.set_xlabel('X-Coordinate')
ax.set_ylabel('Y-Coordinate')
ax.set_title('NACA ' + NACA , fontdict=font)
ax.axis('equal')
ax.legend()
fig.set_facecolor('k')
ax.set_facecolor('k')
ax.spines['bottom'].set_color('w')
ax.spines['top'].set_color('w') 
ax.spines['right'].set_color('w')
ax.spines['left'].set_color('w')
ax.xaxis.label.set_color('w')
ax.yaxis.label.set_color('w')
ax.tick_params(axis='x', colors='w')
ax.tick_params(axis='y', colors='w')
# plt.show()

# Plot: Drag Polar
ax = fig.add_subplot(2,2,2)
plt.cla()
ax.plot(CD,CL,'r-')
# ax.set_xlim('auto')
# ax.set_ylim('auto')
ax.set_xlabel('10^4 * Cd')
ax.set_ylabel('CL')
ax.set_title('Drag Polar(Cl vs Cd)',fontdict=font)
ax.grid()
ax.text(0.1,3, 'Re = ' +  re, color='w')
ax.text(0.15,3, 'Mach = ' +  mach, color='w')
ax.set_facecolor('k')
ax.spines['bottom'].set_color('w')
ax.spines['top'].set_color('w') 
ax.spines['right'].set_color('w')
ax.spines['left'].set_color('w')
ax.xaxis.label.set_color('w')
ax.yaxis.label.set_color('w')
ax.tick_params(axis='x', colors='w')
ax.tick_params(axis='y', colors='w')



# Plot: Lift Polar
ax = fig.add_subplot(2,2,3)
plt.cla()
ax.plot(AP,CL,'r-')
ax.grid()
# ax.set_xlim('auto')
# ax.set_ylim('auto')
ax.set_xlabel('Alpha')
ax.set_ylabel('CL')
ax.set_title('Lift Polar(Cl vs alpha)',fontdict=font)
ax.set_facecolor('k')
ax.spines['bottom'].set_color('w')
ax.spines['top'].set_color('w') 
ax.spines['right'].set_color('w')
ax.spines['left'].set_color('w')
ax.xaxis.label.set_color('w')
ax.yaxis.label.set_color('w')
ax.tick_params(axis='x', colors='w')
ax.tick_params(axis='y', colors='w')



# Plot: Transition Polar
ax = fig.add_subplot(2,2,4)
plt.cla()
ax.plot(X_t,CL,'b-',label='Upper')
ax.plot(X_b,CL,'r-',label='Lower')
ax.grid()
# ax.set_xlim('auto')
# ax.set_ylim('auto')
ax.set_xlabel('Xtr/C')
ax.set_ylabel('CL')
ax.set_title('Transition Polar',fontdict=font)
ax.legend()
ax.set_facecolor('k')
ax.spines['bottom'].set_color('w')
ax.spines['top'].set_color('w') 
ax.spines['right'].set_color('w')
ax.spines['left'].set_color('w')
ax.xaxis.label.set_color('w')
ax.yaxis.label.set_color('w')
ax.tick_params(axis='x', colors='w')
ax.tick_params(axis='y', colors='w')


plt.tight_layout()
plt.show()