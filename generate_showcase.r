# ==============================================================================
# Generate Showcase Plots for cambridgema Package
# ==============================================================================
# This script generates all documentation images for the package
# Run from the package root directory

# Setup
library(ggplot2)
library(grid)

# Source package files directly (for development)
source("R/palettes.R")
source("R/cambridgecolors.R")
source("R/scales.R")
source("R/utils.R")
source("R/colorblind.R")

# Create directories
dirs <- c(
  "man/figures",
  "man/figures/colorblind",
  "man/figures/comparison",
  "man/figures/examples"
)
lapply(dirs, function(d) dir.create(d, recursive = TRUE, showWarnings = FALSE))

# ==============================================================================
# 1. ALL PALETTES OVERVIEW
# ==============================================================================

message("Generating all_palettes.png...")

png("man/figures/all_palettes.png", width = 800, height = 800, res = 100)
plot_cam_demo()
dev.off()

# ==============================================================================
# 2. INDIVIDUAL PALETTE CARDS
# ==============================================================================

create_palette_card <- function(pal_name, output_file) {
  colors <- cam_palette(pal_name)
  n <- length(colors)

  png(output_file, width = 600, height = 150, res = 100)
  par(mar = c(2, 0.5, 2, 0.5))

  barplot(rep(1, n), col = colors, border = NA, axes = FALSE,
          space = 0, main = pal_name)

  # Add color names below
  text(x = seq(0.5, n - 0.5, by = 1), y = 0.5,
       labels = names(colors), srt = 45, adj = 1, cex = 0.6)

  dev.off()
}

message("Generating palette cards...")
for (pal in c("spring", "summer", "autumn", "winter", "river")) {
  create_palette_card(pal, paste0("man/figures/palette_", pal, ".png"))
}

# ==============================================================================
# 3. COLORBLIND SIMULATIONS
# ==============================================================================

generate_cvd_plot <- function(pal_name) {
  if (!requireNamespace("colorspace", quietly = TRUE)) {
    message("Skipping CVD plots - colorspace package not installed")
    return(invisible(NULL))
  }

  colors <- unname(cam_palette(pal_name))
  n <- length(colors)

  # Simulate CVD
  deutan <- colorspace::deutan(colors)
  protan <- colorspace::protan(colors)
  tritan <- colorspace::tritan(colors)

  output_file <- paste0("man/figures/colorblind/", pal_name, "_cvd.png")
  png(output_file, width = 1000, height = 400, res = 100)

  par(mfrow = c(4, 1), mar = c(1, 10, 2, 1))

  barplot(rep(1, n), col = colors, border = NA, axes = FALSE, space = 0)
  mtext("Normal", side = 2, las = 1, line = 0.5, font = 2)

  barplot(rep(1, n), col = deutan, border = NA, axes = FALSE, space = 0)
  mtext("Deuteranopia", side = 2, las = 1, line = 0.5, cex = 0.9)

  barplot(rep(1, n), col = protan, border = NA, axes = FALSE, space = 0)
  mtext("Protanopia", side = 2, las = 1, line = 0.5, cex = 0.9)

  barplot(rep(1, n), col = tritan, border = NA, axes = FALSE, space = 0)
  mtext("Tritanopia", side = 2, las = 1, line = 0.5, cex = 0.9)

  title(main = paste("CVD Simulation:", pal_name), outer = TRUE, line = -1)

  dev.off()
}

message("Generating CVD simulations...")
for (pal in unlist(list_palettes())) {
  generate_cvd_plot(pal)
}

# ==============================================================================
# 4. EXAMPLE PLOTS
# ==============================================================================

message("Generating example plots...")

# Heatmap
set.seed(42)
mat <- matrix(rnorm(100), 10, 10)
colnames(mat) <- paste0("V", 1:10)
rownames(mat) <- paste0("R", 1:10)
heatmap_df <- as.data.frame(as.table(mat))
names(heatmap_df) <- c("Row", "Col", "Value")

