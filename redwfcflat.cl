
procedure redwfcflat(flatl)

# Image Reduction of FLATS of INT-WFC (all CCDs) images (used for pre-reduction in general)
# Author: Ovidiu Vaduvescu, updated 4 Mar 2016, La Palma (based on 2011 scripts)
# Note: flatlist file must not have .fit and must not have last empty line
# NOTE: UPDATE the CCD gain and noise acc to http://www.ing.iac.es/astronomy/instruments/wfc/ccdnoise.html

string  flatl   { prompt = "List of flat images to reduce" }

struct *listl
# listl to be used only local
#struct *listl1


begin

string im, junk
string str1, str2
real modeflat

time


# Load packages...

noao
imred
ccdred

# Delete former files...

if (access("flatlist1")) delete("flatlist?")
delete("r*.fits")
delete("flatCCD?.fits")
delete("tmpflatCCD?")
if (access("flatnormCCD1.fits")) delete("flatnormCCD?.fits")

# Slice the 4 CCDs...
listl = flatl

while (fscan(listl, im) != EOF) 
{

  imcopy(im//"[1]", im//"CCD1")
  imcopy(im//"[2]", im//"CCD2")
  imcopy(im//"[3]", im//"CCD3")
  imcopy(im//"[4]", im//"CCD4")

  print(im//"CCD1", >> "flatlist1")
  print(im//"CCD2", >> "flatlist2")
  print(im//"CCD3", >> "flatlist3")
  print(im//"CCD4", >> "flatlist4")

}

# Set CCD parameters and combine flats for each CCD...

  ccdproc.overscan = yes
  ccdproc.trim = yes
  ccdproc.zerocor = yes
  ccdproc.flatcor = no
  ccdproc.biassec = "[10:2150,4105:4190]"
  ccdproc.trimsec = "[54:2101,1:4096]"
  ccdproc.readaxi = "column"
  ccdproc.fixpix=no
  ccdproc.darkcor=no

# CCD1:
  flatcombine.gain = 2.6
  flatcombine.rdnoise = 9.3
  ccdproc.zero = "biasCCD1"
  flatcombine(input="@flatlist1", output="flatCCD1", combine="median", ccdtype="", process = yes)
  # replace negative or zero values by 1
  imreplace("flatCCD1.fits", 1, upper=0.01)
  # scale flat to 1
  imstat(image="flatCCD1.fits", format=no, fields="mode", >> "tmpflatCCD1")
  listl = "tmpflatCCD1"
  junk = fscan(listl, modeflat)
  imarith("flatCCD1", "/", modeflat, "flatnormCCD1")

# CCD2:
  flatcombine.gain = 3.5
  flatcombine.rdnoise = 8.4
  ccdproc.zero = "biasCCD2"
  flatcombine(input="@flatlist2", output="flatCCD2", combine="median", ccdtype="", process = yes)
  # replace negative or zero values by 1
  imreplace("flatCCD2.fits", 1, upper=0.01)
  # scale flat to 1
  imstat(image="flatCCD2.fits", format=no, fields="mode", >> "tmpflatCCD2")
  listl = "tmpflatCCD2"
  junk = fscan(listl, modeflat)
  imarith("flatCCD2", "/", modeflat, "flatnormCCD2")


# CCD3:
  flatcombine.gain = 2.6
  flatcombine.rdnoise = 7.5
  ccdproc.zero = "biasCCD3"
  flatcombine(input="@flatlist3", output="flatCCD3", combine="median", ccdtype="", process = yes)
  # replace negative or zero values by 1
  imreplace("flatCCD3.fits", 1, upper=0.01)
  # scale flat to 1
  imstat(image="flatCCD3.fits", format=no, fields="mode", >> "tmpflatCCD3")
  listl = "tmpflatCCD3"
  junk = fscan(listl, modeflat)
  imarith("flatCCD3", "/", modeflat, "flatnormCCD3")

# CCD4:
  flatcombine.gain = 3.4
  flatcombine.rdnoise = 9.9
  ccdproc.zero = "biasCCD4"
  flatcombine(input="@flatlist4", output="flatCCD4", combine="median", ccdtype="", process = yes)
  # replace negative or zero values by 1
  imreplace("flatCCD4.fits", 1, upper=0.01)
  # scale flat to 1
  imstat(image="flatCCD4.fits", format=no, fields="mode", >> "tmpflatCCD4")
  listl = "tmpflatCCD4"
  junk = fscan(listl, modeflat)
  imarith("flatCCD4", "/", modeflat, "flatnormCCD4")


delete("flatlist?")
delete("r*CCD*.fits")
delete ("temp?")
delete("tmpflatCCD?")

time

end

