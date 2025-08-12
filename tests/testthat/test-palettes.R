test_that("cam_palette returns correct structure", {
  spring_pal <- cam_palette("spring")
  expect_type(spring_pal, "character")
  expect_length(spring_pal, 5)
  expect_named(spring_pal)
  expect_true(all(grepl("^#[0-9A-F]{6}$", spring_pal)))
})

test_that("cam_pal interpolates beyond base length", {
  autumn_colors <- cam_pal("autumn")(7)
  expect_length(autumn_colors, 7)
  expect_type(autumn_colors, "character")
  expect_true(all(grepl("^#[0-9A-F]{6}$", autumn_colors)))
})

test_that("scale_color_cam returns correct scale type", {
  discrete_scale <- scale_color_cam("winter", discrete = TRUE)
  expect_s3_class(discrete_scale, "ScaleDiscrete")

  continuous_scale <- scale_color_cam("river", discrete = FALSE)
  expect_s3_class(continuous_scale, "ScaleContinuous")
})

test_that("scale functions propagate na.value", {
  col_scale <- scale_color_cam("spring", na.value = cam_colors["snow"])
  expect_equal(col_scale$na.value, cam_colors["snow"])
  fill_scale <- scale_fill_cam("spring", na.value = cam_colors["snow"])
  expect_equal(fill_scale$na.value, cam_colors["snow"])
})

test_that("invalid palette names throw error", {
  expect_error(cam_palette("invalid"), "not found")
})