#' Cambridge MA Color Palettes
#'
#' Named vector of all Cambridge-inspired colors. Each color is chosen for
#' colorblind accessibility with sufficient contrast and luminance variation.
#'
#' @format A named character vector of hex color codes
#' @details
#' Colors are organized by season and inspired by Cambridge, MA flora and landmarks:
#' \describe{
#'   \item{Spring}{Cherry blossoms, maple flowers, fresh leaves at Fresh Pond}
#'   \item{Summer}{Wildflowers at Cambridge Common - cardinal flower, milkweed, bergamot}
#'   \item{Autumn}{Fall foliage in Harvard Yard - asters, goldenrod, maple leaves}
#'   \item{Winter}{Evergreens and snow along the Charles River}
#'   \item{River}{The Charles River through the seasons}
#' }
#'
#' @export
#' @examples
#' cam_colors["maple_red"]
#' cam_colors[c("snow_white", "granite_gray")]
#' names(cam_colors)
cam_colors <- c(
  # ============================================================================

# SPRING PALETTE - Fresh Pond in April
  # ============================================================================
  spring_blossom = "#E8B4BC",    # Pink cherry/serviceberry blossoms
  maple_red = "#B70E2B",         # Red maple flower (early spring)
  catkin_green = "#9AB54A",      # Sugar maple catkin (yellow-green)
  fresh_leaf = "#3A7D44",        # New spring foliage (saturated green)
  spring_sky = "#6CA6CD",        # Clear spring sky blue

  # ============================================================================
  # SUMMER PALETTE - Cambridge Common in July
  # ============================================================================
  cardinal_flower = "#C1121F",   # Brilliant red cardinal flower
  milkweed_pink = "#D65D7A",     # Swamp milkweed pink
  bergamot_purple = "#7B5EA7",   # Wild bergamot purple
  susan_gold = "#E6A817",        # Black-eyed Susan golden yellow
  pond_teal = "#2D7D8F",         # Fresh Pond water teal

  # ============================================================================
  # AUTUMN PALETTE - Harvard Yard in October
  # ============================================================================
  aster_purple = "#6A4FB3",      # New England aster purple
  goldenrod = "#D4A017",         # Goldenrod yellow
  maple_scarlet = "#C0392B",     # Red maple leaf scarlet
  maple_orange = "#E07020",      # Sugar maple leaf orange
  oak_brown = "#6B4423",         # Oak leaf brown

  # ============================================================================
  # WINTER PALETTE - Charles River Esplanade in January
  # ============================================================================
  holly_red = "#B22222",         # Holly berry red
  pine_green = "#1B5E3C",        # White pine needles
  snow_white = "#F0F5F9",        # Fresh snow (slight blue tint)
  granite_gray = "#5A5A5A",      # Cambridge granite
  frost_blue = "#B8D4E8",        # Frost/ice blue

  # ============================================================================
  # RIVER PALETTE - Charles River Year-Round
  # ============================================================================
  river_deep = "#1A3E5C",        # Deep Charles River water
  charles_blue = "#2E6FBE",      # Mid-tone Charles River blue
  river_sky = "#A7C7E7",         # Sky reflection on water
  river_ice = "#CFE8F3",         # Winter ice on Charles
  sunset_glow = "#E8A87C",       # Sunset reflection

  # ============================================================================
  # SEQUENTIAL - Crimson (light to dark red)
  # ============================================================================
  crimson_1 = "#FDF2F4",         # Very light pink
  crimson_2 = "#F5D0D6",         # Light pink
  crimson_3 = "#E89DA8",         # Medium pink
  crimson_4 = "#D66A7A",         # Pink-red
  crimson_5 = "#C4384E",         # Medium crimson
  crimson_6 = "#A41034",         # Deep crimson
  crimson_7 = "#6B0A22",         # Dark crimson

  # ============================================================================
  # SEQUENTIAL - River (light to dark blue)
  # ============================================================================
  river_1 = "#F0F7FC",           # Very light blue
  river_2 = "#D4E8F5",           # Light sky blue
  river_3 = "#A7C7E7",           # Sky reflection
  river_4 = "#6BA3D6",           # Medium blue
  river_5 = "#2E6FBE",           # Charles blue
  river_6 = "#1A4E82",           # Deep blue
  river_7 = "#0D2E4D",           # Night water

  # ============================================================================
  # SEQUENTIAL - Foliage (light to dark warm)
  # ============================================================================
  foliage_1 = "#FFF8E7",         # Cream/light
  foliage_2 = "#FFEAB3",         # Light yellow
  foliage_3 = "#F5C54A",         # Golden yellow
  foliage_4 = "#E89A30",         # Orange-yellow
  foliage_5 = "#D66A1F",         # Bright orange
  foliage_6 = "#B84418",         # Red-orange
  foliage_7 = "#8B2500",         # Deep rust

  # ============================================================================
  # DIVERGING - Crimson to Blue (for correlations, differences)
  # ============================================================================
  div_crimson_4 = "#A41034",     # Strong negative (crimson)
  div_crimson_3 = "#C74A5E",     # Medium negative
  div_crimson_2 = "#E08A96",     # Light negative
  div_crimson_1 = "#F0C4C9",     # Very light negative
  div_neutral = "#F5F5F5",       # Neutral gray
  div_blue_1 = "#C4DAE8",        # Very light positive
  div_blue_2 = "#7AB0D4",        # Light positive
  div_blue_3 = "#3582B8",        # Medium positive
  div_blue_4 = "#0D4F8A",        # Strong positive (blue)

  # ============================================================================
  # DIVERGING - Brick to Pine (CVD-safe red-green alternative)
  # ============================================================================
  div_brick_4 = "#8B3A3A",       # Strong brick red
  div_brick_3 = "#A85858",       # Medium brick
  div_brick_2 = "#C48080",       # Light brick
  div_brick_1 = "#DEB0A8",       # Very light brick
  div_earth = "#F0F0E8",         # Neutral cream
  div_pine_1 = "#B8D4C0",        # Very light green
  div_pine_2 = "#7AB88C",        # Light pine
  div_pine_3 = "#3D8B54",        # Medium pine
  div_pine_4 = "#1B5E3C"         # Deep pine
)

