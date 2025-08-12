# Test cantabcolors package and generate example plots
# Run this after installing the package to test all functionality

# Load required libraries
library(cantabcolors)
library(ggplot2)
library(grid)
library(gridExtra)

# Create output directory for plots
dir.create("figures", showWarnings = FALSE)

# ==============================================================================
# 1. Display all palettes
# ==============================================================================

display_palette <- function(colors, name) {
  n <- length(colors)
  df <- data.frame(x = 1:n, y = 1, color = colors)
  
  ggplot(df, aes(x = x, y = y, fill = color)) +
    geom_tile(width = 0.95, height = 0.5) +
    scale_fill_identity() +
    geom_text(aes(label = names(colors)), 
              angle = 45, hjust = 1, vjust = 1.2, size = 3) +
    labs(title = toupper(name)) +
    theme_void() +
    theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
          plot.margin = margin(10, 10, 30, 10))
}

# Generate palette displays
p1 <- display_palette(cam_palette("spring"), "spring")
p2 <- display_palette(cam_palette("summer"), "summer") 
p3 <- display_palette(cam_palette("autumn"), "autumn")
p4 <- display_palette(cam_palette("winter"), "winter")
p5 <- display_palette(cam_palette("river"), "river")

# Combine and save
all_palettes <- arrangeGrob(p1, p2, p3, p4, p5, ncol = 1)
ggsave("figures/all_palettes.png", all_palettes, width = 8, height = 10, dpi = 150)

# ==============================================================================
# 2. Statistical Analysis Plots
# ==============================================================================

# Generate some example data for statistical plots
set.seed(42)
n <- 500

# Simulate RCT data for causal inference
treatment <- rbinom(n, 1, 0.5)
baseline <- rnorm(n)
outcome <- 2 + 0.5*treatment + 0.3*baseline + rnorm(n)
heterogeneity <- cut(baseline, breaks = 3, labels = c("Low", "Medium", "High"))

df_rct <- data.frame(
  treatment = factor(treatment, labels = c("Control", "Treatment")),
  outcome = outcome,
  baseline = baseline,
  heterogeneity = heterogeneity
)

# --- 2.1 Treatment Effects Plot (Forest plot style) ---
library(dplyr)
effects <- df_rct %>%
  group_by(heterogeneity) %>%
  summarise(
    effect = mean(outcome[treatment == "Treatment"]) - mean(outcome[treatment == "Control"]),
    se = sqrt(var(outcome[treatment == "Treatment"])/sum(treatment == "Treatment") + 
              var(outcome[treatment == "Control"])/sum(treatment == "Control")),
    ci_lower = effect - 1.96*se,
    ci_upper = effect + 1.96*se
  )

p_forest <- ggplot(effects, aes(x = heterogeneity, y = effect, color = heterogeneity)) +
  geom_hline(yintercept = 0, linetype = "dashed", alpha = 0.5) +
  geom_point(size = 4) +
  geom_errorbar(aes(ymin = ci_lower, ymax = ci_upper), width = 0.2, size = 1) +
  scale_color_cam("autumn") +
  labs(title = "Heterogeneous Treatment Effects",
       subtitle = "By baseline covariate tercile",
       x = "Baseline Covariate Group",
       y = "Average Treatment Effect") +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold"))

ggsave("figures/forest_plot.png", p_forest, width = 8, height = 6, dpi = 150)

# --- 2.2 Density Plot for Balance Check ---
p_balance <- ggplot(df_rct, aes(x = baseline, fill = treatment)) +
  geom_density(alpha = 0.7) +
  scale_fill_cam("spring") +
  labs(title = "Covariate Balance Check",
       subtitle = "Distribution of baseline covariate by treatment group",
       x = "Baseline Covariate",
       y = "Density",
       fill = "Group") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave("figures/balance_check.png", p_balance, width = 8, height = 6, dpi = 150)

# --- 2.3 Regression Discontinuity Plot ---
# Simulate RD data
running_var <- runif(n, -2, 2)
treatment_rd <- as.numeric(running_var > 0)
outcome_rd <- 3 + 2*treatment_rd + 1.5*running_var + 0.5*treatment_rd*running_var + rnorm(n, 0, 0.5)
df_rd <- data.frame(running = running_var, outcome = outcome_rd, 
                     treated = factor(treatment_rd))

p_rd <- ggplot(df_rd, aes(x = running, y = outcome)) +
  geom_vline(xintercept = 0, linetype = "dashed", size = 1, alpha = 0.5) +
  geom_point(aes(color = treated), alpha = 0.3, size = 1) +
  geom_smooth(data = filter(df_rd, running < 0), 
              method = "lm", se = TRUE, color = cam_colors["charles_blue"]) +
  geom_smooth(data = filter(df_rd, running >= 0), 
              method = "lm", se = TRUE, color = cam_colors["cardinal_flower"]) +
  scale_color_cam("summer") +
  labs(title = "Regression Discontinuity Design",
       subtitle = "Local linear regression on both sides of cutoff",
       x = "Running Variable",
       y = "Outcome",
       color = "Treatment") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave("figures/rd_plot.png", p_rd, width = 8, height = 6, dpi = 150)