p_heatmap <- ggplot(heatmap_df, aes(Col, Row, fill = Value)) +
  geom_tile() +
  scale_fill_cam("river_seq", discrete = FALSE) +
  labs(title = "Heatmap with River Sequential Palette") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("man/figures/examples/heatmap.png", p_heatmap,
       width = 8, height = 6, dpi = 150)

# Forest Plot
effects_df <- data.frame(
  subgroup = c("Overall", "Age < 40", "Age >= 40", "Male", "Female"),
  effect = c(0.5, 0.3, 0.7, 0.4, 0.6),
  ci_lower = c(0.3, 0.1, 0.4, 0.2, 0.3),
  ci_upper = c(0.7, 0.5, 1.0, 0.6, 0.9)
)

p_forest <- ggplot(effects_df, aes(x = subgroup, y = effect, color = subgroup)) +
  geom_hline(yintercept = 0, linetype = "dashed", alpha = 0.5) +
  geom_point(size = 4) +
  geom_errorbar(aes(ymin = ci_lower, ymax = ci_upper), width = 0.2, linewidth = 1) +
  scale_color_cam("autumn") +
  labs(title = "Heterogeneous Treatment Effects",
       x = "Subgroup", y = "Effect Size") +
  coord_flip() +
  theme_minimal() +
  theme(legend.position = "none")

ggsave("man/figures/examples/forest_plot.png", p_forest,
       width = 8, height = 5, dpi = 150)

# ROC Curve
roc_df <- data.frame(
  fpr = c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0),
  tpr = c(0, 0.4, 0.6, 0.7, 0.78, 0.84, 0.88, 0.92, 0.95, 0.98, 1.0)
)

p_roc <- ggplot(roc_df, aes(x = fpr, y = tpr)) +
  geom_abline(linetype = "dashed", alpha = 0.5) +
  geom_area(fill = cam_colors["aster_purple"], alpha = 0.2) +
  geom_line(color = cam_colors["aster_purple"], linewidth = 1.5) +
  labs(title = "ROC Curve (AUC = 0.87)",
       x = "False Positive Rate", y = "True Positive Rate") +
  coord_equal() +
  theme_minimal()

ggsave("man/figures/examples/roc_curve.png", p_roc,
       width = 6, height = 6, dpi = 150)

# Time Series
set.seed(123)
dates <- seq(as.Date("2023-01-01"), as.Date("2023-12-31"), by = "week")
n_dates <- length(dates)
ts_df <- data.frame(
  date = dates,
  value = cumsum(rnorm(n_dates, 0.5, 2)),
  lower = NA,
  upper = NA
)
ts_df$lower <- ts_df$value - abs(rnorm(n_dates, 5, 1))
ts_df$upper <- ts_df$value + abs(rnorm(n_dates, 5, 1))

p_ts <- ggplot(ts_df, aes(x = date)) +
  geom_ribbon(aes(ymin = lower, ymax = upper),
              fill = cam_colors["river_sky"], alpha = 0.3) +
  geom_line(aes(y = value), color = cam_colors["charles_blue"], linewidth = 1.2) +
  labs(title = "Time Series with 95% Confidence Band",
       x = "Date", y = "Value") +
  theme_minimal()

ggsave("man/figures/examples/timeseries.png", p_ts,
       width = 10, height = 5, dpi = 150)

# Balance Check
set.seed(42)
balance_df <- data.frame(
  covariate = c(rnorm(200, 0, 1), rnorm(200, 0.1, 1.1)),
  group = rep(c("Control", "Treatment"), each = 200)
)

p_balance <- ggplot(balance_df, aes(x = covariate, fill = group)) +
  geom_density(alpha = 0.7) +
  scale_fill_cam("spring") +
  labs(title = "Covariate Balance Check",
       x = "Baseline Covariate", y = "Density") +
  theme_minimal()

ggsave("man/figures/examples/balance_check.png", p_balance,
       width = 8, height = 5, dpi = 150)

# RD Plot
set.seed(42)
running <- runif(400, -2, 2)
treated <- as.numeric(running >= 0)
outcome <- 3 + 2 * treated + 1.5 * running + 0.5 * treated * running + rnorm(400, 0, 0.5)
rd_df <- data.frame(
  running = running,
  outcome = outcome,
  treated = factor(treated, labels = c("Control", "Treatment"))
)

