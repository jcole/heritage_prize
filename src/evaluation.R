# To get an array of values indicating the error for each item in set
# example usage:  test$error <- item_error(test$predicted_days, test$actual_days_y2)
item_error <- function(predicted_values, actual_values) {
 sqrt((log(predicted_values + 1) - log(actual_values + 1)) ^2)
}

# To get overall error scoring number for the entire test set;
# example usage: total_error <- hpp_error(test$predicted_days, test$actual_days_y2)
total_error <- function(predicted_values, actual_values) {
 sqrt(mean((log(predicted_values + 1) - log(actual_values + 1)) ^2))
}

# Ways to investigate model error:
# histogram of error, by actual days:
#   library(ggplot2)
#   test$error <- item_error(test$predicted_days, test$actual_days_y2)
#   e <- ddply(test, .(actual_days_y2), summarize, total_error=sum(error))
#   ggplot(data=e, aes(x=actual_days_y2, y=total_error)) + geom_point()
# distribution of error values for a given atual value, X:
#    ex <- test[test$actual_days_y2==0,]$predicted_days
#    table(cut(ex, 10))
#    plot(table(cut(ex, 10)))