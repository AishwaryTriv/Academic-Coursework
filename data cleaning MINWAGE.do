* author: aishwary trivedi
clear
global path "C:/Users/aishwary/ECON643 Dropbox/Aish Trivedi/umd/econ643"

* read data
use "$myfoldername/input/qss-stata-student/causality/minwage.dta", clear

*** calculate mean wage before/after min wage law change in PA vs NJ

* define an indicator/dummy variable which takes the value 1 if NJ, 0 otherwise
gen state = 0 
replace state = 1 if location == "centralNJ"
replace state = 1 if location == "northNJ"
replace state = 1 if location == "shoreNJ"
replace state = 1 if location == "southNJ"

* label
label define statelabel 0 "PA" 1 "NJ"
label values state statelabel

* mean wage by value of state
tabstat wagebefore wageafter, by(state) statistic(mean) format(%9.2gc)

* define total emp
egen totalbefore_rowtotal = rowtotal(fullbefore partbefore)

* define proportion of full time workers
gen propfullbefore = fullbefore/totalbefore 
gen propfullafter = fullafter/totalafter

* define state
gen state = location == "PA" 
label define state 1 "PA" 0 "NJ" 
label values state state 

* compare means of proportion of full time workers before/after law
* change in pa vs nj
sum propfullbefore if state == 1 
sum propfullbefore if state == 0 
sum propfullafter if state == 1 
sum propfullafter if state == 0

* comparison using tabstat
tabstat propfullbefore propfullafter, by(state) format(%9.2fc)

* data visualization
graph bar propfullbefore propfullafter, over(state) blabel(bar, format (%9.2gc))

* proportion of restaurants where wage is less than 5.05
gen minwagebefore = inrange(wagebefore, 0, 5.05) 
gen minwageafter = inrange(wageafter, 0, 5.05)

/* digression: there are multiple alternative ways of defining this

* alternative 1: use gen/replace 
gen belowminwage_alt1 = . 
replace belowminwage_alt1 = 1 if inrange(wagebefore, 0, 5.05) == 1 
replace belowminwage_alt1 = 0 if inrange(wagebefore, 0, 5.05) != 1

* alternative 2: alternative 1 can be modified slightly 
gen belowminwage_alt2 = 0 
replace belowminwage_alt2 = 1 if inrange(wagebefore, 0, 5.05) == 1

* alternative 3: define indicator variable in one sentence 
gen belowminwage_alt3 = inrange(wagebefore, 0, 5.05) == 1

* alternative 4: use -cond- function
gen belowminwage_alt4 = cond(wageafter < 5.05, 1, 2)

*/

*** graphing an indicator variable
* step 1: creating dummy variables for the values of the variable
*  in question
tab minwagebefore, gen(dum_)

* step 2: graph the means using -graph bar-
graph bar (mean) dum_1 dum_2, blabel(bar, format(%9.2gc)) stack 

*** to view the distribution of a continous variable use -histogram-
hist wagebefore, frequency bin(10) xtitle("Wage before the law change") ytitle("Frequency of restaurants")

* to display the graph again later, defining a graph name
hist wagebefore, frequency bin(10) name(wage_bin10)

*** box plots

* detail summary statistics
sum wagebefore, detail 

* box plot
graph box wagebefore, name(wage_box)

* combine graphs 
graph combine wage_bin10 wage_box

* graph export 
graph export "$path/output/wage_bin_box_combine.png"