p_rd <- ggplot(rd_df, aes(x = running, y = outcome)) +
  geom_vline(xintercept = 0, linetype = "dashed", alpha = 0.5) +
  geom_point(aes(color = treated), alpha = 0.4, size = 2) +
  geom_smooth(data = subset(rd_df, running < 0),
              method = "lm", se = TRUE, color = cam_colors["charles_blue"]) +
  geom_smooth(data = subset(rd_df, running >= 0),
              method = "lm", se = TRUE, color = cam_colors["cardinal_flower"]) +
  scale_color_cam("summer") +
  labs(title = "Regression Discontinuity Design",
       x = "Running Variable", y = "Outcome") +
  theme_minimal()

ggsave("man/figures/examples/rd_plot.png", p_rd,
       width = 8, height = 5, dpi = 150)

# DiD Plot
time_data <- expand.grid(
  period = 1:8,
  group = c("Control", "Treatment")
)
time_data$outcome <- with(time_data,
  10 + 0.5 * period + 2 * (group == "Treatment") +
  3 * (group == "Treatment" & period > 4)
)
time_data$outcome <- time_data$outcome + rnorm(nrow(time_data), 0, 0.3)

p_did <- ggplot(time_data, aes(x = period, y = outcome, color = group)) +
  geom_vline(xintercept = 4.5, linetype = "dashed", alpha = 0.5) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3) +
  annotate("text", x = 4.5, y = 17, label = "Treatment", hjust = -0.1) +
  scale_color_cam("winter") +
  labs(title = "Difference-in-Differences",
       x = "Time Period", y = "Outcome") +
  theme_minimal()

ggsave("man/figures/examples/did_plot.png", p_did,
       width = 8, height = 5, dpi = 150)

# Variable Importance
var_imp_df <- data.frame(
  variable = paste0("Var", 1:8),
  importance = c(100, 85, 72, 60, 45, 30, 20, 10)
)
var_imp_df$variable <- factor(var_imp_df$variable,
                               levels = var_imp_df$variable[order(var_imp_df$importance)])

p_varimp <- ggplot(var_imp_df, aes(x = variable, y = importance, fill = importance)) +
  geom_col() +
  scale_fill_gradient(low = cam_colors["river_ice"],
                      high = cam_colors["charles_blue"]) +
  coord_flip() +
  labs(title = "Variable Importance",
       x = "", y = "Relative Importance") +
  theme_minimal() +
  theme(legend.position = "none")

ggsave("man/figures/examples/variable_importance.png", p_varimp,
       width = 7, height = 5, dpi = 150)

# ==============================================================================
# 5. COMPARISON PLOTS (Default ggplot2 vs cambridgema)
# ==============================================================================

message("Generating comparison plots...")

if (requireNamespace("patchwork", quietly = TRUE)) {
  library(patchwork)

  # Scatter comparison
  p_default <- ggplot(iris, aes(Sepal.Width, Sepal.Length, color = Species)) +
    geom_point(size = 3) +
    labs(title = "Default ggplot2") +
    theme_minimal()

  p_cambridgema <- ggplot(iris, aes(Sepal.Width, Sepal.Length, color = Species)) +
    geom_point(size = 3) +
    scale_color_cam("autumn") +
    labs(title = "cambridgema (autumn)") +
    theme_minimal()

  p_comparison <- p_default + p_cambridgema +
    plot_annotation(title = "Comparison: Default vs cambridgema")

  ggsave("man/figures/comparison/scatter_comparison.png", p_comparison,
         width = 12, height = 5, dpi = 150)
}

# ==============================================================================
# 6. SUMMARY
# ==============================================================================

cat("\n========================================\n")
cat("SHOWCASE IMAGES GENERATED\n")
cat("========================================\n\n")

images_created <- list.files("man/figures", pattern = "\\.png$",
                             full.names = FALSE, recursive = TRUE)
cat("Created images:\n")
for (img in images_created) {
  cat(sprintf("  man/figures/%s\n", img))
}

message("\nDone! All plots generated in man/figures/")
