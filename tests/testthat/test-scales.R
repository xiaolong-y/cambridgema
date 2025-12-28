# ==============================================================================
# TEST FILE: test-scales.R
# Tests for ggplot2 scale functions
# ==============================================================================

library(ggplot2)

# --- Test scale_color_cam ---
test_that("scale_color_cam returns correct scale classes", {
  discrete_scale <- scale_color_cam("spring", discrete = TRUE)
  expect_s3_class(discrete_scale, "ScaleDiscrete")
  expect_s3_class(discrete_scale, "Scale")

  continuous_scale <- scale_color_cam("river", discrete = FALSE)
  expect_s3_class(continuous_scale, "ScaleContinuous")
  expect_s3_class(continuous_scale, "Scale")
})

test_that("scale_color_cam works with all categorical palettes", {
  palettes <- c("spring", "summer", "autumn", "winter", "river")
  for (pal in palettes) {
    discrete <- scale_color_cam(pal, discrete = TRUE)
    continuous <- scale_color_cam(pal, discrete = FALSE)
    expect_s3_class(discrete, "Scale")
    expect_s3_class(continuous, "Scale")
  }
})

test_that("scale_color_cam works with sequential palettes", {
  palettes <- c("crimson_seq", "river_seq", "foliage_seq")
  for (pal in palettes) {
    scale <- scale_color_cam(pal, discrete = FALSE)
    expect_s3_class(scale, "Scale")
  }
})

test_that("scale_color_cam handles diverging palettes", {
  # Diverging palettes should work with gradient2
  for (pal in c("crimson_blue", "brick_pine")) {
    scale <- scale_color_cam(pal)
    expect_s3_class(scale, "Scale")
  }
})

test_that("scale_color_cam handles na.value correctly", {
  custom_na <- "#FF0000"
  scale <- scale_color_cam("spring", na.value = custom_na)
  expect_equal(scale$na.value, custom_na)

  # Default na.value should be granite_gray (#5A5A5A)
  default_scale <- scale_color_cam("spring")
  expect_equal(default_scale$na.value, "#5A5A5A")
})

test_that("scale_colour_cam is an alias for scale_color_cam", {
  color_scale <- scale_color_cam("autumn", discrete = TRUE)
  colour_scale <- scale_colour_cam("autumn", discrete = TRUE)
  expect_equal(class(color_scale), class(colour_scale))
})

# --- Test scale_fill_cam ---
test_that("scale_fill_cam returns correct scale classes", {
  discrete_scale <- scale_fill_cam("summer", discrete = TRUE)
  expect_s3_class(discrete_scale, "ScaleDiscrete")

  continuous_scale <- scale_fill_cam("river", discrete = FALSE)
  expect_s3_class(continuous_scale, "ScaleContinuous")
})

test_that("scale_fill_cam handles na.value correctly", {
  custom_na <- "#00FF00"
  scale <- scale_fill_cam("autumn", na.value = custom_na)
  expect_equal(scale$na.value, custom_na)

  # Default na.value should be granite_gray (#5A5A5A)
  default_scale <- scale_fill_cam("autumn")
  expect_equal(default_scale$na.value, "#5A5A5A")
})

# --- Integration tests with actual ggplot objects ---
test_that("scale_color_cam integrates with ggplot2 discrete mapping", {
  p <- ggplot(iris, aes(Sepal.Width, Sepal.Length, color = Species)) +
    geom_point() +
    scale_color_cam("spring")

  # Should build without error
  built <- ggplot_build(p)
  expect_s3_class(built, "ggplot_built")

  # Check that colors are from the palette
  spring_colors <- unname(cam_palette("spring"))
  plot_colors <- unique(built$data[[1]]$colour)
  # First 3 colors should be from spring palette (iris has 3 species)
  expect_true(all(plot_colors %in% spring_colors))
})

test_that("scale_fill_cam integrates with ggplot2 discrete mapping", {
  df <- data.frame(x = c("A", "B", "C"), y = c(1, 2, 3))
  p <- ggplot(df, aes(x, y, fill = x)) +
    geom_col() +
    scale_fill_cam("autumn")

  built <- ggplot_build(p)
  expect_s3_class(built, "ggplot_built")
})

test_that("scale_color_cam handles continuous data", {
  p <- ggplot(mtcars, aes(wt, mpg, color = hp)) +
    geom_point() +
    scale_color_cam("river_seq", discrete = FALSE)

  built <- ggplot_build(p)
  expect_s3_class(built, "ggplot_built")
})

test_that("scale_fill_cam handles continuous data", {
  p <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
    geom_tile() +
    scale_fill_cam("river_seq", discrete = FALSE)

  built <- ggplot_build(p)
  expect_s3_class(built, "ggplot_built")
})

# --- Test reverse parameter in scales ---
test_that("scale functions respect reverse parameter", {
  # Test that the underlying palette is reversed
  normal_pal <- cam_palette("autumn", reverse = FALSE)
  reversed_pal <- cam_palette("autumn", reverse = TRUE)

  expect_equal(unname(normal_pal), rev(unname(reversed_pal)))

  # Test that scales can be created with reverse parameter
  scale_normal <- scale_fill_cam("autumn", reverse = FALSE)
  scale_reversed <- scale_fill_cam("autumn", reverse = TRUE)

  expect_s3_class(scale_normal, "Scale")
  expect_s3_class(scale_reversed, "Scale")
})
