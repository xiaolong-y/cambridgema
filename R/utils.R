#' Display Cambridge color palettes
#'
#' Shows a swatch panel of all available Cambridge palettes
#'
#' @return NULL (displays plot)
#' @export
#' @examples
#' plot_cam_demo()
plot_cam_demo <- function() {
  oldpar <- par(mfrow = c(5, 1), mar = c(1, 4, 1, 1))
  on.exit(par(oldpar))
  
  for (pal_name in names(palettes)) {
    colors <- cam_palette(pal_name)
    n <- length(colors)
    barplot(rep(1, n), col = colors, border = NA, axes = FALSE,
            main = "", yaxt = "n")
    mtext(pal_name, side = 2, las = 1, line = 0.5)
  }

  invisible(NULL)
}
