#' Cambridge color scale for ggplot2
#'
#' @param palette Palette name: "spring", "summer", "autumn", "winter", or "river"
#' @param discrete Logical, TRUE for discrete scale, FALSE for continuous
#' @param reverse Logical, reverse color order if TRUE
#' @param na.value Color used for missing values
#' @param ... Additional arguments passed to scale functions
#' @return ggplot2 scale object
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(iris, aes(Sepal.Width, Sepal.Length, color = Species)) +
#'   geom_point() +
#'   scale_color_cam("autumn")
scale_color_cam <- function(palette = "spring", discrete = TRUE,
                            reverse = FALSE,
                            na.value = cam_colors["granite"], ...) {
  if (discrete) {
    ggplot2::discrete_scale(
      "colour", paste0("cam_", palette),
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
#' @param palette Palette name: "spring", "summer", "autumn", "winter", or "river"
#' @param discrete Logical, TRUE for discrete scale, FALSE for continuous
#' @param reverse Logical, reverse color order if TRUE
#' @param na.value Color used for missing values
#' @param ... Additional arguments passed to scale functions
#' @return ggplot2 scale object
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(class, fill = class)) +
#'   geom_bar() +
#'   scale_fill_cam("summer") +
#'   theme(legend.position = "none")
scale_fill_cam <- function(palette = "spring", discrete = TRUE,
                           reverse = FALSE,
                           na.value = cam_colors["granite"], ...) {
  if (discrete) {
    ggplot2::discrete_scale(
      "fill", paste0("cam_", palette),
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
