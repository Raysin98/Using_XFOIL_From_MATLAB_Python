import os
import numpy as np
import matplotlib.pyplot as plt

# %% CREATE LOADING FILE

# Knowns
NACA       = '4412'
AoA        = '0'
re_1       = '3000000'
re_2       = '1000000'
re_3       = '500000'
mach       = '0.1'
it         = '250'
numNodes   = '170'

saveFlnmAF_1 = 'Save_Airfoil_re1_4412.txt'
saveFlnmAF_2 = 'Save_Airfoil_re2_4412.txt'
saveFlnmAF_3 = 'Save_Airfoil_re3_4412.txt'
saveFlnmCl_1 = 'Save_Cl_re1_4412.txt'
saveFlnmCl_2 = 'Save_Cl_re2_4412.txt'
saveFlnmCl_3 = 'Save_Cl_re3_4412.txt'
xfoilFlnm  = 'xfoil_input.txt'

# Delete files if they exist
if os.path.exists(saveFlnmAF_1):
    os.remove(saveFlnmAF_1)

if os.path.exists(saveFlnmAF_2):
    os.remove(saveFlnmAF_2)

if os.path.exists(saveFlnmAF_3):
    os.remove(saveFlnmAF_3)

if os.path.exists(saveFlnmCl_1):
    os.remove(saveFlnmCl_1)

if os.path.exists(saveFlnmCl_2):
    os.remove(saveFlnmCl_2)

if os.path.exists(saveFlnmCl_3):
    os.remove(saveFlnmCl_3)

# Create the airfoil
fid = open(xfoilFlnm,"w")
fid.write("NACA " + NACA + "\n")
# fid.write("PPAR\n")
# fid.write("N " + numNodes + "\n")
# fid.write("\n\n")
# fid.write("PSAV " + saveFlnmAF + "\n")

fid.write("OPER\n")
fid.write("iter " + it + " \n")
fid.write("visc\n\n")
fid.write("re " + re_1 + "\n")
fid.write("m " + mach + "\n")
fid.write("seqp\n")
fid.write("pacc\n")
fid.write( saveFlnmCl_1 + "\n\n")
fid.write("aseq -20 20 1 \n")
fid.write("pacc\n\n")

fid.write("OPER\n")
fid.write("re " + re_2 + "\n")
fid.write("pacc\n")
fid.write( saveFlnmCl_2 + "\n\n")
fid.write("aseq -20 20 1 \n")
fid.write("pacc\n\n")

fid.write("OPER\n")
fid.write("re " + re_3 + "\n")
fid.write("pacc\n")
fid.write( saveFlnmCl_3 + "\n\n")
fid.write("aseq -20 20 1 \n")

fid.close()

# Run the XFoil calling command
os.system("xfoil.exe < xfoil_input.txt")

# Delete file after running
if os.path.exists(xfoilFlnm):
    os.remove(xfoilFlnm)

# %% READ DATA FILE: AIRFOIL

# flpth = "C:/Users/KCW/Documents/MATLAB/python_xfoil/"
# flnm  = flpth + saveFlnmAF
    
# Load the data from the text file
# dataBuffer = np.loadtxt(flnm, skiprows=0)

# Extract data from the loaded dataBuffer array
# XB = dataBuffer[:,0]
# YB = dataBuffer[:,1]

# Delete file after loading
if os.path.exists(saveFlnmAF_1):
    os.remove(saveFlnmAF_1)

if os.path.exists(saveFlnmAF_2):
    os.remove(saveFlnmAF_2)

if os.path.exists(saveFlnmAF_2):
    os.remove(saveFlnmAF_2)
# %% READ DATA FILE: LIFT COEFFICIENT

# Load the data from the text file
DataBuffer_1 = np.loadtxt(saveFlnmCl_1, skiprows=12)

