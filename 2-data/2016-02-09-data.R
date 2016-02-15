#' ---
#' title: "GGplot Workshop: Session 2, Data (and facets)"
#' author: "Jonas Schöley"
#' date: "February 8th, 2016"
#' output:
#'   github_document
#' ---

#'## Every Variable In Its Own Column

library(ggplot2) # can ya dig it?!

#' **Data structure matters a lot when working with ggplot**. However, once we
#' provided ggplot with nice and tidy data it does a lot by itself. In order for
#' this to work the data needs to be in the right format to begin with: **data
#' needs to be a data frame** and **every variable of interest needs to be a
#' separate column**. Let's explore what that means.

head(WorldPhones)

#' Here's the number of telephone connections over time by continent. The first
#' problem with this data is that it's not a *data frame*, it's a matrix with
#' row and column names. If we try to plot it, well...

#+ error=TRUE
ggplot(WorldPhones)

#' That's easily fixed however
phones <- as.data.frame(WorldPhones)

#' Say we we want to plot the number of telephone connections over time by
#' continent. This implies the following *variables of interest*:
#'
#'   * the number of telephone connections `n`
#'   * the continent `cont`
#'   * the year `year`
#'
#' Problem is, *none* of these variables are explicitly given in our data frame.
#' Of course the data is all there, just not in a format we can use with ggplot.
#' Remember: all we handle in ggplot are names of variables which in turn are
#' columns of a data frame. So the question is how to reshape the data into a
#' form where all the variables of interest are separate columns in the data
#' frame.
#'
#' To reshape we are going to use additional libraries. To follow the code you
#' need to be familiar with
#' [dplyr](https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html)
#' and
#' [tidyr](https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html).

library(tidyr); library(dplyr)

#' The easiest variable to make explicit is the year. It is given as rownames of
#' the data frame. We take the rownames, convert them from character to integer
#' type, and add them as the variable `year` to the data frame.

phones %>%
  mutate(year = as.integer(rownames(.))) -> phones
phones

#' That leaves us with the variables *"number of telephone connections"* and
#' *"continent"* to make explicit. They shall become separate columns in the
#' data frame. With the help of `gather()` we **transform from wide to long
#' format**.

phones %>%
  gather(key = cont, value = n, -year) -> phones
phones

#' What kind of black magic did just happen? *A short primer on wide versus long
#' data format:*
#'
#' Each table has a *wide format* and a long format representation. The
#' information content is the same in both formats. It's the layout that
#' differs.
#'
#' Here's a wide format table containing the explicit variables `Female` and
#' `Male`.

data.frame(Female = 1:2, Male = 3:4) -> wide
wide

#' The same table in long format representation containing the explicit variables
#' `Sex` and `N`.

data.frame(Female = 1:2, Male = 3:4) %>%
  gather(key = Sex, value = N) -> long
long

#' Back to our telephone example. We told the computer to look at all columns
#' apart from `year` and transform them into the columns `cont` and `n`. `cont`
#' holds the continent names for the variable `n`, the number of telephone
#' connections. The continent names are taken from the original column names we
#' *gathered* over.
#'
#' We now can plot our data easily.

ggplot(phones) +
  geom_line(aes(x = year, y = n, colour = cont))

#'## Data Pipelines

#' We can also write everything we did so far as a single *data analysis
#' pipeline*. We start with the raw data and output a plot. This is a great
#' approach for fast, interactive data analysis.
#'
#' This is what we need to know in order to build pipelines:
#'
#' * The object on the left of the pipe operator (`%>%`) is passed onto the
#'   first argument of the function on the right
#' * If we want to use the object on the left in other places than the first
#'   argument we can explicitly refer to it by using a dot (`.`)
#'
#' Here's our telephone example in pipeline form.

# the raw data...
WorldPhones %>%
  # ...is converted to a data frame...
  as.data.frame() %>%
  # ...the rownames are added as the column `year`...
  # (note that I use the dot here to explicitly refer to the input data)
  mutate(year = as.integer(rownames(.))) %>%
  # ...the data gets transformed from wide to long format...
  gather(key = cont, value = n, -year) %>%
  # ...and finally plotted
  # (note that I can pipe the tidy data frame directly into ggplot)
  ggplot() +
  geom_line(aes(x = year, y = n, colour = cont))

#'## Practice, practice, practice...

#' Before we start plotting we need to ask ourselves: *What do we need to do
#' with our data in order to get the plot we want?* Here are some examples.

# we start with raw data...
USArrests %>%
  mutate(
    # ...and add the new variable `state` from the rownames...
    state = rownames(.),
    # ...we then reorder the levels of `state` according to the percentage of
    # people living in urban areas...
    state = reorder(state, UrbanPop)) %>%
  # ...and make a dotplot of the percentage of urban population by state...
  ggplot() +
  geom_point(aes(x = UrbanPop, y = state))

