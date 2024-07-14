/* Import wide dataset using GUI _ data preprocessed in R */

/* Missing data pattern - the code below is modified to use the missing data approach */
data df2;
    set new_df_summarised;
    array all_vars(*) _numeric_;
    do i = 1 to dim(all_vars);
        if all_vars(i) = 0 then all_vars(i) = .; /* Replace 0 with missing */
        else if all_vars(i) = 1 then all_vars(i) = rand("UNIFORM", 0.1, 0.2); /* Assign random number */
    end;
    drop i;
run;

proc mi data=df2 nimpute=0;
    var IndWeight Nicotine Alcohol Diabetes COPD Hypertension Myocardial Kidney;
run;

/* Run the code below for all the datasets, one at a time and store the results. The dataset was generated */

/* Keep changing the datasets i.e. df_subset_long_part_1 - df_subset_long_part_10 */
data df_subset_long_part_1;
    set df_subset_long;
    where dataset = 1;
run;

ods output FitStatistics=fitstats1
           Tests3=Type3Tests1 
           ParameterEstimates=ParameterEstimates1 
           CovParms=CovParms1;

proc glimmix data=df_subset_long_part_1 empirical;
    class CODE_AGR A2_CODE_SEX(ref='Male') age_group(ref='18-30') loshos_group(ref='0-1') indicator;
    model response(event='1') = A2_CODE_SEX*indicator age_group*indicator loshos_group*indicator / noint;
    nloptions tech=nrridg maxiter=50;
    random _RESIDUAL_ / subject=CODE_AGR type=CS;
run;

ods output close;
