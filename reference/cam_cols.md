# Get n Cambridge colors

Base R helper to get n colors from a Cambridge palette. Useful for base
R plotting functions.

## Usage

``` r
cam_cols(n, palette = "spring", reverse = FALSE)
```

## Arguments

- n:

  Number of colors needed

- palette:

  Palette name (see
  [`cam_palette`](https://xiaolong-y.github.io/cambridgema/reference/cam_palette.md)
  for options)

- reverse:

  Logical, reverse color order if TRUE

## Value

Character vector of n hex colors

## See also

[`cam_palette`](https://xiaolong-y.github.io/cambridgema/reference/cam_palette.md)
for getting raw palette colors,
[`cam_pal`](https://xiaolong-y.github.io/cambridgema/reference/cam_pal.md)
for a function generator

## Examples

``` r
# Get 5 autumn colors for a barplot
barplot(1:5, col = cam_cols(5, "autumn"))


# Get 3 spring colors
cam_cols(3, "spring")
#> [1] "#E8B4BC" "#B70E2B" "#9AB54A"

# Get 10 colors from sequential palette
cam_cols(10, "river_seq")
#>  [1] "#F0F7FC" "#DDEDF7" "#C5DDF0" "#A7C7E7" "#7FAFDB" "#5691CE" "#2E6FBE"
#>  [8] "#205996" "#154370" "#0D2E4D"
```
