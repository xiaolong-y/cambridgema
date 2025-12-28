# Cambridge MA Color Palettes

Named vector of all Cambridge-inspired colors. Each color is chosen for
colorblind accessibility with sufficient contrast and luminance
variation.

## Usage

``` r
cam_colors
```

## Format

A named character vector of hex color codes

## Details

Colors are organized by season and inspired by Cambridge, MA flora and
landmarks:

- Spring:

  Cherry blossoms, maple flowers, fresh leaves at Fresh Pond

- Summer:

  Wildflowers at Cambridge Common - cardinal flower, milkweed, bergamot

- Autumn:

  Fall foliage in Harvard Yard - asters, goldenrod, maple leaves

- Winter:

  Evergreens and snow along the Charles River

- River:

  The Charles River through the seasons

## Examples

``` r
cam_colors["maple_red"]
#> maple_red 
#> "#B70E2B" 
cam_colors[c("snow_white", "granite_gray")]
#>   snow_white granite_gray 
#>    "#F0F5F9"    "#5A5A5A" 
names(cam_colors)
#>  [1] "spring_blossom"  "maple_red"       "catkin_green"    "fresh_leaf"     
#>  [5] "spring_sky"      "cardinal_flower" "milkweed_pink"   "bergamot_purple"
#>  [9] "susan_gold"      "pond_teal"       "aster_purple"    "goldenrod"      
#> [13] "maple_scarlet"   "maple_orange"    "oak_brown"       "holly_red"      
#> [17] "pine_green"      "snow_white"      "granite_gray"    "frost_blue"     
#> [21] "river_deep"      "charles_blue"    "river_sky"       "river_ice"      
#> [25] "sunset_glow"     "crimson_1"       "crimson_2"       "crimson_3"      
#> [29] "crimson_4"       "crimson_5"       "crimson_6"       "crimson_7"      
#> [33] "river_1"         "river_2"         "river_3"         "river_4"        
#> [37] "river_5"         "river_6"         "river_7"         "foliage_1"      
#> [41] "foliage_2"       "foliage_3"       "foliage_4"       "foliage_5"      
#> [45] "foliage_6"       "foliage_7"       "div_crimson_4"   "div_crimson_3"  
#> [49] "div_crimson_2"   "div_crimson_1"   "div_neutral"     "div_blue_1"     
#> [53] "div_blue_2"      "div_blue_3"      "div_blue_4"      "div_brick_4"    
#> [57] "div_brick_3"     "div_brick_2"     "div_brick_1"     "div_earth"      
#> [61] "div_pine_1"      "div_pine_2"      "div_pine_3"      "div_pine_4"     
```