# we start with raw data...
USArrests %>%
  mutate(
    # ...and add the new variable `state` from the rownames...
    state = rownames(.),
    # ...we then reorder the levels of `state` according to the combined
    # murder, assault and crime rates...
    state = reorder(state, Murder+Assault+Rape)) %>%
  # ...we convert to long format, gathering "Assault", "Murder" and "Rape"
  # into "crime"...
  gather(key = crime, value = rate, -state, -UrbanPop) %>%
  # ...and make a dotplot of the crime-rate by crime and state
  ggplot() +
  geom_point(aes(x = rate, y = state, colour = crime))

library(ggrepel) # brilliant package for labelling points in a scatterplot
# we start with raw data...
USArrests %>%
  # ...and add the new variable `state` from the rownames...
  mutate(state = rownames(.)) %>%
  # ...andmake a labelled scatterplot of Murder versus Rape
  ggplot(aes(x = Murder, y = Rape)) +
  geom_text_repel(aes(label = state),
                  colour = "grey",
                  segment.color = "grey",
                  size = 3) +
  geom_point()

#' Can you figure out what happens here? Try running the code yourself line by
#' line.

anscombe %>%
  mutate(id = rownames(.)) %>%
  gather(... = -id) %>%
  separate(key, sep = 1, into = c("axis", "panel")) %>%
  spread(key = axis, value = value) %>%
  ggplot(aes(x = x, y = y)) +
  geom_smooth(method = "lm", se = FALSE) +
  geom_point() +
  facet_wrap(~panel)

#'## Facets

#' **Facets are multiples of the same plot separate by groups in the data**.
#'
#' Without facets everything is plotted into a single panel.

infert %>% mutate(case = ifelse(case == 0, "control", "case")) %>%
  ggplot(aes(x = age, linetype = case, colour = education)) +
  geom_density()

#' After specifying the facetting variable (`~case`) multiple panels are drawn,
#' one for each subgroup in the variable.

infert %>% mutate(case = ifelse(case == 0, "control", "case")) %>%
  ggplot(aes(x = age, linetype = case, colour = education)) +
  geom_density() +
  facet_grid(~case)

#' We can facet over multiple variables.

infert %>% mutate(case = ifelse(case == 0, "control", "case")) %>%
  ggplot(aes(x = age, linetype = case, colour = education)) +
  geom_density() +
  facet_grid(education~case)

#' There are various ways to layout the panels. Variables that should end up as
#' rows are specified on the left of the tilde, columns on the right.

infert %>% mutate(case = ifelse(case == 0, "control", "case")) %>%
  ggplot(aes(x = age, linetype = case, colour = education)) +
  geom_density() +
  facet_grid(case~education)

infert %>% mutate(case = ifelse(case == 0, "control", "case")) %>%
  ggplot(aes(x = age, linetype = case, colour = education)) +
  geom_density() +
  facet_grid(~case + education)

#' By default each panel has identical x and y axis. Most of the time this is
#' what we want because it facilitates comparisons between the different
#' panels. However, we do have the options of letting either x or y or both
#' scales vary freely between panels.

# different x axis by column
infert %>% mutate(case = ifelse(case == 0, "control", "case")) %>%
  ggplot(aes(x = age, linetype = case, colour = education)) +
  geom_density() +
  facet_grid(case~education, scales = "free_x")

# different y axis by row
infert %>% mutate(case = ifelse(case == 0, "control", "case")) %>%
  ggplot(aes(x = age, linetype = case, colour = education)) +
  geom_density() +
  facet_grid(case~education, scales = "free_y")

# different x axis by column; different y axis by row
infert %>% mutate(case = ifelse(case == 0, "control", "case")) %>%
  ggplot(aes(x = age, linetype = case, colour = education)) +
  geom_density() +
  facet_grid(case~education, scales = "free")

#' Up until now we have use `facit_grid`. This is perfect for crosstable-like
#' layouts but does not allow us to specify the number of rows/columns or to
#' have varying scales by panel. We use `facet_wrap` if we want to control the
#' number of rows or columns or if we want separate scales for each panel.

# different x and y axis by panel, 3 columns please
infert %>% mutate(case = ifelse(case == 0, "control", "case")) %>%
  ggplot(aes(x = age, linetype = case, colour = education)) +
  geom_density() +
  facet_wrap(case~education, scales = "free", ncol = 3)

#' We can use specialized functions that change the way our panels are labelled.

# panel labels as variable_name:variable_value
infert %>% mutate(case = ifelse(case == 0, "control", "case")) %>%
  ggplot(aes(x = age, linetype = case, colour = education)) +
  geom_density() +
  facet_wrap(case~education, scales = "free", ncol = 3, labeller = label_both)

#'## Further Reading

#' - [Tidy Data.](http://www.jstatsoft.org/v59/i10/paper) A lot of confusion
#'   about ggplot stems from the data being in an unsuitable format. ggplot
#'   works with what its creator calls *tidy data*.
#' - [An introduction to data transformation with `dplyr`.](https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html)
#'   This covers -- among other things -- data pipelines.
#' - [An introduction to data tidying with `tidyr`.](https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html).
#'   This involves -- among other things -- transforming between long and wide format.
#' - [The data wrangling cheat sheet](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)
#'   is a great quick reference for `dplyr` and `tidyr`.

sessionInfo()

#' cc-by Jonas Schöley 2016
