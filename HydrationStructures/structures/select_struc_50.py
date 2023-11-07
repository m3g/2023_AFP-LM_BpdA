#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import LassoSelector
from matplotlib.path import Path
import subprocess
import os
import time


###### Load projection data
proj=np.loadtxt('./../../ContourMaps/fig_5/proj_50.dat')
x = proj[:,0]
y = proj[:,1]

fig, ax = plt.subplots(figsize=(10,10)) 
plt.scatter(proj[:,0], proj[:,1], s=10, marker='o', c='black', edgecolor='gray', linewidth=0, alpha= 1, cmap='jet')

plt.axis('off')
#plt.show()

##############################################################################
def onselect(verts):
    global ind
    p=Path(verts)
    bind=p.contains_points(proj)
    ind=np.arange(0, len(proj))
    ind=ind[bind]   
    

lineprops = {'color': 'red', 'linewidth': 2}
lasso = LassoSelector(ax=ax, onselect=onselect, lineprops=lineprops)

k=0
def accept(event):
        global k
        if event.key == "enter":
            k=k+1
           # print (ind)
            np.savetxt('region_'+str(k)+'.dat', ind)             ######nome que salva os índices
            fig2, ax2 = plt.subplots(figsize=(10,10))       
            ax2.plot(proj[:,0], proj[:,1], '.k', markersize=10, alpha=1)
            ax2.plot(proj[ind,0], proj[ind,1], '.r', markersize=10)
            plt.title('region '+str(k), fontsize=22)
            plt.axis('off')
            plt.savefig('region_'+str(k)+'.png',dpi=250)      ###########  salva região
            plt.show()

            f=open('region_'+str(k)+'.pdb', 'w')
            n=0
            f.write('CRYST 1\n ')
            for i in ind:
                 j=i+1
                 file= 'tmp/'+str(j)+'.pdb'               #localização dos frames começando em 1
                 g=open(file)
                 #f.write('MODEL '+str(n)+'\n')
                 f.write(g.read())
                 #f.write('TER\n')
                 #f.write('ENDMDL\n')
                 g.close()
                 n=n+1
            #f.write('END')
            f.close()
            #subprocess.Popen(['vmd', 'region_'+str(k)+'.pdb', 'w', '-e', 'format.tcl']).wait()
        
        
fig.canvas.mpl_connect("key_press_event", accept)
ax.set_title("Select a closed path and press enter to accept selected points.")
plt.show()

