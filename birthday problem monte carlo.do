*** author: aishwary trivedi
*** objective: birthday problem

*** by hand 

* prelim 
clear all

* we can start with any number of obs, this could be 75, 100, 150 etc.
set obs 50 

* serial number (or "class size") -- we are going to calculate the probability
* for different class sizes
gen k = _n 

* calculate the log of the numerator
gen lognum = lnfactorial(365)

* calculate the log of the demoninator
gen logden = k * log(365) + lnfactorial(365-k) 

* calculate the probability
gen pr = 1 - exp(lognum - logden)

* scatter plot of the probability and the "class size"
scatter pr k, yline(0.5) xtitle("# Students") ytitle("Prob(at least two share same birthday)")

*** monte carlo simulation 

* prelim 
clear all 

* there are 365 days in a year
set obs 365 

* define a variable for days
gen days = _n 

* very important: before randomization/sampling always define seed
set seed 123456

* define a local 
local counter = 0 

forvalues j = 1/1000 {
	preserve
	* sample with replacement (draw 23 days randomly)
	bsample 23
	* find distinct days 
	distinct days 
	* if no of distinct values < totals obs 
	if `r(ndistinct)' < `r(N)' {
		local counter = `counter' + 1
	}
	restore
}

* what is the probability?
di "Probability " `counter'/1000

*** alternatively, write a small program 

* it is good practice to start with -program drop- so that one is certain 
* that there is no program with the same name that we are defining
program drop mcsim
program define mcsim 
	* prelim 
	clear all 
	* set obs and define days, one for each day in the year 
	set obs 365 
	qui gen days = _n 
	* before randomization/sampling always define seed
	set seed 123456
	* define a local counter 
	local counter = 0 
	* loop over the number of simulations 
	forvalues j = 1/100 {
		preserve
		* sample with replacement 
		qui bsample `1'
		* find distinct days 
		qui distinct days 
		* if no of distinct values < totals obs 
		if `r(ndistinct)' < `r(N)' {
			local counter = `counter' + 1
		}
		restore
	}
di "Probability " `counter'/100
end 

* run the program
mcsim 50 








