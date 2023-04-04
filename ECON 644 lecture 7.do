clear all
set seed

* question 1
collapse (first) CountryCode if wbregion!=., by(country)
count
save "/Users/aishwarytrivedi/Downloads/ECON 644 lecture 7a.dta"

* question 2
use "/Users/aishwarytrivedi/Downloads/StataPractice03-5-7-8.dta"
keep if year ==1960
keep country TFR
rename TFR TFR1960
count if TFR1960!=.
kdensity TFR1960

save "/Users/aishwarytrivedi/Downloads/ECON 644 lecture 7b.dta"

* question 3
use "/Users/aishwarytrivedi/Downloads/StataPractice03-5-7-8 .dta"
keep if year ==2013
keep country TFR
rename TFR TFR2013
count if TFR2013!=.
kdensity TFR2013

save "/Users/aishwarytrivedi/Downloads/ECON 644 lecture 7c.dta"

* question 4
use "/Users/aishwarytrivedi/Downloads/StataPractice03-5-7-8 .dta"
gen realfund = FPP_total_percapita/CPI_2005
count if realfund!=.
keep if year>1969 & year<2000
collapse realfund, by(country)

*if you dont put realfund in parenthesis then it will take average

count if realfund!=.
kdensity realfund
save "/Users/aishwarytrivedi/Downloads/ECON 644 lecture 7d.dta"

*question 5
use "/Users/aishwarytrivedi/Downloads/StataPractice03-5-7-8 .dta"
count if prog_effort_score!=.
keep if year>1969 & year<2000
collapse prog_effort_score, by(country)
ren prog_effort_score effort
kdensity effort
save "/Users/aishwarytrivedi/Downloads/ECON 644 lecture 7e.dta"

* question 6
use "/Users/aishwarytrivedi/Downloads/StataPractice03-5-7-8 .dta"
keep if year <2005
count if exposure_FP!=.
sort country year
collapse (first) exposure_FP if exposure_FP!=., by(country)
count if exposure_FP!=.
kdensity exposure_FP
save "/Users/aishwarytrivedi/Downloads/ECON 644 lecture 7f.dta"

* question 7
use "/Users/aishwarytrivedi/Downloads/ECON 644 lecture 7a.dta"
merge 1:1 country using "/Users/aishwarytrivedi/Downloads/ECON644 lecture 7b.dta"
keep if _merge==3 | _merge==1
drop _merge
merge 1:1 country using "/Users/aishwarytrivedi/Downloads/ECON 644 lecture 7c.dta"
keep if _merge==3 | _merge==1
drop _merge

merge 1:1 country using "/Users/aishwarytrivedi/Downloads/ECON 644 lecture 7d.dta"
keep if _merge==3 | _merge==1
drop _merge

merge 1:1 country using "/Users/aishwarytrivedi/Downloads/ECON 644 lecture 7e.dta"
keep if _merge==3 | _merge==1
drop _merge

merge 1:1 country using "/Users/aishwarytrivedi/Downloads/ECON 644 lecture 7f.dta"
keep if _merge==3 | _merge==1
drop _merge

* question 8
gen TFRchange = TFR2013 - TFR1960


*QUESTION 9
gen TFRper = TFRchange*100/TFR1960

* question 10
gen lrealfund = ln(realfund)


* question 11
* Table 3
reg TFRchange lrealfund, vce(r)
est sto m1
reg TFRper lrealfund, vce(r)
est sto m2
esttab m1 m2, b se stats(N r3)
