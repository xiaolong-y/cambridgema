#' Cambridge MA Color Palettes
#'
#' Named vector of all Cambridge-inspired colors
#'
#' @export
#' @examples
#' cam_colors["red_maple_flower"]
#' cam_colors[c("snow", "granite")]
cam_colors <- c(
  serviceberry_blossom = "#F2F0EC",
  red_maple_flower = "#B70E2B",
  sugar_maple_catkin = "#C8D34A",
  blueberry_blossom = "#F4E6EC",
  fresh_leaf = "#76B26D",
  buttonbush = "#F7F5EE",
  swamp_milkweed = "#E07A9C",
  wild_bergamot = "#A68EC3",
  black_eyed_susan = "#F2B705",
  cardinal_flower = "#C1121F",
  new_england_aster = "#6A4FB3",
  goldenrod = "#E2B007",
  red_maple_leaf = "#C0392B",
  sugar_maple_leaf = "#F28C28",
  oak_leaf = "#8B5A2B",
  holly_berry = "#B22222",
  holly_leaf = "#0A5C2E",
  white_pine = "#0B5D3A",
  snow = "#F7FBFF",
  granite = "#6E6E6E",
  river_sky = "#A7C7E7",
  charles_blue = "#2E6FBE",
  river_ice = "#CFE8F3"
)

# Internal palette definitions
palettes <- list(
  spring = c("serviceberry_blossom", "red_maple_flower", "sugar_maple_catkin",
             "blueberry_blossom", "fresh_leaf"),
  summer = c("buttonbush", "swamp_milkweed", "wild_bergamot",
             "black_eyed_susan", "cardinal_flower"),
  autumn = c("new_england_aster", "goldenrod", "red_maple_leaf",
             "sugar_maple_leaf", "oak_leaf"),
  winter = c("holly_berry", "holly_leaf", "white_pine", "snow", "granite"),
  river = c("river_sky", "charles_blue", "river_ice")
)