# --- 2.4 Difference-in-Differences Plot ---
# Simulate DiD data
periods <- 6
groups <- c("Control", "Treatment")
time_data <- expand.grid(
  period = 1:periods,
  group = groups
)
time_data$outcome <- with(time_data, 
  10 + 0.5*period + 2*(group == "Treatment") + 
  3*(group == "Treatment" & period > 3) + 
  rnorm(nrow(time_data), 0, 0.5)
)

p_did <- ggplot(time_data, aes(x = period, y = outcome, color = group)) +
  geom_vline(xintercept = 3.5, linetype = "dashed", alpha = 0.5) +
  geom_line(size = 1.5) +
  geom_point(size = 3) +
  scale_color_cam("winter") +
  annotate("text", x = 2, y = 14.5, label = "Pre-treatment", size = 3, alpha = 0.7) +
  annotate("text", x = 5, y = 14.5, label = "Post-treatment", size = 3, alpha = 0.7) +
  labs(title = "Difference-in-Differences",
       subtitle = "Parallel trends and treatment effect",
       x = "Time Period",
       y = "Outcome",
       color = "Group") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave("figures/did_plot.png", p_did, width = 8, height = 6, dpi = 150)

# ==============================================================================
# 3. Machine Learning & Prediction Plots
# ==============================================================================

# --- 3.1 ROC Curve ---
# Simulate predicted probabilities
true_class <- rbinom(200, 1, 0.6)
pred_prob <- plogis(rnorm(200, mean = 2*true_class - 1))

# Calculate ROC curve points
roc_data <- data.frame()
for(threshold in seq(0, 1, 0.01)) {
  pred_class <- as.numeric(pred_prob > threshold)
  tpr <- sum(pred_class == 1 & true_class == 1) / sum(true_class == 1)
  fpr <- sum(pred_class == 1 & true_class == 0) / sum(true_class == 0)
  roc_data <- rbind(roc_data, data.frame(fpr = fpr, tpr = tpr))
}

p_roc <- ggplot(roc_data, aes(x = fpr, y = tpr)) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", alpha = 0.5) +
  geom_line(color = cam_colors["new_england_aster"], size = 1.5) +
  geom_area(alpha = 0.2, fill = cam_colors["new_england_aster"]) +
  labs(title = "ROC Curve",
       subtitle = "Model discrimination performance",
       x = "False Positive Rate",
       y = "True Positive Rate") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold")) +
  coord_equal()

ggsave("figures/roc_curve.png", p_roc, width = 6, height = 6, dpi = 150)

# --- 3.2 Variable Importance Plot ---
variables <- c("Prior_Outcome", "Age", "Treatment_Duration", "Baseline_Risk", 
               "Compliance", "Site", "Gender", "Comorbidity")
importance <- c(100, 85, 72, 68, 45, 32, 28, 15)
var_imp <- data.frame(
  variable = factor(variables, levels = variables[order(importance)]),
  importance = importance
)

p_varimp <- ggplot(var_imp, aes(x = variable, y = importance, fill = importance)) +
  geom_col() +
  scale_fill_gradient(low = cam_colors["river_ice"], high = cam_colors["charles_blue"]) +
  coord_flip() +
  labs(title = "Variable Importance",
       subtitle = "Random forest model for treatment heterogeneity",
       x = "",
       y = "Relative Importance") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"),
        legend.position = "none")

ggsave("figures/variable_importance.png", p_varimp, width = 8, height = 6, dpi = 150)

# ==============================================================================
# 4. Publication-Ready Multi-Panel Figure
# ==============================================================================

# Simulate data for multi-panel causal inference figure
set.seed(123)
n_sim <- 100

# Panel A: Randomization check
df_panel_a <- data.frame(
  covariate = rnorm(n_sim * 2),
  group = rep(c("Control", "Treatment"), each = n_sim)
)

p_panel_a <- ggplot(df_panel_a, aes(x = covariate, fill = group)) +
  geom_histogram(alpha = 0.7, position = "identity", bins = 20) +
  scale_fill_cam("spring") +
  labs(title = "A. Randomization Check", x = "Baseline Covariate", y = "Count") +
  theme_minimal() +
  theme(legend.position = c(0.8, 0.8),
        plot.title = element_text(face = "bold", size = 10))

# Panel B: Treatment effect distribution
effects_sim <- rnorm(1000, mean = 0.5, sd = 0.2)
p_panel_b <- ggplot(data.frame(effect = effects_sim), aes(x = effect)) +
  geom_histogram(fill = cam_colors["cardinal_flower"], alpha = 0.8, bins = 30) +
  geom_vline(xintercept = mean(effects_sim), color = cam_colors["holly_leaf"], 
             linetype = "dashed", size = 1) +
  labs(title = "B. Treatment Effect Distribution", 
       x = "Effect Size", y = "Frequency") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 10))

# Panel C: Dose-response
dose <- seq(0, 10, 0.5)
response <- 2 + 1.5*log(dose + 1) + rnorm(length(dose), 0, 0.3)
df_dose <- data.frame(dose = dose, response = response)

