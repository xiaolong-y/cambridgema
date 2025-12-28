# Cambridge palette function generator

Returns a function that generates n colors from a palette. If n exceeds
the palette size, colors are interpolated using
[`colorRampPalette`](https://rdrr.io/r/grDevices/colorRamp.html).

## Usage

``` r
cam_pal(palette = "spring", reverse = FALSE)
```

## Arguments

- palette:

  Palette name (see
  [`cam_palette`](https://xiaolong-y.github.io/cambridgema/reference/cam_palette.md)
  for options)

- reverse:

  Logical, reverse color order if TRUE

## Value

Function that takes n and returns n hex colors

## See also

[`cam_palette`](https://xiaolong-y.github.io/cambridgema/reference/cam_palette.md)
for getting raw palette colors,
[`cam_cols`](https://xiaolong-y.github.io/cambridgema/reference/cam_cols.md)
for directly getting n colors

## Examples

``` r
# Create a palette function
spring_pal <- cam_pal("spring")
spring_pal(3)  # Get 3 colors
#> [1] "#E8B4BC" "#B70E2B" "#9AB54A"
spring_pal(10) # Get 10 colors (interpolated)
#>  [1] "#E8B4BC" "#D26A7B" "#BC203B" "#AD4535" "#A08F43" "#84A848" "#5A8F46"
#>  [8] "#3F8153" "#559390" "#6CA6CD"

# One-liner
cam_pal("autumn")(7)
#> [1] "#6A4FB3" "#B0844B" "#CD7D1D" "#C0392B" "#D55D23" "#B96121" "#6B4423"
```
