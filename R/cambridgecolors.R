#' Get Cambridge palette colors
#'
#' Returns hex colors for a specified Cambridge palette. All palettes are
#' designed to be colorblind-friendly with sufficient contrast.
#'
#' @param name Palette name. Options:
#'   \itemize{
#'     \item Categorical (5 colors): "spring", "summer", "autumn", "winter", "river"
#'     \item Sequential (7 colors): "crimson_seq", "river_seq", "foliage_seq"
#'     \item Diverging (9 colors): "crimson_blue", "brick_pine"
#'   }
#' @param reverse Logical, reverse color order if TRUE
#' @return Named character vector of hex colors
#' @export
#' @seealso \code{\link{cam_pal}} for a function generator,
#'   \code{\link{cam_cols}} for directly getting n colors,
#'   \code{\link{list_palettes}} for all available palettes
#' @examples
#' cam_palette("spring")
#' cam_palette("autumn", reverse = TRUE)
#' cam_palette("crimson_seq")  # 7-color sequential
#' cam_palette("crimson_blue") # 9-color diverging
cam_palette <- function(name = "spring", reverse = FALSE) {
  if (!name %in% names(palettes)) {
    available <- paste(names(palettes), collapse = ", ")
    stop("Palette '", name, "' not found. Available: ", available)
  }

  colors <- cam_colors[palettes[[name]]]
  if (reverse) colors <- rev(colors)
  colors
}

#' Cambridge palette function generator
#'
#' Returns a function that generates n colors from a palette.
#' If n exceeds the palette size, colors are interpolated using
#' \code{\link[grDevices]{colorRampPalette}}.
#'
#' @param palette Palette name (see \code{\link{cam_palette}} for options)
#' @param reverse Logical, reverse color order if TRUE
#' @return Function that takes n and returns n hex colors
#' @export
#' @seealso \code{\link{cam_palette}} for getting raw palette colors,
#'   \code{\link{cam_cols}} for directly getting n colors
#' @examples
#' # Create a palette function
#' spring_pal <- cam_pal("spring")
#' spring_pal(3)  # Get 3 colors
#' spring_pal(10) # Get 10 colors (interpolated)
#'
#' # One-liner
#' cam_pal("autumn")(7)
cam_pal <- function(palette = "spring", reverse = FALSE) {
  pal <- cam_palette(palette, reverse)
  function(n) {
    if (n <= length(pal)) {
      unname(pal[seq_len(n)])
    } else {
      grDevices::colorRampPalette(pal)(n)
    }
  }
}

#' Get n Cambridge colors
#'
#' Base R helper to get n colors from a Cambridge palette.
#' Useful for base R plotting functions.
#'
#' @param n Number of colors needed
#' @param palette Palette name (see \code{\link{cam_palette}} for options)
#' @param reverse Logical, reverse color order if TRUE
#' @return Character vector of n hex colors
#' @export
#' @seealso \code{\link{cam_palette}} for getting raw palette colors,
#'   \code{\link{cam_pal}} for a function generator
#' @examples
#' # Get 5 autumn colors for a barplot
#' barplot(1:5, col = cam_cols(5, "autumn"))
#'
#' # Get 3 spring colors
#' cam_cols(3, "spring")
#'
#' # Get 10 colors from sequential palette
#' cam_cols(10, "river_seq")
cam_cols <- function(n, palette = "spring", reverse = FALSE) {
  cam_pal(palette, reverse)(n)
}
