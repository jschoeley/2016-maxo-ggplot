Visualizing Data with ggplot
============================

[Sun-MaxO](http://www.sdu.dk/en/om_sdu/institutter_centre/maxo) is organizing a workshop on **"Visualizing Data with ggplot"**. Everyone interested is invited.

The aim of the course is to empower participants to produce their statistical graphs / visualizations using the `ggplot2` library for the programming language `R`. It is *not* a crash-course. Participants get to know `ggplot` from the ground up so that they can use it effectively.

There will be **5 sessions á 90 minutes starting on Tuesday, February the 2nd**. The course will take place at **Max-O, J.B. Winsløws Vej 9B**.

I assume some very basic `R` knowledge. Participants are encouraged to bring a notebook with an `R` installation on it. I will use `R version 3.2.2` and `ggplot2 version 2.0.0`.

I gave this course in 2015 to students of the [EDSD](www.eds-demography.org) in Warsaw. You can find the old course notes [here](https://github.com/jschoeley/2015-edsd-ggplot).

-- [Jonas Schöley](http://findresearcher.sdu.dk/portal/en/person/jschoeley)

Curriculum
----------

**02.02. 14:00-15:30 -- Introduction**

- introducing ggplot and its underlying idea: the grammar of graphics
- basic plots in ggplot
- *geometries* and *aesthetics*

**09.02. 14:00-15:30 -- Data**

- the importance of *data* structure
- long versus wide format data
- introducing tidy data
- getting data into tidy format using `dplyr` and `tidyr`
- introducing *facets*

**16.02. 14:00-15:30 -- Scales I**

- introducing *scales*
- changing scale attributes:
    * name
    * limits
    * breaks
    * labels
    * arithmetic transformation
    * ...
- adjusting the *coordinate* system
    * zooming into the plot
    * flipping the axes
    * setting the aspect ratio
    * polar coordinates

**23.02. 14:00-15:30 -- Scales II**

- colour scales (qualitative, sequential, divergent)
- continuous versus discrete colour scales
- heatmaps / Lexis surface maps

**01.03. 14:00-15:30 -- Statistics**

- introducing *statistical* transformations
- using non-default statistics with a geom
- writing and using your own transformations