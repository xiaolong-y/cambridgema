# Get Cambridge palette colors

Returns hex colors for a specified Cambridge palette. All palettes are
designed to be colorblind-friendly with sufficient contrast.

## Usage

``` r
cam_palette(name = "spring", reverse = FALSE)
```

## Arguments

- name:

  Palette name. Options:

  - Categorical (5 colors): "spring", "summer", "autumn", "winter",
    "river"

  - Sequential (7 colors): "crimson_seq", "river_seq", "foliage_seq"

  - Diverging (9 colors): "crimson_blue", "brick_pine"

- reverse:

  Logical, reverse color order if TRUE

## Value

Named character vector of hex colors

## See also

[`cam_pal`](https://xiaolong-y.github.io/cambridgema/reference/cam_pal.md)
for a function generator,
[`cam_cols`](https://xiaolong-y.github.io/cambridgema/reference/cam_cols.md)
for directly getting n colors,
[`list_palettes`](https://xiaolong-y.github.io/cambridgema/reference/list_palettes.md)
for all available palettes

## Examples

``` r
cam_palette("spring")
#> spring_blossom      maple_red   catkin_green     fresh_leaf     spring_sky 
#>      "#E8B4BC"      "#B70E2B"      "#9AB54A"      "#3A7D44"      "#6CA6CD" 
cam_palette("autumn", reverse = TRUE)
#>     oak_brown  maple_orange maple_scarlet     goldenrod  aster_purple 
#>     "#6B4423"     "#E07020"     "#C0392B"     "#D4A017"     "#6A4FB3" 
cam_palette("crimson_seq")  # 7-color sequential
#> crimson_1 crimson_2 crimson_3 crimson_4 crimson_5 crimson_6 crimson_7 
#> "#FDF2F4" "#F5D0D6" "#E89DA8" "#D66A7A" "#C4384E" "#A41034" "#6B0A22" 
cam_palette("crimson_blue") # 9-color diverging
#> div_crimson_4 div_crimson_3 div_crimson_2 div_crimson_1   div_neutral 
#>     "#A41034"     "#C74A5E"     "#E08A96"     "#F0C4C9"     "#F5F5F5" 
#>    div_blue_1    div_blue_2    div_blue_3    div_blue_4 
#>     "#C4DAE8"     "#7AB0D4"     "#3582B8"     "#0D4F8A" 
```
