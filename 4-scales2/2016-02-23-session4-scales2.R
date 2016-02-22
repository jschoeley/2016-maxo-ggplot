#' ---
#' title: "GGplot Workshop: Session 4, Scales II"
#' author: "Jonas Schöley"
#' date: "February 23, 2016"
#' output:
#'   github_document:
#'     toc: true
#' ---

library(ggplot2) # the way its done!

library(dplyr)   # data transformation
library(readr)   # read csv directly from the web

#'## Lexis Surfaces in GGplot

#' Lexis surfaces show the value of a third variable on a period-age-grid. If
#' the value of the third variable is given via colour the resulting plot is
#' known as "Heatmap" and used in many disciplines. In ggplot we produce
#' heatmaps using `geom_tile()` or `geom_rect()`. These geometries draw
#' rectangles at specified xy-positions. By default all rectangles are equal in
#' size. They can be coloured according to some variable in the data.
#'
#' `geom_rect()` is faster and produces smaller pdf's, while `geom_tile()`
#' allows to specify the dimensions of the rectangles making it useful for
#' data that does not adhere to a 1 by 1 grid.
#'
#' For now we will ignore the colouring aspect and just look at how ggplot draws
#' rectangles.

#'### 1x1 year data

#' We work with data from the [Human Mortality
#' Database](http://www.mortality.org) -- Swedish period mortality rates by sex.

readr::read_csv("/home/jon/lucile/share/jowncloud/sci/teach/2016-maxo-ggplot/4-scales2/mortality_surface_sweden.csv") -> swe
swe

#' Only specifying x and y position and omitting colour puts a grey rectangle at
#' every xy position that appears in the data. The resulting plot gives us
#' information about the period-ages where we have mortality data on Swedish
#' females.

swe %>% filter(Sex == "Female") %>%
  ggplot() +
  geom_tile(aes(x = Year, y = Age), colour = "white")

#' When constructing Lexis surfaces it is a good idea to use isometric scales.
#' The distance corresponding to a single year should be the same on the x and
#' the y scales (a 1x1 rectangle should actually be a square). We can force such
#' an equality by adding a suitable coordinate layer.

swe %>% filter(Sex == "Female") %>%
  ggplot() +
  geom_tile(aes(x = Year, y = Age)) +
  coord_equal()

#' By default the small rectangles have a width and height of 1 scale unit and
#' are drawn over the mid-points of the corresponding x and y values.

swe %>% filter(Sex == "Female") %>%
  ggplot() +
  geom_tile(aes(x = Year, y = Age), colour = "white") +
  scale_x_continuous(breaks = 1800:1810) +
  scale_y_continuous(breaks = 100:110) +
  coord_equal(xlim = c(1800, 1810), ylim = c(100, 110))

#' Shifting the data by 0.5 in x and y aligns things neatly.

swe %>% filter(Sex == "Female") %>%
  mutate(Year = Year + 0.5, Age = Age + 0.5) %>%
  ggplot() +
  geom_tile(aes(x = Year, y = Age), colour = "white") +
  scale_x_continuous(breaks = 1800:1810) +
  scale_y_continuous(breaks = 100:110) +
  coord_equal(xlim = c(1800, 1810), ylim = c(100, 110))

#'### nxm year data

#' If our data does not come in single year and age groups we have to adjust
#' the `width` and/or `height` of the rectangles. `width` and `height` are
#' regular aesthetics and can be mapped to variables in the data.

readr::read_csv("./lucile/share/jowncloud/sci/teach/2016-maxo-ggplot/4-scales2/cod.csv") -> cod
cod

#' The Cause of Death data features age groups of different sizes (1, 4, or 5
#' years). This is how it looks like if we plot it without any regard to the
#' size of the age groups.

cod %>% filter(Sex == "Female") %>%
  mutate(Year = Year + 0.5) %>%
  ggplot() +
  geom_tile(aes(x = Year, y = Age), colour = "white") +
  coord_equal()

#' Now we shift the rectangles away from the age midpoint and scale them
#' in height according to the width of the age group.

cod %>% filter(Sex == "Female") %>%
  mutate(Year = Year + 0.5, Age = Age + w/2) %>%
  ggplot() +
  geom_tile(aes(x = Year, y = Age, height = w), colour = "white") +
  coord_equal()

#'### Discrete Period and Age Scales

#' If we use discrete axis (happens automatically if we supply a non-numeric
#' variable to the x or y aesthetic) we loose any control over the placement of
#' the groups. They will be equally spaced along the axis.

cod %>% filter(Sex == "Female") %>%
  mutate(Year = Year + 0.5, Age = AgeGr) %>%
  ggplot() +
  geom_tile(aes(x = Year, y = Age), colour = "white") +
  coord_equal()

swe %>%
  mutate(mx_cut = cut(mx, breaks = c(0, 0.0001, 0.001, 0.01, 0.1, Inf))) %>%
  ggplot() +
  geom_raster(aes(x = Year, y = Age, fill = mx_cut)) +
  scale_fill_brewer(type = "seq") +
  facet_grid(~Sex) +
  guides(fill = guide_legend(reverse = TRUE)) +
  coord_equal()

#'## Sequential Colour Scales: Plotting Magnitudes

#' Sequential scales come in

#'## Divergent Colour Scales: Plotting Differences & Proportions

#'## Qualitative Colour Scales: Plotting Group Membership

library(ggplot2) # right on...



#'## Further Reading

#' - [Explore the colorbrewer palette](http://colorbrewer2.org/)

sessionInfo()

#' cc-by Jonas Schöley 2016