# Internal palette definitions - map palette names to color names
palettes <- list(
  # Categorical palettes (5 colors each, good for discrete data)
  spring = c("spring_blossom", "maple_red", "catkin_green", "fresh_leaf", "spring_sky"),
  summer = c("cardinal_flower", "milkweed_pink", "bergamot_purple", "susan_gold", "pond_teal"),
  autumn = c("aster_purple", "goldenrod", "maple_scarlet", "maple_orange", "oak_brown"),
  winter = c("holly_red", "pine_green", "snow_white", "granite_gray", "frost_blue"),
  river = c("river_deep", "charles_blue", "river_sky", "river_ice", "sunset_glow"),

  # Sequential palettes (7 colors each, good for continuous data)
  crimson_seq = c("crimson_1", "crimson_2", "crimson_3", "crimson_4",
                  "crimson_5", "crimson_6", "crimson_7"),
  river_seq = c("river_1", "river_2", "river_3", "river_4",
                "river_5", "river_6", "river_7"),
  foliage_seq = c("foliage_1", "foliage_2", "foliage_3", "foliage_4",
                  "foliage_5", "foliage_6", "foliage_7"),

  # Diverging palettes (9 colors each, good for centered data like correlations)
  crimson_blue = c("div_crimson_4", "div_crimson_3", "div_crimson_2", "div_crimson_1",
                   "div_neutral",
                   "div_blue_1", "div_blue_2", "div_blue_3", "div_blue_4"),
  brick_pine = c("div_brick_4", "div_brick_3", "div_brick_2", "div_brick_1",
                 "div_earth",
                 "div_pine_1", "div_pine_2", "div_pine_3", "div_pine_4")
)

#' List available palettes
#'
#' Returns a list of all available palette names grouped by type
#'
#' @return A named list with palette names grouped by type
#' @export
#' @examples
#' list_palettes()
list_palettes <- function() {
  list(
    categorical = c("spring", "summer", "autumn", "winter", "river"),
    sequential = c("crimson_seq", "river_seq", "foliage_seq"),
    diverging = c("crimson_blue", "brick_pine")
  )
}
