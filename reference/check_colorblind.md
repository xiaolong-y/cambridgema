# Check palette colorblind accessibility

Evaluates a color palette for distinguishability under three types of
color vision deficiency: deuteranopia, protanopia, and tritanopia. Uses
the CIE LAB color space to calculate perceptual color distances.

## Usage

``` r
check_colorblind(palette, min_dist = 10)
```

## Arguments

- palette:

  Character vector of hex colors, or a palette name

- min_dist:

  Minimum acceptable color distance in CIE LAB space. Default is 10,
  which is generally distinguishable for most people.

## Value

A list with accessibility scores including:

- `passes`: Logical, TRUE if palette passes accessibility check

- `normal`: Minimum pairwise distance under normal vision

- `deuteranopia`: Distance under red-green deficiency (~6\\

- `protanopia`: Distance under red deficiency (~2\\

- `tritanopia`: Distance under blue-yellow deficiency (rare)

## Examples

``` r
# Check built-in palette
check_colorblind("spring")
#> Colorblind Accessibility Check
#> ------------------------------
#> Status: PASS 
#> Threshold: 10 
#> 
#> Minimum color distances:
#>   Normal vision:   35.49 
#>   Deuteranopia:    16.58 (red-green, ~6% males)
#>   Protanopia:      22.81 (red, ~2% males)
#>   Tritanopia:      22.3 (blue-yellow, rare)

# Check custom colors
check_colorblind(c("#FF0000", "#00FF00", "#0000FF"))
#> Colorblind Accessibility Check
#> ------------------------------
#> Status: PASS 
#> Threshold: 10 
#> 
#> Minimum color distances:
#>   Normal vision:   170.57 
#>   Deuteranopia:    27.96 (red-green, ~6% males)
#>   Protanopia:      65.74 (red, ~2% males)
#>   Tritanopia:      71.6 (blue-yellow, rare)

# Stricter threshold
check_colorblind("autumn", min_dist = 15)
#> Colorblind Accessibility Check
#> ------------------------------
#> Status: FAIL 
#> Threshold: 15 
#> 
#> Minimum color distances:
#>   Normal vision:   28.82 
#>   Deuteranopia:    9.87 (red-green, ~6% males)
#>   Protanopia:      7.34 (red, ~2% males)
#>   Tritanopia:      18.09 (blue-yellow, rare)
```
