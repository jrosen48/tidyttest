#' R function to perform a "tidy" t-test
#' @details R function to compare two means using a t-test; returns the group means, test statistic and associated p-value, and effect size (Cohen's D).
#' @param df data frame with the dependent and group variable
#' @param dv raw (unquoted) name of the dependent variable
#' @param group raw (unquoted) name of the grouping variable
#' @return A data frame containing the group means, test statistic and associated p-value, and effect size (Cohen's D)
#' @examples
#' storms %>%
#'     filter(status %in% c("tropical depression", "tropical storm")) %>%
#'     mutate(category = as.integer(category)) %>%
#'     t_test(dv = category, group = status)
#' storms_ss <- storms %>%
#'     filter(status %in% c("tropical depression", "tropical storm")) %>%
#'     mutate(category = as.integer(category))
#'
#' t_test_df <- t_test(storms_ss, dv = category)
#' t_test_df
#' @export

t_test <- function(df, dv, group) {

    dv_q <- as.character(substitute(dv))
    group_q <- as.character(substitute(group))

    dv_enquo <- dplyr::enquo(dv)
    group_enquo <- dplyr::enquo(group)

    the_formula <- stats::as.formula(paste(dv_q, " ~ ", group_q))
    test_results <- stats::t.test(the_formula, data = df)

    print(paste(names(test_results$estimate[1]), " is ", round(test_results$estimate[1], 3)))
    print(paste(names(test_results$estimate[2]), " is ", round(test_results$estimate[2], 3)))

    print(paste("Test statistic is ", round(test_results$statistic, 3)))
    print(paste("P-value is ", round(test_results$p.value, 3)))

    the_ns <- dplyr::count(df, !! group_enquo)
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
