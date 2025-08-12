#' Get Cambridge palette colors
#'
#' Returns hex colors for a specified Cambridge palette
#'
#' @param name Palette name: "spring", "summer", "autumn", "winter", or "river"
#' @param reverse Logical, reverse color order if TRUE
#' @return Named character vector of hex colors
#' @export
#' @examples
#' cam_palette("spring")
#' cam_palette("autumn", reverse = TRUE)
cam_palette <- function(name = "spring", reverse = FALSE) {
  if (!name %in% names(palettes)) {
    stop("Palette '", name, "' not found. Available: ",
         paste(names(palettes), collapse = ", "))
  }
  
  colors <- cam_colors[palettes[[name]]]
  if (reverse) colors <- rev(colors)
  colors
}

#' Cambridge palette function generator
#'
#' Returns a function that generates n colors from a palette
#'
#' @param palette Palette name: "spring", "summer", "autumn", "winter", or "river"
#' @param reverse Logical, reverse color order if TRUE
#' @return Function that takes n and returns n hex colors
#' @export
#' @examples
#' spring_pal <- cam_pal("spring")
#' spring_pal(3)
#' cam_pal("autumn")(7)
cam_pal <- function(palette = "spring", reverse = FALSE) {
  pal <- cam_palette(palette, reverse)
  function(n) {
    if (n <= length(pal)) {
      pal[seq_len(n)]
    } else {
      grDevices::colorRampPalette(pal)(n)
    }
  }
}

#' Get n Cambridge colors
#'
#' Base R helper to get n colors from a Cambridge palette
#'
#' @param n Number of colors needed
#' @param palette Palette name: "spring", "summer", "autumn", "winter", or "river"
#' @param reverse Logical, reverse color order if TRUE
#' @return Character vector of n hex colors
#' @export
#' @examples
#' cam_cols(3, "spring")
#' barplot(1:5, col = cam_cols(5, "autumn"))
cam_cols <- function(n, palette = "spring", reverse = FALSE) {
  cam_pal(palette, reverse)(n)
}