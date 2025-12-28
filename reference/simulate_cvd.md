# Simulate color vision deficiency

Transforms colors to simulate how they appear to people with different
types of color vision deficiency.

## Usage

``` r
simulate_cvd(colors, type = c("deuteranopia", "protanopia", "tritanopia"))
```

## Arguments

- colors:

  Character vector of hex colors

- type:

  Type of CVD: "deuteranopia", "protanopia", or "tritanopia"

## Value

Character vector of transformed hex colors

## Examples

``` r
# Simulate deuteranopia
spring_cols <- cam_palette("spring")
simulate_cvd(spring_cols, "deuteranopia")
#> spring_blossom      maple_red   catkin_green     fresh_leaf     spring_sky 
#>      "#C8C5BB"      "#736724"      "#BCAA51"      "#756D48"      "#879BCC" 
```
