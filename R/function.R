t_test <- function(dv, fac, df) {

    dv_q <- as.character(substitute(dv))
    fac_q <- as.character(substitute(fac))

    dv_enquo <- enquo(dv)
    fac_enquo <- enquo(fac)

    the_formula <- as.formula(paste(dv_q, " ~ ", fac_q))
    test_results <- stats::t.test(the_formula, data = df)

    print(paste(names(test_results$estimate[1]), " is ", round(test_results$estimate[1], 3)))
    print(paste(names(test_results$estimate[2]), " is ", round(test_results$estimate[2], 3)))

    print(paste("Test statistic is ", round(test_results$statistic, 3)))
    print(paste("P-value is ", round(test_results$p.value, 3)))

    the_ns <- dplyr::count(df, !! fac_enquo)
    the_ns <- dplyr::pull(the_ns, n)

    effect_size_results <- compute.es::tes(test_results$statistic,
                                           n.1 = the_ns[1],
                                           n.2 = the_ns[2],
                                           verbose = F)

    print(paste("Effect size is ", effect_size_results$d))

    out <- dplyr::data_frame(group_1_mean = round(test_results$estimate[1], 3),
                             group_2_mean = round(test_results$estimate[2], 3),
                             test_statistic = round(test_results$statistic, 3),
                             p_value = round(test_results$p.value, 3),
                             effect_size = effect_size_results$d)

    invisible(out)

}
