#' ---
#' title: "GGplot Workshop: Session 3, Scales I"
#' author: "Jonas Schöley"
#' date: "February 16th, 2016"
#' output:
#'   github_document:
#'     toc: true
#' ---

library(ggplot2) # right on!
library(dplyr)   # data transformation

#'## Scales (Versus Aesthetics)
#'
#' Interactive plots displayed in a web-browser are all the rage nowadays with
#' [Gapminder World](http://www.gapminder.org/world) being a true classic of
#' the genre.
#'
#' ![Gapminder World](./fig/gapminder_world.png)
#'
#' Today we shall recreate the above chart and in doing so learn about
#' *scales*.
#'
#' We already know that *aesthetics* are mappings from data dimensions to
#' visual properties. They tell ggplot what goes where. What are the
#' aesthetics in **Gapminder World**?
#'
#' Data dimension       Visual property                                  Scale
#' -------------------  -----------------------------------------------  -----------
#' GDP per capita       position on x-axis (`x`)                         `scale_x_*`
#' Life expectancy      position on y-axis (`y`)                         `scale_y_*`
#' Population size      size of plotting symbols (`size`)                `scale_size_*`
#' Geographical Region  colour of plotting symbols (`colour`)            `scale_colour_*`
#'
#' **Each aesthetic has its own scale**
#'
#' The four aesthetics in *Gapminder World* are connected to four different scales.
#' The scales are named after the corresponding aesthetic. The naming scheme is
#' `scale_<name of aestetic>_<continuous|discrete|specialized>`.
#'
#' **Aestetics specify the _what_, scales specify the _how_**
#'
#' Which colour to use for which level in the data? Where to put the labels on
#' the axis? Which labels to put? The size of the largest plotting symbol, the
#' name of the legends, log-transformation of the y-axis, the range of the
#' axis... These are all examples of scale specifications -- specifications on
#' *how* to map a data dimension to a visual attribute.
#'
#' Off to work!

library("gapminder") # provides us with the data of the *Gapminder World* chart

head(gapminder)

#' The data already looks tidy. All we have to do is to subset to a single year.
#' Let's see what ggplot produces if we simply specify the aesthetics to an
#' appropriate geometry.

gapminder %>% filter(year == 2007) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp, size = pop, colour = continent)) +
  geom_point()

#' A solid foundation. But to close in on the *Gapminder World* chart we need to
#' customize our scales.
#'
#' **When changing scale attributes we have to make sure to make the changes on
#' the appropriate scale**. Just ask yourself:
#'
#' 1) What aesthetic does the scale correspond to? `scale_<name of aestetic>_*`
#' 2) Am I dealing with a *discrete* or *continuous* variable?
#' `scale_*_<continuous|discrete>`
#'
#'## Scale Names

#' Once you know which scales to use, names are trivial to change.

gapminder %>% filter(year == 2007) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp, size = pop, colour = continent)) +
  geom_point() +
  scale_x_continuous(name = "Income per person (GDP/capita, PPP$ inflation-adjusted)") +
  scale_y_continuous(name = "Life expectancy (years)") +
  scale_color_discrete(name = "Continent") +
  scale_size_continuous(name = "Population, total")

#' You can also use mathematical annotation in your scale names. For further
#' information consult `?plotmath`.

gapminder %>% filter(year == 2007) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp, size = pop, colour = continent)) +
  geom_point() +
  scale_x_continuous(name = expression(over(GDP, capita))) +
  scale_y_continuous(name = expression(e[0])) +
  scale_color_discrete(name = "Continent") +
  scale_size_continuous(name = "Population, total")

#'## Scale Transformations

#' Next, we deal with *scale transformations*. In **Gapminder World** the x-axis is
#' log-scaled meaning that the log of the x-axis data is taken before plotting.
#' However, the labels remain on the linear scale. In that regard transforming
#' scales is different from directly transforming the underlying data.

gapminder %>% filter(year == 2007) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp, size = pop, colour = continent)) +
  geom_point() +
  scale_x_continuous(name = "Income per person (GDP/capita, PPP$ inflation-adjusted)",
                     trans = "log10") +
  scale_y_continuous(name = "Life expectancy (years)") +
  scale_color_discrete(name = "Continent") +
  scale_size_continuous(name = "Population, total")

#' There are many different scale transformations built into ggplot. From the
#' documentation:
#'
#' > Built-in transformations include "asn", "atanh", "boxcox",
#' > "exp", "identity", "log", "log10", "log1p", "log2", "logit", "probability",
#' > "probit", "reciprocal", "reverse" and "sqrt".

gapminder %>% filter(year == 2007) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp, size = pop, colour = continent)) +
  geom_point() +
  scale_x_continuous(name = "Income per person (GDP/capita, PPP$ inflation-adjusted)",
                     trans = "reverse") +
  scale_y_continuous(name = "Life expectancy (years)") +
  scale_color_discrete(name = "Continent") +
  scale_size_continuous(name = "Population, total")

#' Note that the concept of scale transformations is not limited to position scales.

