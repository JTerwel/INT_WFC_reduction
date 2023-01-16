# INT_WFC_reduction
A set of scripts to quickly reduce WFC images and extract photometry

This project is incomplete. At the moment different parts of the reduction process are in different files. The goal is to put everything together in a single package / script that can be used easily. At the moment the reduction itself is done in IRAF, but this may be updated to using PYRAF at some point in the future. For the photometry extraction [AutoPHOT](https://github.com/Astro-Sean/autophot) is used. As no WCS is recorded in the WFC image headers, these need to be added. Assuming that [Astrometry.net](https://arxiv.org/abs/0910.2233) is installed locally, [AutoPHOT](https://github.com/Astro-Sean/autophot) can do this automatically when extracting the photometry.

### Files in this repository & current status:
- sort_observations.ipynb: Notebook to sort & rename freshly downloaded images, and make the lists needed in IRAF
- redwfcbias.cl: IRAF script to reduce bias images (As received from Ovidiu Vaduvescu)
- redwfcflat.cl: IRAF script to reduce flat field images (As received from Ovidiu Vaduvescu)
- redwfc.cl: IRAF script to reduce science images (As received from Ovidiu Vaduvescu)
- Extract_photometry_and_retrieve_WCS.ipynb: Notebook containing a showcase of photometry extraction
- Autophot.ipynb: Notebook to extract photometry from the reduced images automatically

### Sections of the reduction process & accessory files:
#### - Image sorting & renaming: sort_observations.ipynb
Assuming that all images are downloaded into a single directory, sort images based on observation night, type (bias, dome/sky flat, science), and observed filter according to the following structure:

download_folder
  
  &nbsp; &nbsp; + date 1 (yyyymmdd)
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; + bias
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp; + bias_(mjd1).fit
  
  &nbsp; &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp; + bias_(mjd2).fit
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp; ....
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp; + biaslist
    
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; + filter 1
 
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp; + flats
 
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp; |  &nbsp;  &nbsp; + dome
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp; |  &nbsp;  &nbsp; |  &nbsp;  &nbsp; + domeflat_(mjd1).fit
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp; |  &nbsp;  &nbsp; |  &nbsp;  &nbsp; + domeflat_(mjd2).fit
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp; |  &nbsp;  &nbsp; |  &nbsp;  &nbsp; ....
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp; |  &nbsp;  &nbsp; |  &nbsp;  &nbsp; + flatlist
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp; |  &nbsp;  &nbsp; + sky
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; + skyflat_(mjd1).fit
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; + skyflat_(mjd2).fit
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; ....
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; + flatlist
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp; +science
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; + object 1 (obj_name)_(mjd1).fit
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; + object 2 (obj_name)_(mjd2).fit
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; ....
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; + snlist
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; + filter 2
  
 &nbsp;  &nbsp; |  &nbsp;  &nbsp;  &nbsp; ....
  
 &nbsp;  &nbsp; + date 2 <yyyymmdd>
  
 &nbsp;  &nbsp; ....

biaslist, flatlist, and snlist are lists of files needing to be reduced in each step, which is needed in the IRAF step. The values inside () are taken from each image header.

#### - IRAF reduction: redwfcbias.cl, redwfcflat.cl, redwfc.cl
The actual image reduction. Some notes:
- To start IRAF from the command line first type: "xgterm" and then in the new window type: "cl"
- To define a new command in IRAF type something like: "task redwfc = redwfc.cl"
- To start ds9 in IRAF type: "!ds9 &"
- The scripts are to be run in this order: redwfcbias.cl, redwfcflat.cl, redwfc.cl
- At the moment the scripts assume that everything (all fits files required, list, and the script itself) are in the same directory, and the script is excecuted in that directory. This means that for now stuff needs to be copied every time. This is on the to-do list for fixing.
- Don’t forget to update the gain & noise, and make sure it is in the correct unit. Values can be found [here](https://www.ing.iac.es/Astronomy/instruments/wfc/ccdnoise.html)
- Check images after each step (e.g. stars might be showing in sky flats —> Go to dome flats)

#### - Photometry extraction: Extract_photometry_and_retrieve_WCS.ipynb, Autophot.ipynb
As stated above, this needs [AutoPHOT](https://github.com/Astro-Sean/autophot) and [Astrometry.net](https://arxiv.org/abs/0910.2233) to be installed. Currently, this notebook is just a showcase of how it should be used, with values being hardcoded in. This also assumes a different directory structure, where all observations of a single object are in a single directory together. Therefore, files need to be moved again at the start of this step (not shown in the notebook). The first time [AutoPHOT](https://github.com/Astro-Sean/autophot) is run, some questions need to be answered regarding the telescope and header information to be used. This information is saved, so these questions will be skipped on subsequent runs. At some point in the future the file that holds this information will be included in this repository to skip these questions from the get-go. Autophot.ipynb is a first version to automating this part, but is currently untested.

### TO-DO list
- [x] Make Skeleton structure
- [x] Make initial file sorting functions
- [x] Automatically create lists needed by IRAF
- [ ] Remove need to run each IRAF script within the specific directory it needs to operate in
- [ ] Make changing variables (noise / gain) in the IRAF scripts easier (should not have to edit the scripts themselves)
- [ ] Remove need to copy files between running the IRAF scripts
- [ ] Change IRAF usage to PYRAF usage
- [ ] Make file sorting functions to prepare for [AutoPHOT](https://github.com/Astro-Sean/autophot) photometry extraction
- [ ] Make [AutoPHOT](https://github.com/Astro-Sean/autophot) photometry extraction pipeline
- [ ] Put all functions together in a single package
- [ ] Update README.md to reflect the current state of the project
