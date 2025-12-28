# Print palette information

Prints detailed information about a palette including color names and
hex codes.

## Usage

``` r
print_palette(name)
```

## Arguments

- name:

  Palette name

## Value

Invisibly returns the palette colors

## Examples

``` r
print_palette("spring")
#> Palette: spring 
#> Colors: 5 
#> Type: categorical 
#> 
#>    1. spring_blossom       #E8B4BC
#>    2. maple_red            #B70E2B
#>    3. catkin_green         #9AB54A
#>    4. fresh_leaf           #3A7D44
#>    5. spring_sky           #6CA6CD
print_palette("crimson_seq")
#> Palette: crimson_seq 
#> Colors: 7 
#> Type: sequential 
#> 
#>    1. crimson_1            #FDF2F4
#>    2. crimson_2            #F5D0D6
#>    3. crimson_3            #E89DA8
#>    4. crimson_4            #D66A7A
#>    5. crimson_5            #C4384E
#>    6. crimson_6            #A41034
#>    7. crimson_7            #6B0A22
```
