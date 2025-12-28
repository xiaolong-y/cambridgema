# Getting Started with cambridgema

## Introduction

The **cambridgema** package provides colorblind-friendly color palettes
inspired by the flora and seasons of Cambridge, Massachusetts. All
palettes are verified for accessibility under deuteranopia, protanopia,
and tritanopia.

``` r
library(cambridgema)
library(ggplot2)
```

## Available Palettes

The package includes three types of palettes:

- **Categorical** (5 colors): `spring`, `summer`, `autumn`, `winter`,
  `river`
- **Sequential** (7 colors): `crimson_seq`, `river_seq`, `foliage_seq`
- **Diverging** (9 colors): `crimson_blue`, `brick_pine`

``` r
list_palettes()
#> $categorical
#> [1] "spring" "summer" "autumn" "winter" "river" 
#> 
#> $sequential
#> [1] "crimson_seq" "river_seq"   "foliage_seq"
#> 
#> $diverging
#> [1] "crimson_blue" "brick_pine"
```

## Viewing Palettes

Use
[`plot_cam_demo()`](https://xiaolong-y.github.io/cambridgema/reference/plot_cam_demo.md)
to see all palettes:

``` r
plot_cam_demo()
```

![](getting-started_files/figure-html/demo-1.png)

Or view details of a specific palette:

``` r
print_palette("autumn")
#> Palette: autumn 
#> Colors: 5 
#> Type: categorical 
#> 
#>    1. aster_purple         #6A4FB3
#>    2. goldenrod            #D4A017
#>    3. maple_scarlet        #C0392B
#>    4. maple_orange         #E07020
#>    5. oak_brown            #6B4423
```

## Basic Usage

### Access Individual Colors

The `cam_colors` vector contains all 50+ named colors:

``` r
# Access specific colors
cam_colors["maple_red"]
#> maple_red 
#> "#B70E2B"
cam_colors[c("spring_blossom", "charles_blue", "goldenrod")]
#> spring_blossom   charles_blue      goldenrod 
#>      "#E8B4BC"      "#2E6FBE"      "#D4A017"
```

### Get n Colors from a Palette

Use
[`cam_cols()`](https://xiaolong-y.github.io/cambridgema/reference/cam_cols.md)
to get exactly n colors:

``` r
# Get 5 autumn colors
cam_cols(5, "autumn")
#> [1] "#6A4FB3" "#D4A017" "#C0392B" "#E07020" "#6B4423"

# Get 10 colors (interpolated if palette has fewer)
cam_cols(10, "river_seq")
#>  [1] "#F0F7FC" "#DDEDF7" "#C5DDF0" "#A7C7E7" "#7FAFDB" "#5691CE" "#2E6FBE"
#>  [8] "#205996" "#154370" "#0D2E4D"
```

### Base R Plotting

``` r
barplot(c(3, 7, 9, 6, 2),
        col = cam_cols(5, "autumn"),
        main = "Autumn in Cambridge",
        names.arg = c("A", "B", "C", "D", "E"))
```

![](getting-started_files/figure-html/base-r-1.png)

## ggplot2 Integration

### Discrete (Categorical) Scales

Use
[`scale_color_cam()`](https://xiaolong-y.github.io/cambridgema/reference/scale_color_cam.md)
and
[`scale_fill_cam()`](https://xiaolong-y.github.io/cambridgema/reference/scale_fill_cam.md)
for ggplot2:

``` r
ggplot(iris, aes(Sepal.Width, Sepal.Length, color = Species)) +
  geom_point(size = 3, alpha = 0.8) +
  scale_color_cam("autumn") +
  labs(title = "Iris Data with Autumn Palette") +
  theme_minimal()
```

![](getting-started_files/figure-html/discrete-1.png)

``` r
ggplot(mpg, aes(class, fill = class)) +
  geom_bar() +
  scale_fill_cam("summer") +
  labs(title = "Car Classes with Summer Palette") +
  theme_minimal() +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1))
```

![](getting-started_files/figure-html/fill-1.png)

### Continuous Scales

For continuous data, use `discrete = FALSE`:

``` r
ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_tile() +
  scale_fill_cam("river_seq", discrete = FALSE) +
  labs(title = "Old Faithful with River Sequential Palette") +
  theme_minimal()
```

![](getting-started_files/figure-html/continuous-1.png)

### Diverging Scales

Diverging palettes automatically center on zero - perfect for
correlations:

``` r
# Create correlation matrix
cor_mat <- cor(mtcars[, 1:6])
cor_df <- as.data.frame(as.table(cor_mat))
names(cor_df) <- c("Var1", "Var2", "value")

ggplot(cor_df, aes(Var1, Var2, fill = value)) +
  geom_tile() +
  scale_fill_cam("crimson_blue") +
  labs(title = "Correlation Matrix with Crimson-Blue Diverging Palette") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

![](getting-started_files/figure-html/diverging-1.png)

## Reversing Palettes

All functions support the `reverse` parameter:

``` r
# Normal order
ggplot(iris, aes(Species, Sepal.Length, fill = Species)) +
  geom_boxplot() +
  scale_fill_cam("spring") +
  labs(title = "Spring Palette (Normal Order)") +
  theme_minimal() +
  theme(legend.position = "none")
```

![](getting-started_files/figure-html/reverse-1.png)

``` r
# Reversed order
ggplot(iris, aes(Species, Sepal.Length, fill = Species)) +
  geom_boxplot() +
  scale_fill_cam("spring", reverse = TRUE) +
  labs(title = "Spring Palette (Reversed)") +
  theme_minimal() +
  theme(legend.position = "none")
```

![](getting-started_files/figure-html/reverse2-1.png)

## Handling Missing Values

Missing data uses neutral `granite_gray` by default. Customize with
`na.value`:

``` r
df <- data.frame(
  x = 1:5,
  y = c(2, 3, NA, 4, 5),
  g = c("A", "B", "C", "D", "E")
)

ggplot(df, aes(x, y, color = g)) +
  geom_point(size = 5) +
  scale_color_cam("spring", na.value = "#F0F5F9") +
  labs(title = "Missing Value Shown in Snow White") +
  theme_minimal()
#> Warning: Removed 1 row containing missing values or values outside the scale range
#> (`geom_point()`).
```

![](getting-started_files/figure-html/missing-1.png)

## Next Steps

- Check the **Colorblind Accessibility** vignette for CVD simulation
- Explore the **Cambridge Inspiration** vignette for the story behind
  each color
- Visit the [pkgdown site](https://xiaolong-y.github.io/cambridgema/)
  for full documentation
