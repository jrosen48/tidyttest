
<!-- README.md is generated from README.Rmd. Please edit that file -->
tidyttest
=========

The goal of tidyttest is to make a t-test function that:

-   Can be used as part of a "pipeline"
-   Is easy to use programattically (i.e., as part of a function from the `apply()` and `purrr::map()` families)

Installation
------------

You can install tidyttest from github with:

``` r
# install.packages("devtools")
devtools::install_github("jrosen48/tidyttest")
```

Example
-------

This is a basic example which shows you how to use the `t_test()` function:

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(tidyttest)

storms %>% 
    filter(status %in% c("tropical depression", "tropical storm")) %>% 
    mutate(category = as.integer(category)) %>% 
    t_test(category, status)
#> [1] "mean in group tropical depression  is  1"
#> [1] "mean in group tropical storm  is  2"
#> [1] "Test statistic is  -4375"
#> [1] "P-value is  0"
#> [1] "Effect size is  -109.07"
```

It outputs a `data.frame`:

``` r

storms_ss <- storms %>% 
    filter(status %in% c("tropical depression", "tropical storm")) %>% 
    mutate(category = as.integer(category))

t_test_df <- t_test(storms_ss, category, status)
#> [1] "mean in group tropical depression  is  1"
#> [1] "mean in group tropical storm  is  2"
#> [1] "Test statistic is  -4375"
#> [1] "P-value is  0"
#> [1] "Effect size is  -109.07"
t_test_df
#> # A tibble: 1 x 5
#>   group_1_mean group_2_mean test_statistic p_value effect_size
#>          <dbl>        <dbl>          <dbl>   <dbl>       <dbl>
#> 1            1            2          -4375       0     -109.07
```