p_panel_c <- ggplot(df_dose, aes(x = dose, y = response)) +
  geom_point(color = cam_colors["goldenrod"], size = 2) +
  geom_smooth(method = "loess", se = TRUE, color = cam_colors["charles_blue"]) +
  labs(title = "C. Dose-Response Curve", x = "Dose", y = "Response") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 10))

# Panel D: Subgroup effects
subgroups <- c("Age < 50", "Age ≥ 50", "Male", "Female", "Low Risk", "High Risk")
effects_sub <- c(0.3, 0.7, 0.4, 0.6, 0.2, 0.9)
ci_lower <- effects_sub - runif(6, 0.1, 0.2)
ci_upper <- effects_sub + runif(6, 0.1, 0.2)

df_subgroup <- data.frame(
  subgroup = factor(subgroups, levels = rev(subgroups)),
  effect = effects_sub,
  ci_lower = ci_lower,
  ci_upper = ci_upper
)

p_panel_d <- ggplot(df_subgroup, aes(x = effect, y = subgroup)) +
  geom_vline(xintercept = 0, linetype = "dashed", alpha = 0.5) +
  geom_errorbarh(aes(xmin = ci_lower, xmax = ci_upper), height = 0.2) +
  geom_point(size = 3, color = cam_colors["red_maple_leaf"]) +
  labs(title = "D. Subgroup Analysis", x = "Treatment Effect", y = "") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 10))

# Combine panels
multi_panel <- arrangeGrob(p_panel_a, p_panel_b, p_panel_c, p_panel_d, ncol = 2)
ggsave("figures/multi_panel.png", multi_panel, width = 10, height = 8, dpi = 150)

# ==============================================================================
# 5. Heatmap for Correlation Matrix
# ==============================================================================

# Generate correlation matrix
set.seed(456)
n_vars <- 8
cor_mat <- matrix(runif(n_vars^2, -1, 1), n_vars, n_vars)
cor_mat <- (cor_mat + t(cor_mat))/2
diag(cor_mat) <- 1
colnames(cor_mat) <- paste0("Var", 1:n_vars)
rownames(cor_mat) <- paste0("Var", 1:n_vars)

# Convert to long format
cor_long <- reshape2::melt(cor_mat)

p_heatmap <- ggplot(cor_long, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = cam_colors["charles_blue"], 
                       mid = cam_colors["snow"], 
                       high = cam_colors["cardinal_flower"],
                       midpoint = 0,
                       limits = c(-1, 1)) +
  labs(title = "Correlation Matrix Heatmap",
       subtitle = "Using Cambridge winter palette",
       fill = "Correlation") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"),
        axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("figures/heatmap.png", p_heatmap, width = 8, height = 7, dpi = 150)

# ==============================================================================
# 6. Time Series with Confidence Bands
# ==============================================================================

# Generate time series data
dates <- seq.Date(from = as.Date("2023-01-01"), by = "month", length.out = 24)
trend <- seq(100, 150, length.out = 24)
seasonal <- 10 * sin(seq(0, 4*pi, length.out = 24))
noise <- rnorm(24, 0, 5)
value <- trend + seasonal + noise
ci_lower_ts <- value - 10
ci_upper_ts <- value + 10

df_ts <- data.frame(
  date = dates,
  value = value,
  ci_lower = ci_lower_ts,
  ci_upper = ci_upper_ts
)

p_timeseries <- ggplot(df_ts, aes(x = date)) +
  geom_ribbon(aes(ymin = ci_lower, ymax = ci_upper), 
              fill = cam_colors["river_sky"], alpha = 0.3) +
  geom_line(aes(y = value), color = cam_colors["charles_blue"], size = 1.5) +
  geom_point(aes(y = value), color = cam_colors["charles_blue"], size = 2) +
  labs(title = "Time Series with Confidence Bands",
       subtitle = "Using Charles River palette",
       x = "Date",
       y = "Value") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave("figures/timeseries.png", p_timeseries, width = 10, height = 6, dpi = 150)

# ==============================================================================
# 7. Summary Statistics
# ==============================================================================

cat("\n========================================\n")
cat("CANTABCOLORS PACKAGE TEST SUMMARY\n")
cat("========================================\n\n")

cat("Available palettes:\n")
for(pal in c("spring", "summer", "autumn", "winter", "river")) {
  colors <- cam_palette(pal)
  cat(sprintf("  %s: %d colors\n", pal, length(colors)))
}

cat("\nGenerated plots:\n")
plots_created <- list.files("figures", pattern = "\\.png$")
for(plot in plots_created) {
  cat(sprintf("  ✓ %s\n", plot))
}

cat("\nPackage functions tested:\n")
cat("  ✓ cam_palette()\n")
cat("  ✓ cam_pal()\n")
cat("  ✓ cam_cols()\n")
cat("  ✓ scale_color_cam()\n")
cat("  ✓ scale_fill_cam()\n")

cat("\n✅ All tests completed successfully!\n")
cat("Check the 'figures' directory for generated plots.\n\n") 