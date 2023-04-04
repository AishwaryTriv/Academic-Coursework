* author: aishwary trivedi
*** qss exercise 2.8.1

* prelim 
clear
global path "C:/Users/aishwary/ECON643 Dropbox/Aish Trivedi/umd/econ643"

*************************************************************
/*** 2.8.1 Efficacy of Small Class Size in Early Education ***/
*************************************************************

* read data
use "$path/input/qss-stata-student/causality/STAR.dta", clear

*************************************************************
/*** Answer 1 ***/
*************************************************************

* create a variable label for class type
label define kinder 1 "small" 2 "regular" 3 "regular w/aid"
label values classtype kinder

* recode race variable
recode race (1 = 1) (2 = 2) (4 = 3) (3 5 6 = 4)
label define race 1 "white" 2 "black" 3 "hispanic" 4 "other"
label values race race

*************************************************************
/*** Answer 2 ***/
*************************************************************

* difference in means for reading
tabstat g4reading g4math, by(classtype) stat(mean) f(%9.2fc)

di "Small - regular class reading score : " 723.39-719.89
di "Small - regular class math score : " 709.19-709.52

* note: we have not covered standard deviation so far. 
* you can ignore this part of the question but if you are curious
* difference in means and std dv for reading
* tabstat g4reading g4math, by(classtype) stat(mean sd) f(%9.2fc)

/*
This output shows that students in small classrooms in kindergarten
scored, on average, 3.5 points higher on reading tests in the fourth
grade. However, they scored about 0.33 points lower, on average, in
math compared to students in regular classrooms. Comparing these
estimated effects with the standard deviation of test scores, we
observe that the sizes of the estimated effects are quite small. We
conclude that, on average, small class size in kindergarten did not
substantially increase reading and math test scores in the fourth
grad.
*/

*************************************************************
/*** Answer 3 ***/
*************************************************************

* scores for small classes
centile g4reading g4math if classtype == 1, c(33 66) 

* scores for regular classes
centile g4reading g4math if classtype == 2, c(33 66) 

di "Small - regular class reading score, p33 : " 705-705
di "Small - regular class reading score, p66 : " 741-740

di "Small - regular class math score, p33 : " 694-696
di "Small - regular class math score, p66 : " 726-724

/*
The differences in reading and math scores between students in small
classes and regular classes were very small or nonexistent at the
33rd and 66th percentiles. This analysis therefore confirms the
conclusion of the analysis in the previous question that small class
size in kindergarten did little to increase test scores at the
fourth-grade level.
*/

*************************************************************
/*** Answer 4 ***/
*************************************************************

* number of students of each type
tabulate yearssmall classtype

* contigency table of proportions
* note: -, cell- reports the relative frequency of each cell
tabulate yearssmall classtype, cell nofreq

/*
* note: -, col- reports relative frequency within its column of each cell
* this is not what is being asked for in this question
tabulate yearssmall classtype, col nofreq
*/

* mean reading score across years in small classes
tabstat g4reading g4math, by(yearssmall) statistics(mean) f(%9.2fc)

* median reading score across years in small classes
tabstat g4reading g4math, by(yearssmall) statistics(median) f(%9.2fc)

/*
The contingency table shows that 63% of students were never in the
small classes whereas 14% of them were in the small classes for all
four years. The analysis suggests that, in general, spending all four
years in the small classes increases both reading and math test
scores. The effect is not huge but is of reasonable size. The
analyses based on the mean and median yield similar results.
*/

*************************************************************
/*** Answer 5 ***/
*************************************************************

* racial gap for reading among students in regular classes
recode race (1 = 1) (2 3 = 0) (4 = .), generate(race_white)
label define race_whitelab 1 "White" 0 "Minority"
label value race_white race_whitelab

* racial gap for reading among students in regular classes
tabstat g4reading if classtype == 2 , by(race_white) f(%9.2fc)
di "Racial gap for grade 4 reading scores: " 689.35-725.12

* racial gap for reading among students in regular classes
tabstat g4math if classtype == 2 , by(race_white) f(%9.2fc)
di "Racial gap for grade 4 math scores: " 698.53-711.41

* racial gap for reading among students in regular classes
tabstat g4reading if classtype == 1 , by(race_white) f(%9.2fc)
di "Racial gap for grade 4 reading scores: " 699.28-727.84

* racial gap for reading among students in regular classes
tabstat g4math if classtype == 1 , by(race_white) f(%9.2fc)
di "Racial gap for grade 4 math scores: " 698.22-711.19

* alternative code in two lines
table race_white classtype if classtype != 3, statistic(mean g4reading) nformat(%9.2fc)
table race_white classtype if classtype != 3, statistic(mean g4math) nformat(%9.2fc)

di "Racial gap in diff b/w small-regular class reading score " (699.28-689.35) - (727.84-725.12)
di "Racial gap in diff b/w small-regular class math score " (698.22-698.53) - (711.19-711.41)

/*
Our analysis shows that there is a substantial racial gap. On average,
white students tend to perform better in both reading and math scores
than minority students, regardless of class sizes. However, in terms
of reading test scores, this achievement gap is reduced when students
are assigned to small classes. This suggests that minority students
benefited more from small classes than white students. The same
conclusion, however, does not apply to math scores. The racial
achievement gap is approximately the same size in both regular and
small classes.
*/

*************************************************************
/*** Answer 6 ***/
*************************************************************

* graduation rate by class size and number of years
tabstat hsgrad, by(classtype) f(%9.2fc)
tabstat hsgrad, by(yearssmall) f(%9.2fc)

* racial gap
tabstat hsgrad if classtype == 2 , by(race_white) f(%9.2fc)
tabstat hsgrad if classtype == 1 , by(race_white) f(%9.2fc)

* alternatively, use -table- to summarize data in one line of code
table race_white classtype if classtype != 3, statistic(mean hsgrad) nformat(%9.2fc)

di "Racial gap in diff b/w small-regular graduation rates " (0.74-0.74) - (0.87-0.86)

/*
We observe little difference in graduation rates across students who
were assigned to different class types in kindergarten. However,
those who spent all four years in small classes have a higher
graduation rate than the others. This result is consistent with the
analysis for a previous question where we found spending all four
years in small classes increases the average reading score.

We observe substantial racial gaps in high-school graduation rates
regardless of kindergarten class types. These gaps appear to remain
even when students were assigned to small classes for all four years.
Therefore, the STAR program appears to have little impact in closing
racial gaps of high-school graduation rates.
*/
