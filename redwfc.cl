
procedure redwfc(astl)

# Image Reduction of SCIENCE of INT-WFC (all CCDs) images (used for pre-reduction in general)
# Author: Ovidiu Vaduvescu, updated 4 Mar 2016, La Palma (based on 2011 scripts)
# Note: astlist file must not have .fit and must not have last empty line


string  astl   { prompt = "List of sky images to reduce" }

struct *listl
struct *listl1

# listl to be used only local


begin

string im, junk

time

# Load packages...

noao
imred
ccdred
crutil

# Delete former files...

delete("r*.fits")


# Slice the 4 CCDs...
listl = astl

while (fscan(listl, im) != EOF) 
{

  imcopy(im//"[1]", im//"CCD1")
  imcopy(im//"[2]", im//"CCD2")
  imcopy(im//"[3]", im//"CCD3")
  imcopy(im//"[4]", im//"CCD4")

# Set CCD parameters and combine flats for each CCD...

#  ccdproc.overscan = yes
#  ccdproc.trim = yes
  ccdproc.biassec = "[10:2150,4105:4190]"
  ccdproc.trimsec = "[54:2101,1:4096]"
  ccdproc.readaxi = "column"
  ccdproc.fixpix= no
  ccdproc.darkcor = no
  ccdproc.zerocor = yes
  ccdproc.flatcor = yes

#  UNCOMMENT THE NEXT, COMMENT THE NEXT PARAGRAPH, AND CHANGE ccdproc.fixpix=yes ABOVE IF YOU HAVE BADPIXEL FILES (could ask Ovidiu for them)
#  ccdproc(images=im//"CCD1", output=im//"redCCD1", fixfile="WFC-BPM-CCD1-fast.fits", ccdtype="none", zero="biasCCD1.fits", flat="flatCCD1.fits")
#  ccdproc(images=im//"CCD2", output=im//"redCCD2", fixfile="WFC-BPM-CCD2-fast.fits", ccdtype="none", zero="biasCCD2.fits", flat="flatCCD2.fits")
#  ccdproc(images=im//"CCD3", output=im//"redCCD3", fixfile="WFC-BPM-CCD3-fast.fits", ccdtype="none", zero="biasCCD3.fits", flat="flatCCD3.fits")
#  ccdproc(images=im//"CCD4", output=im//"redCCD4", fixfile="WFC-BPM-CCD4-fast.fits", ccdtype="none", zero="biasCCD4.fits", flat="flatCCD4.fits")

  ccdproc(images=im//"CCD1", output=im//"redCCD1", ccdtype="none", zero="biasCCD1.fits", flat="flatnormCCD1.fits")
  ccdproc(images=im//"CCD2", output=im//"redCCD2", ccdtype="none", zero="biasCCD2.fits", flat="flatnormCCD2.fits")
  ccdproc(images=im//"CCD3", output=im//"redCCD3", ccdtype="none", zero="biasCCD3.fits", flat="flatnormCCD3.fits")
  ccdproc(images=im//"CCD4", output=im//"redCCD4", ccdtype="none", zero="biasCCD4.fits", flat="flatnormCCD4.fits")


}


# delete not needed files..
delete("r???????CCD?.fits")


time

end
