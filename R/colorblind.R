#' Colorblind Accessibility Functions
#'
#' Tools for checking and visualizing palette accessibility for
#' people with color vision deficiencies (CVD).
#'
#' @name colorblind
NULL

#' Check palette colorblind accessibility
#'
#' Evaluates a color palette for distinguishability under three types
#' of color vision deficiency: deuteranopia, protanopia, and tritanopia.
#' Uses the CIE LAB color space to calculate perceptual color distances.
#'
#' @param palette Character vector of hex colors, or a palette name
#' @param min_dist Minimum acceptable color distance in CIE LAB space.
#'   Default is 10, which is generally distinguishable for most people.
#' @return A list with accessibility scores including:
#'   \itemize{
#'     \item \code{passes}: Logical, TRUE if palette passes accessibility check
#'     \item \code{normal}: Minimum pairwise distance under normal vision
#'     \item \code{deuteranopia}: Distance under red-green deficiency (~6\% males)
#'     \item \code{protanopia}: Distance under red deficiency (~2\% males)
#'     \item \code{tritanopia}: Distance under blue-yellow deficiency (rare)
#'   }
#' @export
#' @examples
#' # Check built-in palette
#' check_colorblind("spring")
#'
#' # Check custom colors
#' check_colorblind(c("#FF0000", "#00FF00", "#0000FF"))
#'
#' # Stricter threshold
#' check_colorblind("autumn", min_dist = 15)
check_colorblind <- function(palette, min_dist = 10) {
  # Get colors if palette name provided
  if (length(palette) == 1 && palette %in% names(palettes)) {
    palette <- unname(cam_palette(palette))
  }

  # Check for colorspace package
  if (!requireNamespace("colorspace", quietly = TRUE)) {
    message("Note: Install 'colorspace' package for accurate CVD simulation.")
    message("Using simplified check based on luminance only.")
    return(check_colorblind_simple(palette, min_dist))
  }

  # Calculate distances for each vision type
  normal_dist <- calc_min_distance(palette)
  deutan_dist <- calc_min_distance(colorspace::deutan(palette))
  protan_dist <- calc_min_distance(colorspace::protan(palette))
  tritan_dist <- calc_min_distance(colorspace::tritan(palette))

  # Determine if passes (all CVD types should meet at least 50% of threshold)
  passes <- all(c(
    normal_dist >= min_dist,
    deutan_dist >= min_dist * 0.5,
    protan_dist >= min_dist * 0.5,
    tritan_dist >= min_dist * 0.5
  ))

  result <- list(
    passes = passes,
    threshold = min_dist,
    normal = round(normal_dist, 2),
    deuteranopia = round(deutan_dist, 2),
    protanopia = round(protan_dist, 2),
    tritanopia = round(tritan_dist, 2)
  )

  class(result) <- c("colorblind_check", "list")
  result
}

#' @export
print.colorblind_check <- function(x, ...) {
  cat("Colorblind Accessibility Check\n")
  cat("------------------------------\n")
  cat("Status:", ifelse(x$passes, "PASS", "FAIL"), "\n")
  cat("Threshold:", x$threshold, "\n\n")

  cat("Minimum color distances:\n")
  cat("  Normal vision:  ", x$normal, "\n")
  cat("  Deuteranopia:   ", x$deuteranopia, "(red-green, ~6% males)\n")
  cat("  Protanopia:     ", x$protanopia, "(red, ~2% males)\n")
  cat("  Tritanopia:     ", x$tritanopia, "(blue-yellow, rare)\n")
  invisible(x)
}

