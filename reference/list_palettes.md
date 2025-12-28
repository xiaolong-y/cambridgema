# List available palettes

Returns a list of all available palette names grouped by type

## Usage

``` r
list_palettes()
```

## Value

A named list with palette names grouped by type

## Examples

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
#> 
```
