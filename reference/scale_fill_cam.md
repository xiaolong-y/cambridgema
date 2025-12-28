# Cambridge fill scale for ggplot2

Apply Cambridge, MA inspired color palettes to fill aesthetics. See
[`scale_color_cam`](https://xiaolong-y.github.io/cambridgema/reference/scale_color_cam.md)
for details.

## Usage

``` r
scale_fill_cam(
  palette = "spring",
  discrete = TRUE,
  reverse = FALSE,
  na.value = "#5A5A5A",
  ...
)
```

## Arguments

- palette:

  Palette name. Categorical: "spring", "summer", "autumn", "winter",
  "river". Sequential: "crimson_seq", "river_seq", "foliage_seq".
  Diverging: "crimson_blue", "brick_pine".

- discrete:

  Logical, TRUE for discrete scale, FALSE for continuous. Ignored for
  diverging palettes which are always continuous.

- reverse:

  Logical, reverse color order if TRUE

- na.value:

  Color used for missing values. Default is granite gray (#5A5A5A).

- ...:

  Additional arguments passed to ggplot2 scale functions

## Value

ggplot2 scale object

## Examples

``` r
library(ggplot2)

# Bar chart with categorical palette
ggplot(mpg, aes(class, fill = class)) +
  geom_bar() +
  scale_fill_cam("summer") +
  theme(legend.position = "none")


# Heatmap with sequential palette
ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_tile() +
  scale_fill_cam("foliage_seq", discrete = FALSE)


# Correlation matrix with diverging palette
cor_data <- data.frame(
  x = rep(1:3, 3), y = rep(1:3, each = 3),
  r = c(1, 0.5, -0.3, 0.5, 1, 0.8, -0.3, 0.8, 1)
)
ggplot(cor_data, aes(x, y, fill = r)) +
  geom_tile() +
  scale_fill_cam("crimson_blue")
```
