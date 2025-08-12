# cantabcolors

Cambridge, MA inspired color palettes for R, featuring seasonal colors from native and commonly observed species around Fresh Pond, Cambridge Common, and the Charles River.

## Installation

Install from GitHub using:

```r
# install.packages("remotes")
remotes::install_github("xiaolong-y/cantabcolors")
```

## Usage

### Base R

```r
library(cantabcolors)

# Simple barplot with autumn colors
barplot(c(3, 7, 9, 6, 2), 
        col = cam_cols(5, "autumn"),
        main = "Autumn in Cambridge")

# Access individual colors
cam_colors["red_maple_flower"]
```

### ggplot2

```r
library(ggplot2)
library(cantabcolors)

# Discrete scale with autumn palette
ggplot(iris, aes(Sepal.Width, Sepal.Length, color = Species)) +
  geom_point(size = 3) +
  scale_color_cam("autumn") +
  theme_minimal()

# Continuous gradient with river palette
ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_tile() +
  scale_fill_cam("river", discrete = FALSE) +
  theme_minimal()
```

### View all palettes

```r
plot_cam_demo()
```

## Available Palettes

- **spring**: Serviceberry blossoms, maple flowers, and fresh leaves
- **summer**: Buttonbush, milkweed, bergamot, and cardinal flower
- **autumn**: New England aster, goldenrod, and maple leaves
- **winter**: Holly, white pine, snow, and granite
- **river**: Charles River blues and sky tones

