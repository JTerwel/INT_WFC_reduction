
procedure redwfcbias(biasl)

# Image Reduction of BIAS of INT-WFC (all CCDs) images (used for pre-reduction in general)
# Author: Ovidiu Vaduvescu, updated 4 Mar 2016, La Palma (based on 2011 scripts)
# Note: biaslist file must not have .fit and must not have last empty line
# NOTE: UPDATE the CCD gain and noise acc to http://www.ing.iac.es/astronomy/instruments/wfc/ccdnoise.html

string  biasl   { prompt = "List of bias images to reduce" }

struct *listl
# listl to be used only local


begin

string im
      
time


# Load packages...

noao
imred
ccdred

# Delete former files...

if (access("biaslist1")) delete("biaslist?")
delete("*.fits")


# Slice the 4 CCDs...
listl = biasl

while (fscan(listl, im) != EOF) 
{

  imcopy(im//"[1]", im//"CCD1")
  imcopy(im//"[2]", im//"CCD2")
  imcopy(im//"[3]", im//"CCD3")
  imcopy(im//"[4]", im//"CCD4")

  print(im//"CCD1", >> "biaslist1")
  print(im//"CCD2", >> "biaslist2")
  print(im//"CCD3", >> "biaslist3")
  print(im//"CCD4", >> "biaslist4")

}

# Set up specific WFC parameters and combine biases for the 4 CCDs...

  ccdproc.overscan = yes
  ccdproc.trim = yes
  ccdproc.biassec = "[10:2150,4105:4190]"
  ccdproc.trimsec = "[54:2101,1:4096]"
  ccdproc.readaxi = "column"

# CCD1:
  zerocombine.gain = 2.6           # electrons/DN (expected by zerocombine)
  zerocombine.rdnoise = 8.6        # electrons (expected by zerocombine) - must transform in electrons (WFC by multiplying with gain)
  zerocombine(input="@biaslist1", output="biasCCD1", ccdtype="", combine="median")

# CCD2:
  zerocombine.gain = 3.4           # electrons/DN (expected by zerocombine)
  zerocombine.rdnoise = 6.8        # electrons (expected by zerocombine) - must transform in electrons (WFC by multiplying with gain)
  zerocombine(input="@biaslist2", output="biasCCD2", ccdtype="", combine="median")

# CCD3:
  zerocombine.gain = 2.3           # electrons/DN (expected by zerocombine)
  zerocombine.rdnoise = 7.1        # electrons (expected by zerocombine) - must transform in electrons (WFC by multiplying with gain)
  zerocombine(input="@biaslist3", output="biasCCD3", ccdtype="", combine="median")

# CCD4:
  zerocombine.gain = 3.4           # electrons/DN (expected by zerocombine)
  zerocombine.rdnoise = 7.8        # electrons (expected by zerocombine) - must transform in electrons (WFC by multiplying with gain)
  zerocombine(input="@biaslist4", output="biasCCD4", ccdtype="", combine="median")


# delete not needed files...

delete("biaslist?")
delete("r*CCD?.fits")

time

end

