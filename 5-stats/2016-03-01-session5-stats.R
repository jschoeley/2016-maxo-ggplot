#' ---
#' title: "GGplot Workshop: Session 5, Statistical Transformations"
#' author: "Jonas Schöley"
#' date: "March 1, 2016"
#' output:
#'   github_document:
#'     toc: true
#' ---

library(ggplot2) # ...what else?!
library(dplyr)
library(readr)

#' ggplot regards data transformations as part of the plot itself. Statistical
#' transformations (`stats`) are functions that take your data and output a
#' statistic (e.g. `..count..`, `..density..`...). This statistic is then
#' plotted. **Each geometry comes with a default statistical transformation**,
#' called *stat*. While for some this is just the *identity* transformation
#' (e.g. `geom_point`, `geom_line`, `geom_tile`), others are more involved (e.g.
#' `geom_bar`, `geom_density`, `geom_smooth`). But here's the catch: **You can
#' freely combine statistical transformations and geoms.**
#'
#' Even if we don't plan on messing with statistical transformations in ggplot
#' we need to be aware of the default transformation for the geoms we are using.
#' Otherwise we will be surprised what happens to our data. The help page for
#' each geom shows you the default stat.
#'
#' In the following we will discuss a few usefull statistical transformations
#' and their corresponding geoms.

#'## Stat Count

#' We have this nice collection of diamonds.

diamonds

#' A barchart showing the number of diamonds by different cut qualities is
#' easily done.

ggplot(diamonds) +
  geom_bar(aes(x = cut))

#' Interesting, but where does the variable `count` come from? It is neither in
#' the `diamonds` data frame nor did we specify it in the ggplot call. Clearly
#' ggplot computed it on its own -- it performed a *statistical transformation
#' on our data*.
#'
#' **Each geometry comes with a default `stat`.**
#'
#' For `geom_bar` this is `stat_count`. It takes a categorical variable as input
#' and tabulates it (?geom_bar).

ggplot(diamonds) +
  geom_bar(aes(x = cut, y = ..count../1000))

# the count statistic is calculated separate by facet
ggplot(diamonds) +
  geom_bar(aes(x = cut)) +
  facet_wrap(~clarity)

# this is a solution you see online a lot, proportions on total sum
ggplot(diamonds) +
  geom_bar(aes(x = cut, y = ..count../sum(..count..))) +
  facet_wrap(~clarity)

# proportions on facet sums
ggplot(diamonds) +
  geom_bar(aes(x = cut, y = ..prop.., group = clarity)) +
  facet_wrap(~clarity)

# we can use stat_count with a geom that does not use it by default
ggplot(diamonds) +
  geom_point(aes(x = cut, y = ..prop.., group = clarity),
             stat = "count") +
  facet_wrap(~clarity)

#'## Stat identity

# we want to plot bars but we already tabulated the data
diamonds %>% count(cut) %>%
  ggplot() +
  geom_bar(aes(x = cut, y = n))

diamonds %>% count(cut) %>%
ggplot() +
  geom_bar(aes(x = cut, y = n), stat = "identity")

# we want to plot a density distribution we already have the data for
data_frame(X  = seq(-2, 2, 0.01),
           fX = dnorm(X)) %>%
  ggplot() +
  geom_density(aes(x = X, y = fX))

data_frame(X  = seq(-2, 2, 0.01),
           fX = dnorm(X)) %>%
  ggplot() +
  geom_density(aes(x = X, y = fX), stat = "identity")

#'## 1D summaries

ChickWeight %>%
  ggplot(aes(x = Time, y = weight)) +
  geom_point()

ChickWeight %>%
  ggplot(aes(x = Time, y = weight)) +
  geom_point(stat = "summary", fun.y = median)

ChickWeight %>%
  ggplot(aes(x = Time, y = weight)) +
  geom_point(stat = "summary", fun.y = median) +
  geom_errorbar(stat = "summary", fun.ymax = max, fun.ymin = min)

ChickWeight %>%
  ggplot(aes(x = Time, y = weight)) +
  geom_point(stat = "summary", fun.y = median) +
  geom_errorbar(stat = "summary",
                fun.ymax = function(y) median(y) + sd(y),
                fun.ymin = function(y) median(y) - sd(y))

ChickWeight %>%
  ggplot(aes(x = Time, y = weight, colour = Diet)) +
  geom_point(stat = "summary", fun.y = median) +
  geom_errorbar(stat = "summary",
                fun.ymax = function(y) median(y) + sd(y),
                fun.ymin = function(y) median(y) - sd(y)) +
  geom_line(stat = "summary", fun.y = median) +
  geom_point(stat = "summary", fun.y = mean, shape = 4) +
  facet_wrap(~Diet)

#'## 2D summaries

swe <- read_csv("https://raw.githubusercontent.com/jschoeley/2016-maxo-ggplot/master/4-scales2/mortality_surface_sweden.csv")
swe

swe %>%
  ggplot(aes(x = Year, y = Age)) +
  geom_tile(aes(z = mx, fill = ..value..),
             stat = "summary2d",
             binwidth = c(10, 10),
             fun = sum) +
  coord_equal()

#'## Further Reading

sessionInfo()

#' cc-by Jonas Schöley 2016
