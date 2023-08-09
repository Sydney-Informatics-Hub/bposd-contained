#!/bin/python

from ldpc.codes import hamming_code
from bposd.css import css_code
h=hamming_code(3) #Hamming code parity check matrix
steane_code=css_code(hx=h,hz=h) #create Steane code where both hx and hz are Hamming codes
print("Hx")
print(steane_code.hx)
print("Hz")
print(steane_code.hz)

print("Lx Logical")
print(steane_code.lx)
print("Lz Logical")
print(steane_code.lz)

steane_code.test()

from ldpc.codes import rep_code

hx=hz=rep_code(7)
qcode=css_code(hx,hz)
qcode.test()

from ldpc.codes import rep_code
from bposd.hgp import hgp
h=rep_code(3)
surface_code=hgp(h1=h,h2=h,compute_distance=True) #nb. set compute_distance=False for larger codes
surface_code.test()


import numpy as np
from ldpc import bposd_decoder

bpd=bposd_decoder(
    surface_code.hz,#the parity check matrix
    error_rate=0.05,
    channel_probs=[None], #assign error_rate to each qubit. This will override "error_rate" input variable
    max_iter=surface_code.N, #the maximum number of iterations for BP)
    bp_method="ms",
    ms_scaling_factor=0, #min sum scaling factor. If set to zero the variable scaling factor method is used
    osd_method="osd_cs", #the OSD method. Choose from:  1) "osd_e", "osd_cs", "osd0"
    osd_order=7 #the osd search depth
    )


error=np.zeros(surface_code.N).astype(int)
error[[5,12]]=1
syndrome=surface_code.hz@error %2
bpd.decode(syndrome)

print("Error")
print(error)
print("BP+OSD Decoding")
print(bpd.osdw_decoding)
#Decoding is successful if the residual error commutes with the logical operators
residual_error=(bpd.osdw_decoding+error) %2
a=(surface_code.lz@residual_error%2).any()
if a: a="Yes"
else: a="No"
print(f"Logical Error: {a}\n")
