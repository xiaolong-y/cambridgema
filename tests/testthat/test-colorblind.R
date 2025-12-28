# ==============================================================================
# TEST FILE: test-colorblind.R
# Tests for colorblind accessibility functions
# ==============================================================================

# --- Test check_colorblind ---
test_that("check_colorblind works with palette names", {
  result <- check_colorblind("spring")
  expect_type(result, "list")
  expect_true("passes" %in% names(result))
  expect_true("normal" %in% names(result))
})

test_that("check_colorblind works with color vectors", {
  colors <- c("#E8B4BC", "#B70E2B", "#9AB54A", "#3A7D44", "#6CA6CD")
  result <- check_colorblind(colors)
  expect_type(result, "list")
  expect_true("passes" %in% names(result))
})

test_that("check_colorblind returns numeric distances", {
  result <- check_colorblind("autumn")
  expect_true(is.numeric(result$normal))
  expect_true(result$normal > 0)
})

test_that("check_colorblind respects threshold parameter", {
  # Very high threshold should likely fail
  result_high <- check_colorblind("spring", min_dist = 100)
  # Very low threshold should likely pass
  result_low <- check_colorblind("spring", min_dist = 1)

  # Low threshold should be more likely to pass
  expect_true(result_low$passes || !result_high$passes)
})

# --- Test with colorspace if available ---
test_that("check_colorblind uses colorspace when available", {
  skip_if_not_installed("colorspace")

  result <- check_colorblind("spring")
  expect_true("deuteranopia" %in% names(result))
  expect_true("protanopia" %in% names(result))
  expect_true("tritanopia" %in% names(result))
})

# --- Test simulate_cvd ---
test_that("simulate_cvd returns transformed colors", {
  skip_if_not_installed("colorspace")

  colors <- cam_palette("spring")
  deutan <- simulate_cvd(colors, "deuteranopia")

  expect_length(deutan, length(colors))
  expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", deutan)))
  # Colors should be different after simulation
  expect_false(all(deutan == colors))
})

test_that("simulate_cvd handles all CVD types", {
  skip_if_not_installed("colorspace")

  colors <- cam_palette("autumn")

  deutan <- simulate_cvd(colors, "deuteranopia")
  protan <- simulate_cvd(colors, "protanopia")
  tritan <- simulate_cvd(colors, "tritanopia")

  expect_length(deutan, 5)
  expect_length(protan, 5)
  expect_length(tritan, 5)
})

test_that("simulate_cvd errors on invalid type", {
  skip_if_not_installed("colorspace")

  expect_error(simulate_cvd(cam_palette("spring"), "invalid"))
})

# --- Test plot_colorblind_sim ---
test_that("plot_colorblind_sim runs without error", {
  skip_if_not_installed("colorspace")

  expect_no_error({
    pdf(NULL)
    on.exit(dev.off())
    plot_colorblind_sim("spring")
  })
})

test_that("plot_colorblind_sim works with custom colors", {
  skip_if_not_installed("colorspace")

  colors <- c("#E8B4BC", "#B70E2B", "#9AB54A")
  expect_no_error({
    pdf(NULL)
    on.exit(dev.off())
    plot_colorblind_sim(colors)
  })
})
