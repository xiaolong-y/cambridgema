#' Cambridge color scale for ggplot2
#'
#' Apply Cambridge, MA inspired color palettes to ggplot2 plots.
#' Supports discrete categorical scales, continuous gradients, and
#' diverging scales centered on zero.
#'
#' @param palette Palette name. Categorical: "spring", "summer", "autumn",
#'   "winter", "river". Sequential: "crimson_seq", "river_seq", "foliage_seq".
#'   Diverging: "crimson_blue", "brick_pine".
#' @param discrete Logical, TRUE for discrete scale, FALSE for continuous.
#'   Ignored for diverging palettes which are always continuous.
#' @param reverse Logical, reverse color order if TRUE
#' @param na.value Color used for missing values. Default is granite gray (#5A5A5A).
#' @param ... Additional arguments passed to ggplot2 scale functions
#' @return ggplot2 scale object
#' @export
#' @examples
#' library(ggplot2)
#'
#' # Categorical palette for discrete data
#' ggplot(iris, aes(Sepal.Width, Sepal.Length, color = Species)) +
#'   geom_point() +
#'   scale_color_cam("autumn")
#'
#' # Sequential palette for continuous data
#' ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
#'   geom_tile() +
#'   scale_fill_cam("river_seq", discrete = FALSE)
#'
#' # Diverging palette for centered data (correlations, differences)
#' # Automatically centers on zero
#' df <- data.frame(x = 1:9, y = 1:9, z = seq(-1, 1, length.out = 9))
#' ggplot(df, aes(x, y, fill = z)) +
#'   geom_tile() +
#'   scale_fill_cam("crimson_blue")
scale_color_cam <- function(palette = "spring", discrete = TRUE,
                            reverse = FALSE,
                            na.value = "#5A5A5A", ...) {
  # Check if this is a diverging palette
  diverging_pals <- c("crimson_blue", "brick_pine")
  is_diverging <- palette %in% diverging_pals

  if (is_diverging) {
    # Diverging palettes use scale_color_gradient2 for proper centering
    colors <- cam_palette(palette, reverse)
    n <- length(colors)
    mid_idx <- ceiling(n / 2)
    ggplot2::scale_color_gradient2(
      low = colors[1],
      mid = colors[mid_idx],
      high = colors[n],
      midpoint = 0,
      na.value = na.value, ...
    )
  } else if (discrete) {
    ggplot2::discrete_scale(
      aesthetics = "colour",
      palette = cam_pal(palette, reverse),
      na.value = na.value, ...
    )
  } else {
    ggplot2::scale_color_gradientn(
      colours = cam_palette(palette, reverse),
      na.value = na.value, ...
    )
  }
}

#' @rdname scale_color_cam
#' @export
scale_colour_cam <- scale_color_cam

#' Cambridge fill scale for ggplot2
#'
#' Apply Cambridge, MA inspired color palettes to fill aesthetics.
#' See \code{\link{scale_color_cam}} for details.
#'
#' @inheritParams scale_color_cam
#' @return ggplot2 scale object
#' @export
#' @examples
#' library(ggplot2)
#'
#' # Bar chart with categorical palette
#' ggplot(mpg, aes(class, fill = class)) +
#'   geom_bar() +
#'   scale_fill_cam("summer") +
#'   theme(legend.position = "none")
#'
#' # Heatmap with sequential palette
#' ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
#'   geom_tile() +
#'   scale_fill_cam("foliage_seq", discrete = FALSE)
#'
#' # Correlation matrix with diverging palette
#' cor_data <- data.frame(
#'   x = rep(1:3, 3), y = rep(1:3, each = 3),
#'   r = c(1, 0.5, -0.3, 0.5, 1, 0.8, -0.3, 0.8, 1)
#' )
#' ggplot(cor_data, aes(x, y, fill = r)) +
#'   geom_tile() +
#'   scale_fill_cam("crimson_blue")
scale_fill_cam <- function(palette = "spring", discrete = TRUE,
                           reverse = FALSE,
                           na.value = "#5A5A5A", ...) {
  # Check if this is a diverging palette
  diverging_pals <- c("crimson_blue", "brick_pine")
  is_diverging <- palette %in% diverging_pals

  if (is_diverging) {
    # Diverging palettes use scale_fill_gradient2 for proper centering
    colors <- cam_palette(palette, reverse)
    n <- length(colors)
    mid_idx <- ceiling(n / 2)
    ggplot2::scale_fill_gradient2(
      low = colors[1],
      mid = colors[mid_idx],
      high = colors[n],
      midpoint = 0,
      na.value = na.value, ...
    )
  } else if (discrete) {
    ggplot2::discrete_scale(
      aesthetics = "fill",
      palette = cam_pal(palette, reverse),
      na.value = na.value, ...
    )
  } else {
    ggplot2::scale_fill_gradientn(
      colours = cam_palette(palette, reverse),
      na.value = na.value, ...
    )
  }
}