# Extract data from the loaded dataBuffer array
AP_1  = DataBuffer_1[:,0]
CL_1  = DataBuffer_1[:,1]
CD_1  = DataBuffer_1[:,2]
CDp_1  = DataBuffer_1[:,3]
CM_1  = DataBuffer_1[:,4]
X_t_1  = DataBuffer_1[:,5]
X_b_1 = DataBuffer_1[:,6]

# Delete file after loading
if os.path.exists(saveFlnmCl_1):
    os.remove(saveFlnmCl_1)

DataBuffer_2 = np.loadtxt(saveFlnmCl_2, skiprows=12)

# Extract data from the loaded dataBuffer array
AP_2  = DataBuffer_2[:,0]
CL_2  = DataBuffer_2[:,1]
CD_2  = DataBuffer_2[:,2]
CDp_2  = DataBuffer_2[:,3]
CM_2  = DataBuffer_2[:,4]
X_t_2  = DataBuffer_2[:,5]
X_b_2 = DataBuffer_2[:,6]

# Delete file after loading
if os.path.exists(saveFlnmCl_2):
    os.remove(saveFlnmCl_2)

DataBuffer_3 = np.loadtxt(saveFlnmCl_3, skiprows=12)

# Extract data from the loaded dataBuffer array
AP_3  = DataBuffer_3[:,0]
CL_3  = DataBuffer_3[:,1]
CD_3  = DataBuffer_3[:,2]
CDp_3  = DataBuffer_3[:,3]
CM_3  = DataBuffer_3[:,4]
X_t_3  = DataBuffer_3[:,5]
X_b_3 = DataBuffer_3[:,6]

# Delete file after loading
if os.path.exists(saveFlnmCl_3):
    os.remove(saveFlnmCl_3)

# %% EXTRACT UPPER AND LOWER AIRFOIL DATA

# Split airfoil into (U)pper and (L)ower
# XB_U = XB[YB >= 0]
# XB_L = XB[YB < 0]
# YB_U = YB[YB >= 0]
# YB_L = YB[YB < 0]

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
# ax.plot(XB_U,YB_U,'b.-',label='Upper')
# ax.plot(XB_L,YB_L,'r.-',label='Lower')
# ax.set_xlabel('X-Coordinate')
# ax.set_ylabel('Y-Coordinate')
# ax.set_title('NACA ' + NACA , fontdict=font)
# ax.legend()
ax.axis('equal')
ax.text(-0.02,-0.01, 'NACA ' + NACA + ' Re = ' +  re_1 +' Mach = ' +  mach, color='r' )
ax.text(-0.02,0, 'NACA ' + NACA + ' Re = ' +  re_2 +' Mach = ' +  mach, color='y' )
ax.text(-0.02,0.01,'NACA ' +  NACA + ' Re = ' +  re_3 +' Mach = ' +  mach, color='m' )
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
ax.plot(CD_1,CL_1,'r-')
ax.plot(CD_2,CL_2,'y-')
ax.plot(CD_3,CL_3,'m-')
# ax.set_xlim('auto')
# ax.set_ylim('auto')
ax.set_xlabel('10^4 * Cd')
ax.set_ylabel('CL')
ax.set_title('Drag Polar(Cl vs Cd)',fontdict=font)
ax.grid()
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
ax.plot(AP_1,CL_1,'r-')
ax.plot(AP_2,CL_2,'y-')
ax.plot(AP_3,CL_3,'m-')
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
ax.plot(X_t_1,CL_1,'r-')
ax.plot(X_b_1,CL_1,'r-')
ax.plot(X_t_2,CL_2,'y-')
ax.plot(X_b_2,CL_2,'y-')
ax.plot(X_t_3,CL_3,'m-')
ax.plot(X_b_3,CL_3,'m-')
ax.grid()
# ax.set_xlim('auto')
# ax.set_ylim('auto')
ax.set_xlabel('Xtr/C')
ax.set_ylabel('CL')
ax.set_title('Transition Polar',fontdict=font)
# ax.legend()
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