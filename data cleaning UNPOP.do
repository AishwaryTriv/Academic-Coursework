* author: aishwary trivedi
clear
global path "C:/Users/aishwary/ECON643 Dropbox/Aish Trivedi/umd/econ643"

* read data 
use "$path/input/qss-stata-student/intro/UNpop.dta", clear 

describe
codebook 

*** question: what is the world population during cold war and in cold war
*** to calculate this number we first need to define a coldwar dummy variable
*** a dummy variable takes the value 1 if a condition is met, and 0 otherwise

generate coldwar4 = inrange(year, 1950, 1980)

* OR defining coldwar using not equal to
generate coldwar5 = 0
replace coldwar5 = 1 if year != 1990 & year != 2000 & year != 2010

* summarize pop before and after the coldwar 
tabstat worldpop, by(coldwar) statistic(sum) format(%12.2gc)

*** label coldwar variable
label define coldwarlabel 0 "After coldwar" 1 "During coldwar"
label values coldwar coldwarlabel
labelbook

* list all years during coldwar
list year if coldwar == 1

* define a string variable
gen coldwar_string = ""
replace coldwar_string = "After coldwar" if inlist(year, 1990, 2000, 2010)
replace coldwar_string = "During coldwar" if inlist(year, 1950, 1960, 1970, 1980)



