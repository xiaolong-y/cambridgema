# ==============================================================================
# TEST FILE: test-palettes.R
# Comprehensive tests for cambridgema palette functions
# ==============================================================================

# --- Test cam_colors vector ---
test_that("cam_colors is a complete named character vector", {
  expect_type(cam_colors, "character")
  expect_true(length(cam_colors) >= 50)  # We have 50+ colors now
  expect_named(cam_colors)
  expect_true(all(nchar(names(cam_colors)) > 0))
  expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", cam_colors)))
})

test_that("cam_colors contains seasonal palette colors", {
  # Check spring colors exist
  expect_true("spring_blossom" %in% names(cam_colors))
  expect_true("maple_red" %in% names(cam_colors))
  expect_true("fresh_leaf" %in% names(cam_colors))

  # Check summer colors exist
  expect_true("cardinal_flower" %in% names(cam_colors))
  expect_true("susan_gold" %in% names(cam_colors))

  # Check autumn colors exist
  expect_true("aster_purple" %in% names(cam_colors))
  expect_true("goldenrod" %in% names(cam_colors))

  # Check winter colors exist
  expect_true("holly_red" %in% names(cam_colors))
  expect_true("snow_white" %in% names(cam_colors))
  expect_true("granite_gray" %in% names(cam_colors))
})

test_that("cam_colors contains sequential palette colors", {
  # Crimson sequence
  expect_true("crimson_1" %in% names(cam_colors))
  expect_true("crimson_7" %in% names(cam_colors))

  # River sequence
  expect_true("river_1" %in% names(cam_colors))
  expect_true("river_7" %in% names(cam_colors))

  # Foliage sequence
  expect_true("foliage_1" %in% names(cam_colors))
  expect_true("foliage_7" %in% names(cam_colors))
})

test_that("cam_colors contains diverging palette colors", {
  expect_true("div_crimson_4" %in% names(cam_colors))
  expect_true("div_neutral" %in% names(cam_colors))
  expect_true("div_blue_4" %in% names(cam_colors))
  expect_true("div_brick_4" %in% names(cam_colors))
  expect_true("div_pine_4" %in% names(cam_colors))
})

# --- Test cam_palette ---
test_that("cam_palette returns correct structure for categorical palettes", {
  for (pal_name in c("spring", "summer", "autumn", "winter", "river")) {
    pal <- cam_palette(pal_name)
    expect_type(pal, "character")
    expect_length(pal, 5)
    expect_named(pal)
    expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", pal)))
  }
})

test_that("cam_palette returns correct structure for sequential palettes", {
  for (pal_name in c("crimson_seq", "river_seq", "foliage_seq")) {
    pal <- cam_palette(pal_name)
    expect_type(pal, "character")
    expect_length(pal, 7)
    expect_named(pal)
  }
})

test_that("cam_palette returns correct structure for diverging palettes", {
  for (pal_name in c("crimson_blue", "brick_pine")) {
    pal <- cam_palette(pal_name)
    expect_type(pal, "character")
    expect_length(pal, 9)
    expect_named(pal)
  }
})

test_that("cam_palette reverse works correctly", {
  spring_normal <- cam_palette("spring")
  spring_reversed <- cam_palette("spring", reverse = TRUE)
  expect_equal(unname(spring_normal), rev(unname(spring_reversed)))
  expect_equal(names(spring_normal), rev(names(spring_reversed)))
})

test_that("cam_palette throws error for invalid names", {
  expect_error(cam_palette("invalid_palette"), "not found")
  expect_error(cam_palette(""), "not found")
  expect_error(cam_palette("SPRING"), "not found")  # Case-sensitive
})

# --- Test cam_pal function generator ---
test_that("cam_pal returns a function", {
  pal_fn <- cam_pal("autumn")
  expect_type(pal_fn, "closure")
})

test_that("cam_pal function returns correct number of colors", {
  autumn_fn <- cam_pal("autumn")
  expect_length(autumn_fn(1), 1)
  expect_length(autumn_fn(3), 3)
  expect_length(autumn_fn(5), 5)
  expect_length(autumn_fn(7), 7)  # Interpolation beyond base
  expect_length(autumn_fn(10), 10)
  expect_length(autumn_fn(100), 100)  # Large interpolation
})

test_that("cam_pal returns valid hex colors at all sizes", {
  river_fn <- cam_pal("river")
  for (n in c(1, 2, 3, 5, 10, 50)) {
    colors <- river_fn(n)
    expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", colors)),
                info = paste("Invalid hex at n =", n))
  }
})

test_that("cam_pal reverse parameter works", {
  normal_fn <- cam_pal("winter")
  reverse_fn <- cam_pal("winter", reverse = TRUE)
  normal_colors <- normal_fn(5)
  reverse_colors <- reverse_fn(5)
  expect_equal(unname(normal_colors), rev(unname(reverse_colors)))
})

# --- Test cam_cols convenience function ---
test_that("cam_cols returns correct colors", {
  cols <- cam_cols(5, "autumn")
  expect_length(cols, 5)
  expect_type(cols, "character")
  expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", cols)))
})

test_that("cam_cols handles interpolation", {
  # Get more colors than palette has
  cols <- cam_cols(10, "spring")  # Spring has 5 colors
  expect_length(cols, 10)
  expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", cols)))
})

test_that("cam_cols respects reverse parameter", {
  normal <- cam_cols(5, "summer")
  reversed <- cam_cols(5, "summer", reverse = TRUE)
  expect_equal(unname(normal), rev(unname(reversed)))
})

# --- Test list_palettes ---
test_that("list_palettes returns correct structure", {
  pals <- list_palettes()
  expect_type(pals, "list")
  expect_named(pals, c("categorical", "sequential", "diverging"))

  expect_true("spring" %in% pals$categorical)
  expect_true("crimson_seq" %in% pals$sequential)
  expect_true("crimson_blue" %in% pals$diverging)
})

# --- Test default parameters ---
test_that("functions use correct defaults", {
  # cam_palette defaults to "spring"
  expect_equal(cam_palette(), cam_palette("spring"))

  # cam_pal defaults to "spring"
  set.seed(123)
  expect_equal(cam_pal()(5), cam_pal("spring")(5))

  # cam_cols defaults to "spring"
  expect_equal(cam_cols(3), cam_cols(3, "spring"))
})
