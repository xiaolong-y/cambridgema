#' Display Cambridge color palettes
#'
#' Shows a swatch panel of all available Cambridge palettes, organized
#' by type: categorical, sequential, and diverging.
#'
#' @return NULL (displays plot)
#' @export
#' @importFrom graphics barplot mtext par
#' @examples
#' plot_cam_demo()
plot_cam_demo <- function() {
  all_pals <- list_palettes()
  n_pals <- length(unlist(all_pals))

  oldpar <- par(mfrow = c(n_pals, 1), mar = c(0.5, 8, 0.5, 1))
  on.exit(par(oldpar))

  for (type in names(all_pals)) {
    for (pal_name in all_pals[[type]]) {
      colors <- cam_palette(pal_name)
      n <- length(colors)
      barplot(rep(1, n), col = colors, border = NA, axes = FALSE,
              main = "", yaxt = "n", space = 0)

      # Add palette name and type
      label <- paste0(pal_name, " (", type, ")")
      mtext(label, side = 2, las = 1, line = 0.5, cex = 0.8)
    }
  }

  invisible(NULL)
}

#' Print palette information
#'
#' Prints detailed information about a palette including color names and hex codes.
#'
#' @param name Palette name
#' @return Invisibly returns the palette colors
#' @export
#' @examples
#' print_palette("spring")
#' print_palette("crimson_seq")
print_palette <- function(name) {
  colors <- cam_palette(name)

  cat("Palette:", name, "\n")
  cat("Colors:", length(colors), "\n")
  cat("Type:", ifelse(name %in% list_palettes()$categorical, "categorical",
                      ifelse(name %in% list_palettes()$sequential, "sequential", "diverging")), "\n")
  cat("\n")

  for (i in seq_along(colors)) {
    cat(sprintf("  %2d. %-20s %s\n", i, names(colors)[i], colors[i]))
  }

  invisible(colors)
}
