# Generating dumbbell plots with R

Initially I was using the package ggalt, but I believed it was better to flip coordinates so I could show data from left to right in a more natural way. I couldn't make that quite quickly with ggalt so I changed my approach to use geom_segment from ggplot2 and it worked pretty well.

In here, you'll also find:
* Text annotations with arrows
* Changing the position of the legend
* Expanding the plot beyond x and y original coordinates
* Changing other aesthetics of the theme
* Adding color to the segments of geom_segment to show positive/negative variation from one year to another

Not one single thing here is super complex, but it took quite some time to get to this point, so it was a good practice in ggplot.

If you are here for some reason, thanks for reading!
