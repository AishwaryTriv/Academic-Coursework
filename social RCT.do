* author: aishwary trivedi
clear
global path "C:/Users/aishwary/ECON643 Dropbox/Aish Trivedi/umd/econ643"

* read data
use "$path/input/qss-stata-student/CAUSALITY/social.dta", clear 

* avg turnout in 2006 after the intervention
tabstat primary2006, by(messages) stat(mean N) f(%9.2gc)

*** using regression to estimate treatment effects
*** assume there are only two treatment groups
*** the following line is just use to simplify the dataset 
keep if inlist(messages, "Neighbors", "Civic Duty", "Control") == 1

* verify that the experiment only has 2 treatment arms and 1 control group
tab messages


* define a new categorical variable that takes the value 0 for control group
gen messages_num = 0 
replace messages_num = 1 if messages == "Neighbors"
replace messages_num = 2 if messages == "Civic Duty"


* since treatment status is a dummy variable we can use i. as well
eststo m1: regress primary2006 i.messages_num 
di "ATE for peer pressure is " _b[1.messages_num] " percentage points."
di "ATE for civic duty is " _b[2.messages_num] " percentage points."

* specifying the base level of a factor variable using ib.
eststo m2: regress primary2006 ib2.messages_enc
di "ATE for peer pressure is " _b[3.messages_enc] " percentage points."
di "ATE for civic duty is " _b[1.messages_enc] " percentage points."

* define interaction term with treatment
gen peerXprimary2004 = primary2004*peer

* regress outcome on treatment status, z and treatment*z
eststo m3: regress primary2006 peer primary2004 peerXprimary2004

* alternatively
* regress outcome on treatment status, z and treatment*z
* eststo m4: regress primary2006 i.peer i.primary2004 i.peer#i.primary2004

* compare results
esttab m1 m2 m3, se 



