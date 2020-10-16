---
title: "Life cycle"
author: "Thierry Gosselin"
date: "2020-10-15"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Life cycle}
  %\VignetteEngine{knitr::knitr}
  %\VignetteEncoding{UTF-8}
---



radiator is maturing, but in order to make the package better, changes are 
inevitable. Experimental functions will change, argument names will change.


Below an example of recent changes that are all documented in [NEWS and changelog](https://thierrygosselin.github.io/radiator/news/index.html).


**DArT users**: 

* `filter_dart`: is now deprecated. Please use `filter_rad`.
* `tidy_dart` and `tidy_silico_dart`: are now deprecated. 
Please use `read_dart` for all the 4 DArT files recognized by radiator.

**Missing data: visualization and imputations**

Visualizing missing data and it's imputations requires special attention that fall 
outside the scope of **radiator**. 
Inside my package called [grur](https://github.com/thierrygosselin/grur), users
can **visualize patterns of missingness** associated with different variables 
(lanes, chips, sequencers, populations, sample sites, reads/samples, homozygosity, etc).
Several **Map-independent imputations** of missing genotypes are available:
**Random Forests** (on-the-fly-imputations or predictive modeling), 
**Extreme Gradient Tree Boosting**, 
Strawman imputations (~ max/mean/mode: the most frequently observed, non-missing genotypes is used).
Imputations can be conducted **overall samples** or **by populations/strata/grouping**.
`radiator::genomic_converter` is integrated with the imputation function of **grur**.