gapminder %>% filter(year == 2007) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp, size = pop, colour = continent)) +
  geom_point() +
  scale_x_continuous(name = "Income per person (GDP/capita, PPP$ inflation-adjusted)",
                     trans = "log10") +
  scale_y_continuous(name = "Life expectancy (years)") +
  scale_color_discrete(name = "Continent") +
  scale_size_continuous(name = "Population, total", trans = "log10")

#'## Scale Breaks and Labels

#' Next, we manually specify the axis *breaks* and *labels* to be the same as in
#' *Gapminder World*. Axis breaks are the positions where tick-marks and grid-lines
#' are drawn. Labels specify what text to put at the breaks. **Breaks and labels
#' have to be vectors of equal length.**

gapminder %>% filter(year == 2007) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp, size = pop, colour = continent)) +
  geom_point() +
  scale_x_continuous(name = "Income per person (GDP/capita, PPP$ inflation-adjusted)",
                     trans = "log10",
                     breaks = c(200, 300, 400, 500,
                                600, 700, 800, 900,
                                1000, 2000, 3000, 4000, 5000,
                                6000, 7000, 8000, 9000,
                                10000, 20000, 30000, 40000, 50000,
                                60000, 70000, 80000, 90000),
                     labels = c("200", "", "400", "",
                                "", "", "", "",
                                "1000", "2000", "", "4000", "",
                                "", "", "", "",
                                "10000", "20000", "", "40000", "",
                                "", "", "", "")) +
  scale_y_continuous(name = "Life expectancy (years)",
                     breaks = c(25, 30, 35, 40, 45, 50,
                                55, 60, 65, 70, 75, 80, 85)) +
  scale_color_discrete(name  = "Continent") +
  scale_size_continuous(name = "Population, total")

#' OK, that was effective but clumsy. Luckily ggplot does not care *how* we
#' generate the vector of breaks. We can use any R function as long as it
#' outputs a vector. Even better, instead of manually spelling out the labels
#' for each break we can write a short function that takes the breaks as input
#' and formats them. Much nicer code -- same result.

gapminder %>% filter(year == 2007) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp, size = pop, colour = continent)) +
  geom_point() +
  scale_x_continuous(name = "Income per person (GDP/capita, PPP$ inflation-adjusted)",
                     trans = "log10",
                     breaks = apply(expand.grid(1:9, 10^(2:4)), 1, FUN = prod)[-1],
                     labels = function(x) {ifelse(grepl("^[124]", x), x, "")}) +
  scale_y_continuous(name = "Life expectancy (years)",
                     breaks = seq(25, 85, 5)) +
  scale_color_discrete(name = "Continent") +
  scale_size_continuous(name = "Population, total")

#' The concept of *breaks* and *labels* does not only apply to continuous axis.
#' **All scales have breaks and labels**. E.g. on a colour scale the breaks are
#' the colour keys, the labels are -- well -- the labels. **We reorder the items
#' on our discrete scale by specifying the breaks in the required order.**
#' We also use an R function to capitalize the labels.

gapminder %>% filter(year == 2007) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp, size = pop, colour = continent)) +
  geom_point() +
  scale_x_continuous(name = "Income per person (GDP/capita, PPP$ inflation-adjusted)",
                     trans = "log10",
                     breaks = apply(expand.grid(1:9, 10^(2:4)), 1, FUN = prod)[-1],
                     labels = function(x) ifelse(grepl("^[124]", x), x, "")) +
  scale_y_continuous(name = "Life expectancy (years)",
                     breaks = seq(25, 85, 5)) +
  scale_color_discrete(name = "Continent",
                       breaks = c("Asia", "Africa", "Americas", "Europe", "Oceania"),
                       labels = toupper) +
  scale_size_continuous(name = "Population, total")

#' Finally, let's choose some sensible breaks and labels for the size scale.

gapminder %>% filter(year == 2007) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp, size = pop, colour = continent)) +
  geom_point() +
  scale_x_continuous(name = "Income per person (GDP/capita, PPP$ inflation-adjusted)",
                     trans = "log10",
                     breaks = apply(expand.grid(1:9, 10^(2:4)), 1, FUN = prod)[-1],
                     labels = function(x) ifelse(grepl("^[124]", x), x, "")) +
  scale_y_continuous(name = "Life expectancy (years)",
                     breaks = seq(25, 85, 5)) +
  scale_color_discrete(name = "Continent",
                       breaks = c("Asia", "Africa", "Americas", "Europe", "Oceania"),
                       labels = toupper) +
  scale_size_continuous(name = "Population, total",
                        breaks = c(1E6, 10E6, 100E6, 1E9),
                        labels = function(x) format(x, big.mark = ",", scientific = FALSE))

#'### Sidenote: Levels and Order in ggplot

#' It is easy to order items on a numerical scale. One just puts them on the
#' number line. Usually low on the left and hight to the right. But what about
#' discrete items? ggplot orders them according to the order of their factor
#' levels. An example:

# test data
foo <- data.frame(id  = 1:4,
                  sex = c("Female", "Female", "Male", "Male"))