#' Visualize palette under color vision deficiency
#'
#' Displays a palette as seen by people with different types of
#' color vision deficiency. Requires the colorspace package.
#'
#' @param name Palette name or character vector of hex colors
#' @param labels Logical, show color names/hex codes below swatches
#' @return NULL (displays plot)
#' @export
#' @importFrom graphics barplot mtext par title
#' @examples
#' # Visualize built-in palette
#' plot_colorblind_sim("autumn")
#'
#' # Visualize custom colors
#' plot_colorblind_sim(c("#E8B4BC", "#B70E2B", "#9AB54A", "#3A7D44", "#6CA6CD"))
plot_colorblind_sim <- function(name, labels = FALSE) {
  # Get colors
  if (length(name) == 1 && name %in% names(palettes)) {
    colors <- unname(cam_palette(name))
    title <- paste("Palette:", name)
  } else {
    colors <- name
    title <- "Custom palette"
  }

  # Check for colorspace package
  if (!requireNamespace("colorspace", quietly = TRUE)) {
    stop("Package 'colorspace' required for CVD simulation. ",
         "Install with: install.packages('colorspace')")
  }

  # Set up plot
  oldpar <- par(mfrow = c(4, 1), mar = c(1, 10, 2, 1))
  on.exit(par(oldpar))

  n <- length(colors)

  # Normal vision
  barplot(rep(1, n), col = colors, border = NA, axes = FALSE, space = 0)
  mtext("Normal", side = 2, las = 1, line = 0.5, font = 2)

  # Deuteranopia
  deutan_colors <- colorspace::deutan(colors)
  barplot(rep(1, n), col = deutan_colors, border = NA, axes = FALSE, space = 0)
  mtext("Deuteranopia\n(~6% males)", side = 2, las = 1, line = 0.5, cex = 0.8)

  # Protanopia
  protan_colors <- colorspace::protan(colors)
  barplot(rep(1, n), col = protan_colors, border = NA, axes = FALSE, space = 0)
  mtext("Protanopia\n(~2% males)", side = 2, las = 1, line = 0.5, cex = 0.8)

  # Tritanopia
  tritan_colors <- colorspace::tritan(colors)
  barplot(rep(1, n), col = tritan_colors, border = NA, axes = FALSE, space = 0)
  mtext("Tritanopia\n(rare)", side = 2, las = 1, line = 0.5, cex = 0.8)

  # Add title
  title(main = title, outer = TRUE, line = -1)

  invisible(NULL)
}

#' Simulate color vision deficiency
#'
#' Transforms colors to simulate how they appear to people with
#' different types of color vision deficiency.
#'
#' @param colors Character vector of hex colors
#' @param type Type of CVD: "deuteranopia", "protanopia", or "tritanopia"
#' @return Character vector of transformed hex colors
#' @export
#' @examples
#' # Simulate deuteranopia
#' spring_cols <- cam_palette("spring")
#' simulate_cvd(spring_cols, "deuteranopia")
simulate_cvd <- function(colors, type = c("deuteranopia", "protanopia", "tritanopia")) {
  type <- match.arg(type)

  if (!requireNamespace("colorspace", quietly = TRUE)) {
    stop("Package 'colorspace' required for CVD simulation. ",
         "Install with: install.packages('colorspace')")
  }

  switch(type,
         deuteranopia = colorspace::deutan(colors),
         protanopia = colorspace::protan(colors),
         tritanopia = colorspace::tritan(colors))
}

# Internal helper: Calculate minimum pairwise CIE LAB distance
#' @importFrom methods as
calc_min_distance <- function(colors) {
  if (!requireNamespace("colorspace", quietly = TRUE)) {
    return(NA)
  }

  n <- length(colors)
  if (n < 2) return(Inf)

  # Convert to LAB
  rgb_obj <- colorspace::hex2RGB(colors)
  lab <- as(rgb_obj, "LAB")
  coords <- colorspace::coords(lab)

  # Calculate all pairwise distances
  min_dist <- Inf
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      dist <- sqrt(sum((coords[i, ] - coords[j, ])^2))
      min_dist <- min(min_dist, dist)
    }
  }

  min_dist
}

# Internal helper: Simple luminance-based check (fallback when colorspace unavailable)
check_colorblind_simple <- function(colors, min_dist) {
  # Calculate luminance for each color
  rgb_vals <- grDevices::col2rgb(colors) / 255
  luminance <- 0.2126 * rgb_vals[1, ] + 0.7152 * rgb_vals[2, ] + 0.0722 * rgb_vals[3, ]

  # Calculate minimum luminance difference
  n <- length(luminance)
  if (n < 2) return(list(passes = TRUE, normal = Inf))

  min_lum_diff <- Inf
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      diff <- abs(luminance[i] - luminance[j]) * 100  # Scale to ~LAB units
      min_lum_diff <- min(min_lum_diff, diff)
    }
  }

  list(
    passes = min_lum_diff >= min_dist * 0.5,
    normal = round(min_lum_diff, 2),
    note = "Simplified check. Install 'colorspace' for full CVD analysis."
  )
}
