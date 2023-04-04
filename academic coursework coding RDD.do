*** author: aishwary trivedi
*** objective: Regression discontinuity design

*************************************************************
* 4.5.3 Government Transfer and Poverty Reduction in Brazil 
*************************************************************

* prelim 
clear
global path "C:/Users/aishwary/ECON643 Dropbox/Aish Trivedi/umd/econ643"

* read data
use "$path/input/qss-stata-student/PREDICTION/transfer.dta", clear 

*************************************************************
/*** Answer 2 ***/
*************************************************************

* define mid points 
gen mid1 = (10188+13584)/2 
gen mid2 = (13584+16980)/2

* define normalized population 
gen pscore_ = . 
replace pscore_ = (pop82 - 10188)/10188 if pop82 <= mid1
replace pscore_ = (pop82 - 13584)/13584 if pop82 > mid1 & pop82 <= mid2
replace pscore_ = (pop82 - 16980)/16980 if pop82 > mid2

gen pscore = pscore_*100
drop pscore_

*************************************************************
/*** Answer 3 ***/
*************************************************************

* effect on literacy rate
regress literate91 pscore if pscore >= -3 & pscore <= 0
scalar litfit1 = _b[_cons]
regress literate91 pscore if pscore >= 0 & pscore <= 3
scalar litfit2 = _b[_cons]
display litfit2 - litfit1

* effect on educational attainment
regress educ91 pscore if pscore >= -3 & pscore <= 0
scalar educfit1 = _b[_cons]
regress educ91 pscore if pscore >= 0 & pscore <= 3
scalar educfit2 = _b[_cons]
display educfit2 - educfit1

* effect on poverty rate
regress poverty91 pscore if pscore >=- 3 & pscore <= 0
scalar povfit1 = _b[_cons]
regress poverty91 pscore if pscore >= 0 & pscore <= 3
scalar povfit2 = _b[_cons]
display povfit2 - povfit1

*************************************************************
/*** Answer 4 ***/
*************************************************************

* literacy rate plot
scatter literate91 pscore if pscore> = -3 & pscore <= 3, ///
xline(0) title("Literacy rate") ///
xtitle("Distance to population cutoff (%)") ytitle("Literacy rate in 1991") || ///
lfit literate91 pscore  if pscore >= -3 & pscore <= 0 || ///
lfit literate91 pscore  if pscore >= 0 & pscore <= 3, legend(off) name(lit1, replace)

* educational attainment plot
scatter educ91 pscore if pscore >= -3 & pscore <= 3, ///
xline(0) title("Educational attainment") ///
xtitle("Distance to population cutoff (%)") ytitle("Avg. years schooling in 1991") || ///
lfit educ91 pscore  if pscore >= -3 & pscore <= 0 || ///
lfit educ91 pscore  if pscore >= 0 & pscore <= 3, legend(off) name(edu1, replace)

* educational attainment plot
scatter poverty91 pscore if pscore >= -3 & pscore <= 3, ///
xline(0) title("Poverty rate") ///
xtitle("Distance to population cutoff (%)") ytitle("Poverty rate in 1991") || ///
lfit poverty91 pscore  if pscore >= -3 & pscore <= 0 || ///
lfit poverty91 pscore  if pscore >= 0 & pscore <= 3, legend(off) name(pov1, replace)

*************************************************************
/*** Answer 5 ***/
*************************************************************

* difference-in-means
summarize literate91 if pscore >= -3 & pscore <= 0
scalar litbelow = r(mean)
summarize literate91 if pscore >= 0 & pscore <= 3
scalar litabove = r(mean)
display litabove - litbelow

summarize educ91 if pscore >= -3 & pscore <= 0
scalar educbelow = r(mean)
summarize educ91 if pscore >= 0 & pscore <= 3
scalar educabove = r(mean)
display educabove - educbelow

summarize poverty91 if pscore >= -3 & pscore <= 0
scalar povbelow = r(mean)
summarize poverty91 if pscore >= 0 & pscore <= 3
scalar povabove = r(mean)
display povabove - povbelow
  
*************************************************************
/*** Answer 6 ***/
*************************************************************

foreach var of varlist literate91 educ91 poverty91 {
	forvalues  i = 1/5 {
		quietly regress `var' pscore if pscore >= -`i' & pscore <= 0
		quietly scalar litfit1 = _b[_cons]
		quietly regress `var' pscore if pscore >= 0 & pscore <= `i'
		quietly scalar litfit2 = _b[_cons]
	generate `var'_`i' = litfit2 - litfit1
	}
	summarize `var'*
}
  
*************************************************************
/*** Answer 7 ***/
*************************************************************

* educational attainment in 1980
regress educ80 pscore if pscore >= -3 & pscore <= 0
scalar educfit1 = _b[_cons]
regress educ80 pscore if pscore >= 0 & pscore <= 3
scalar educfit2 = _b[_cons]
display educfit2 - educfit1

* poverty rate in 1980
regress poverty80 pscore if pscore >= -3 & pscore <= 0
scalar povfit1 = _b[_cons]
regress poverty80 pscore if pscore >= 0 & pscore <= 3
scalar povfit2 = _b[_cons]
display povfit2 - povfit1

graph close _all
