This repo contains code and data for predicating the 2019 Canadian Federal Election result if "everyone" had voted. It was created by Wen Wang. The purpose is to create a report that summarises the results of the MRP technique I applied. I detail how to get the data below. The section of this repo are: inputs, outpus, scirpts.

Inputs contain data that are unchanged from their original. I use two datasets:

-[CES Survey data - download from https://hodgettsp.github.io/cesR/]

-[GSS census data - detail how to get this is in scripts/census_data.R]

Outputs contain data that are modified from the input data, the repo and supporting material. These are:

-[survey_data.csv - the cleaned CES survey data]

-[census_data.csv - the cleaned GSS census data]

Scripts contain R scripts that take inputs and outputs and produce outputs, Rmarkdown file that generates the final report and the file for the references. These are:

-[survey_data.R - produce survey_data.csv in outputs]

-[census_data.R - produce census_data.csv in outputs]

-[2019_Canadian_Federal_Election_Result_If_Everyone_Had_Voted.rmd - generate final report]

-[references.bib - contain references]

