* author: aishwary trivedi
clear
global path "C:/Users/aishwary/ECON643 Dropbox/Aish Trivedi/umd/econ643"
*** preparing district x crime category level data for 2011

* read 2011 district x crimetype data
import excel using "$path/input/crime/police_br_crime_2011_dist_month.xlsx", clear

* drop obs that don't matter
drop if A == "SL NO."
drop if A == ""


*** define a new crime category variable and then carry forward it
gen crimecat_temp = "" 
replace crimecat_temp = A if regexm(A, "[A-Z]") == 1 
carryforward crimecat_temp, gen(crimecat)

* continue to mop up 
drop if district == ""
drop crimecat_temp
rename A districtid 

* destring 
destring districtid jan-tot, replace

* sort 
sort districtid crimecat

* define year
gen year = regexs(0) if regexm(crimecat, "[0-9][0-9][0-9][0-9]$") == 1 

* sanity check
isid district crimecat

* compress 
compress 
save "$path/output/crime2011.dta", replace

********************************************************************************
*Appending dataset
********************************************************************************
clear

* read 2011 district x crimetype data
import excel using "$path/input/crime/police_br_crime_2011_dist_month.xlsx", clear

* convert xls to dta 
forvalues j = 2011/2017 {
	di "$path/input/crime/police_br_crime_`j'_dist_month.xlsx"
}

* convert xls to dta 
forvalues j = 2011/2017 {
	* read xls 
	import excel using "$path/input/crime/police_br_crime_`j'_dist_month.xlsx", clear
	* save 
	save "$path/temp/crime_`j'.dta", replace 
}

* append all dta
forvalues j = 2011/2016 {
	append using "$path/temp/crime_`j'.dta", gen(append_`j')
}

* read data
use "$path/output/crime2011.dta", clear 

sum jan if crimecat == "MURDER IN 2011"
di "Avg murders in 2011 is " `r(mean)' " the SD is " `r(sd)' " and the no. of obs are " `r(N)'

* serial number of each obs 
gen serialnumber = _n 

* total no of obs 
gen totalobs = _N 

* count obs within each district 
bysort district: gen obsdistrictwise = _N 


distinct crimecat
di "there are `r(ndistinct)' unique crime categories in the data"

* define violent crime for murder, rape and riots
gen violentcrime = regexm(crimecat, "MURDER|RAPE|RIOT")

* prepare a district level data file for total number of violent crime in each month in 2011 (no of obs = 44)

preserve 

* drop 
drop if violentcrime != 1

* collapse
collapse (sum) jan feb mar apr may jun jul aug sep oct nov dec, by(district)

restore 

foreach var of varlist jan feb mar apr may {
	sum `var'
}

* calculate mean of jan feb ... 
foreach i of varlist jan feb mar apr may {
	bysort district: egen `i'_districtmean = mean(`i')
}



















