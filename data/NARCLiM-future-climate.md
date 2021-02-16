# NARCLiM data

Following information taken from [NARCLiM Website](https://climatechange.environment.nsw.gov.au/Climate-projections-for-NSW/About-NARCliM):

>   *NSW and ACT Regional Climate Modelling (NARCliM) Project* has produced an ensemble of robust regional climate projections for south-eastern Australia that can be used by the NSW and ACT community to plan for the range of likely future changes in climate.
>
>   NARCliM provides dynamically downscaled climate projections for south-east Australia at a 10-km resolution (NARCLiM domain) and for the whole of Australasia at 50 km, in line with the CORDEX Framework.

### Version 1.0

Following information taken from [NARCLiM Website](https://climatechange.environment.nsw.gov.au/Climate-projections-for-NSW/About-NARCliM), see also Evans et al. 2014:

>   The NARCliM projections have been generated from four global climate models (GCMs). The four GCMs  MIROC, ECHAM, CCCMA and CSIRO Mk3.0) form part of the World Climate Research Program's (WCRP) Coupled Model Inter-comparison Project phase 3 (CMIP3) models, which were used by the Intergovernmental Panel on Climate Change (IPCC) for its Fourth Assessment Report
>
>   The Weather Research and Forecasting (WRF) model, a dynamical regional climate model, was used to downscale projections from the four GCMs. WRF has been demonstrated to be effective in simulating temperature and rainfall in NSW and provides a good representation of local topography and coastal processes. It was jointly developed by several major weather and research centres in the United States and is widely used internationally.
>
>   Three physical configurations of WRF were run with each of the four separate GCMs, for a total of 12 runs, producing a 12 model ensemble. The 12 models were run using a single, representative emissions scenario: the IPCC high emissions scenario A2. The 12 models were run for three time periods: 1990 to 2009 (base), 2020 to 2039 (near future), and 2060 to 2079 (far future). A reanalysis dataset is also available for the period 1950 to 2009.

Access to the data on the [Katana computational cluster](https://research.unsw.edu.au/katana) shared by Fei Ji (Department of Planning, Industry and Environment) on July 2020. There are 192G of Data in three folders, I keep a local copy as a backup, but decided to keep the main analysis in Katana.

There are three time periods:
* 1990-2009
* 2020-2039
* 2060-2079

Four GCMs:
* CCCMA3.1
* CSIRO-MK3.0
* ECHAM5
* MIROC3.2

And three physical configurations of regional climate model:
* R1
* R2
* R3

Variables shared by Fei:  
* Accumulated Morton areal potential evapotranspiration (units: Kg m-2): *apet*
* *frost*
* Total soil moisture content (units: kg m-2): *mrsomean*
* Accumulated precipitation (Kg m-2): *pracc*
* Daily mean, maximum and minimum 2-metre Surface air temperature (units K): *tasmean*, *tasmax*, *tasmin*
* Surface wind speed at 10m (units:  m s-1): *wssmean*

Other available variables
* surface pressure
* 2-metre specific humidity (hourly)
* snow amount (Luca et al. 2018)
* sea surface temperature.

### Version 1.5

According to Fei (June 2020):
>   The NARCliM1.5 data will be publicly released in a few months... NARCliM1.5 uses similar modelling setting (domain, resolution, data format) as NARCliM1.0. NARCliM1.5 is not going to replace NARCliM1.0, instead, we complementary use of both NARCliM1.0 & NARCliM1.5 – benefits of using them individually and in combination.


#### References
Evans JP, Ji F, Lee C, Smith P, Argüeso D and Fita L (2014) Design of a regional climate modelling projection ensemble experiment – NARCliM . Geosci. Model Dev., 7, 621–629. https://doi.org/10.5194/gmd-7-621-2014

Luca, A.D., Evans, J.P. & Ji, F. Australian snowpack in the NARCliM ensemble: evaluation, bias correction and future projections. Clim Dyn 51, 639–666 (2018). https://doi.org/10.1007/s00382-017-3946-9

McMaster, Gregory S. and Wilhelm, Wallace, "Growing degree-days: one equation, two interpretations" (1997). Publications from USDA-ARS / UNL Faculty. 83. https://digitalcommons.unl.edu/usdaarsfacpub/83

Nicholas Coops, Andrew Loughhead, Philip Ryan & Ron Hutton (2001) Development of daily spatial heat unit mapping from monthly climatic surfaces for the Australian continent, International Journal of Geographical Information Science, 15:4, 345-361, https://doi.org/10.1080/13658810010011401