foo

#' `data.frame`, just like ggplot, automatically converts a character vector to
#' a factor using `as.factor`. The levels order of that factor follows the
#' sequence of occurence in the data.
levels(foo$sex)

#' ggplot constructs discrete scales in the order of the levels of the
#' underlying factor variable. Here, Females first, males after.
ggplot(foo) +
  geom_point(aes(x = sex, y = id, color = sex))

#' If we reverse the level order of the sex variable we change the way ggplot
#' orders the discrete items.
foo$sex
foo$sex <- factor(foo$sex, levels = c("Male", "Female"))
foo$sex

#' Now we have males first and females last.
ggplot(foo) +
  geom_point(aes(x = sex, y = id, color = sex))
ggplot(foo) +
  geom_point(aes(x = sex, y = id, color = sex)) +
  facet_wrap(~sex)

#' **NEVER OVERRIDE THE LEVELS DIRECTLY WHEN JUST MEANING TO CHANGE THE ORDER!**
#' You'll screw up your data. In our case we just changed the sex of the
#' participants.
foo$sex
levels(foo$sex) <- c("Female", "Male")
foo$sex

#'## Scale Limits

#' We match the maximum and minimum value of our xy-scales with those of the
#' *Gapminder World* chart by specifying the *limits* of the scales.

gapminder %>% filter(year == 2007) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp, size = pop, colour = continent)) +
  geom_point() +
  scale_x_continuous(name = "Income per person (GDP/capita, PPP$ inflation-adjusted)",
                     trans = "log10",
                     breaks = apply(expand.grid(1:9, 10^(2:4)), 1, FUN = prod)[-1],
                     labels = function(x) ifelse(grepl("^[124]", x), x, ""),
                     limits = c(200, 90000)) +
  scale_y_continuous(name = "Life expectancy (years)",
                     breaks = seq(25, 85, 5),
                     limits = c(25, 85)) +
  scale_color_discrete(name = "Continent",
                       breaks = c("Asia", "Africa", "Americas", "Europe", "Oceania"),
                       labels = toupper) +
  scale_size_continuous(name = "Population, total",
                        breaks = c(1E6, 10E6, 100E6, 1E9),
                        labels = function(x) format(x, big.mark = ",", scientific = FALSE))


#'### Sidenote: Limiting versus Zooming

#' Note that values outside of the limits will be discarded. This is of
#' importance if you want to zoom into a plot. Here we "zoom" by changing the
#' limits of the scales...

gapminder %>% filter(year == 2007) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(size = 20) +
  scale_x_continuous(limits = c(5000, 20000)) +
  scale_y_continuous(limits = c(70, 80))

#' ...and here we zoom by changing the limits of the coordinate system

gapminder %>% filter(year == 2007) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(size = 20) +
  coord_cartesian(xlim = c(5000, 20000), ylim = c(70, 80))

#'## And they say every ggplot looks the same

#' As always, something to chew on for the hypermotivated...

gapminder %>% filter(year == 2007) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp, size = pop, fill = continent)) +
  annotate(geom = "text", x = 4000, y = 55, label = 2007,
           colour = "#D3E0E6", size = 50, fontface = "bold") +
  geom_point(colour = "black", shape = 21) +
  scale_x_continuous(name = "Income per person (GDP/capita, PPP$ inflation-adjusted)",
                     trans = "log10",
                     breaks = apply(expand.grid(1:9, 10^(2:4)), 1, FUN = prod)[-1],
                     labels = function(x) ifelse(grepl("^[124]", x), x, ""),
                     limits = c(200, 90000)) +
  scale_y_continuous(name = "Life expectancy (years)",
                     breaks = seq(25, 85, 5),
                     limits = c(25, 85)) +
  scale_fill_manual(name = "Continent",
                    breaks = c("Asia", "Africa", "Americas", "Europe", "Oceania"),
                    labels = toupper,
                    values = c("Asia" = "#2FFF7F",
                               "Africa" = "#FFFF2F",
                               "Americas" = "#FF2F2F",
                               "Europe" = "#3F4FFF",
                               "Oceania" = "white")) +
  scale_size_area(name = "Population, total", max_size = 20,
                  breaks = c(1E6, 10E6, 100E6, 1E9),
                  labels = function(x) format(x, big.mark = ",", scientific = FALSE)) +
  guides(fill = guide_legend(order = 1,
                             override.aes = list(shape = 22, size = 8))) +
  theme_bw() +
  theme(plot.background = element_rect(fill = "#CEDCE3"),
        text = element_text(colour = "#47576B"),
        axis.title = element_text(face = "bold"),
        legend.background = element_rect(fill = "#B5CBD5"),
        legend.key = element_blank())

#'## Further Reading

#' - [The ggplot documentation](http://docs.ggplot2.org/current/) contains
#'   all the information about different scales and their options along
#'   with illustrated examples.
#'  - [Adding themes to your plot](http://docs.ggplot2.org/dev/vignettes/themes.html)

sessionInfo()

#' cc-by Jonas Schöley 2016
