# ==============================================================================
# TEST FILE: test-utils.R
# Tests for utility functions
# ==============================================================================

# --- Test plot_cam_demo ---
test_that("plot_cam_demo runs without error", {
  expect_no_error({
    pdf(NULL)
    on.exit(dev.off())
    plot_cam_demo()
  })
})

test_that("plot_cam_demo returns NULL invisibly", {
  pdf(NULL)
  on.exit(dev.off())
  result <- plot_cam_demo()
  expect_null(result)
})

test_that("plot_cam_demo restores graphical parameters", {
  pdf(NULL)
  on.exit(dev.off())

  # Get initial par settings
  initial_mfrow <- par("mfrow")
  initial_mar <- par("mar")

  # Run the function
  plot_cam_demo()

  # Check that par settings are restored
  expect_equal(par("mfrow"), initial_mfrow)
  expect_equal(par("mar"), initial_mar)
})

# --- Test print_palette ---
test_that("print_palette runs without error", {
  expect_output(print_palette("spring"), "Palette: spring")
  expect_output(print_palette("spring"), "Colors: 5")
})

test_that("print_palette returns colors invisibly", {
  result <- invisible(capture.output(ret <- print_palette("autumn")))
  expect_equal(ret, cam_palette("autumn"))
})

test_that("print_palette shows correct type", {
  expect_output(print_palette("spring"), "categorical")
  expect_output(print_palette("crimson_seq"), "sequential")
  expect_output(print_palette("crimson_blue"), "diverging")
})

# --- Test list_palettes ---
test_that("list_palettes returns all palettes", {
  pals <- list_palettes()

  # Check categorical palettes
  expect_true(all(c("spring", "summer", "autumn", "winter", "river") %in%
                    pals$categorical))

  # Check sequential palettes
  expect_true(all(c("crimson_seq", "river_seq", "foliage_seq") %in%
                    pals$sequential))

  # Check diverging palettes
  expect_true(all(c("crimson_blue", "brick_pine") %in%
                    pals$diverging))
})

test_that("all listed palettes exist", {
  pals <- list_palettes()

  for (pal in unlist(pals)) {
    expect_no_error(cam_palette(pal))
  }
})
