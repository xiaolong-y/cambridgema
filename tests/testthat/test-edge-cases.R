# ==============================================================================
# TEST FILE: test-edge-cases.R
# Tests for edge cases and boundary conditions
# ==============================================================================

# --- Zero and small inputs ---
test_that("cam_cols handles zero colors", {
  result <- cam_cols(0, "spring")
  expect_length(result, 0)
  expect_type(result, "character")
})

test_that("cam_pal function handles zero colors", {
  spring_fn <- cam_pal("spring")
  result <- spring_fn(0)
  expect_length(result, 0)
})

test_that("cam_cols handles single color", {
  result <- cam_cols(1, "autumn")
  expect_length(result, 1)
  expect_true(grepl("^#[0-9A-Fa-f]{6}$", result))
})

# --- Large interpolation tests ---
test_that("cam_pal handles large interpolation (100 colors)", {
  for (pal_name in c("spring", "summer", "autumn", "winter", "river")) {
    colors <- cam_pal(pal_name)(100)
    expect_length(colors, 100)
    expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", colors)),
                info = paste("Invalid hex in interpolated", pal_name))
  }
})

test_that("cam_pal handles very large interpolation (1000 colors)", {
  colors <- cam_pal("autumn")(1000)
  expect_length(colors, 1000)
  expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", colors)))
})

# --- Exact palette size requests ---
test_that("requesting exact palette size returns original colors", {
  # Categorical palettes have 5 colors
  for (pal_name in c("spring", "summer", "autumn", "winter", "river")) {
    exact <- cam_cols(5, pal_name)
    original <- unname(cam_palette(pal_name))
    expect_equal(unname(exact), original,
                 info = paste("Mismatch for", pal_name))
  }

  # Sequential palettes have 7 colors
  for (pal_name in c("crimson_seq", "river_seq", "foliage_seq")) {
    exact <- cam_cols(7, pal_name)
    original <- unname(cam_palette(pal_name))
    expect_equal(unname(exact), original,
                 info = paste("Mismatch for", pal_name))
  }

  # Diverging palettes have 9 colors
  for (pal_name in c("crimson_blue", "brick_pine")) {
    exact <- cam_cols(9, pal_name)
    original <- unname(cam_palette(pal_name))
    expect_equal(unname(exact), original,
                 info = paste("Mismatch for", pal_name))
  }
})

# --- Subsetting tests ---
test_that("requesting fewer than palette size returns subset", {
  colors_3 <- cam_cols(3, "autumn")
  colors_5 <- cam_palette("autumn")

  expect_equal(unname(colors_3), unname(colors_5[1:3]))
})

# --- Type consistency ---
test_that("all functions return character vectors", {
  expect_type(cam_palette("spring"), "character")
  expect_type(cam_pal("summer")(5), "character")
  expect_type(cam_cols(5, "autumn"), "character")
  expect_type(cam_colors, "character")
})

# --- Named vector preservation ---
test_that("cam_palette preserves color names", {
  for (pal_name in names(list_palettes()$categorical)) {
    pal <- cam_palette(pal_name)
    expect_named(pal)
    expect_true(all(nchar(names(pal)) > 0))
  }
})

# --- Hex format consistency ---
test_that("all hex codes are valid 6-digit format", {
  expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", cam_colors)))

  for (pal_name in unlist(list_palettes())) {
    pal <- cam_palette(pal_name)
    expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", pal)),
                info = paste("Inconsistent hex format in", pal_name))
  }
})

# --- Error handling ---
test_that("invalid palette names produce informative errors", {
  expect_error(cam_palette("nonexistent"), "not found")
  expect_error(cam_palette(""), "not found")
  expect_error(cam_pal("invalid"), "not found")
  expect_error(cam_cols(5, "fake"), "not found")
})

# --- Scale function edge cases ---
test_that("scale functions work with empty data", {
  library(ggplot2)

  df_empty <- data.frame(x = numeric(0), y = numeric(0), g = character(0))

  p <- ggplot(df_empty, aes(x, y, color = g)) +
    geom_point() +
    scale_color_cam("spring")

  # Should build without error (just empty plot)
  expect_no_error(ggplot_build(p))
})

test_that("scale functions handle NA values in data", {
  library(ggplot2)

  df <- data.frame(
    x = 1:4,
    y = 1:4,
    g = c("A", NA, "B", "C")
  )

  p <- ggplot(df, aes(x, y, color = g)) +
    geom_point(size = 3) +
    scale_color_cam("spring")

  expect_no_error(ggplot_build(p))
})
