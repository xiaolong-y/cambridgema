# Generate palette showcase images for README
# Run this after installing cantabcolors to create showcase images

library(cantabcolors)
library(ggplot2)
library(grid)

# Create directories
dir.create("man/figures", recursive = TRUE, showWarnings = FALSE)

# ==============================================================================
# 1. Create a beautiful palette showcase
# ==============================================================================

create_palette_strip <- function(palette_name, show_names = TRUE) {
  colors <- cam_palette(palette_name)
  n <- length(colors)
  
  # Create data frame
  df <- data.frame(
    x = 1:n,
    y = 1,
    fill = colors,
    label = names(colors)
  )
  
  p <- ggplot(df, aes(x = x, y = y)) +
    geom_tile(aes(fill = I(fill)), width = 1, height = 1) +
    theme_void() +
    theme(
      plot.margin = margin(5, 5, 5, 5),
      plot.title = element_text(size = 14, face = "bold", hjust = 0, 
                                margin = margin(0, 0, 10, 0)),
      plot.subtitle = element_text(size = 10, hjust = 0, 
                                   margin = margin(0, 0, 5, 0))
    ) +
    coord_fixed(ratio = 1)
  
  if (show_names) {
    p <- p + 
      geom_text(aes(label = label), angle = 45, size = 2.5, 
                hjust = 1, vjust = 1.2, color = "black") +
      labs(title = toupper(palette_name))
  } else {
    p <- p + labs(title = toupper(palette_name))
  }
  
  return(p)
}

# Create individual palette strips
palettes_list <- list(
  spring = "Fresh Pond serviceberry & maple flowers",
  summer = "Cambridge Common wildflowers",
  autumn = "New England asters & maple leaves",
  winter = "Holly, pine, and Charles River ice",
  river = "Charles River blues"
)

# Generate combined palette display
png("man/figures/all_palettes.png", width = 800, height = 1000, res = 100)
grid.newpage()
pushViewport(viewport(layout = grid.layout(5, 1)))

for (i in 1:5) {
  palette_name <- names(palettes_list)[i]
  print(create_palette_strip(palette_name, show_names = TRUE),
        vp = viewport(layout.pos.row = i, layout.pos.col = 1))
}
dev.off()

# ==============================================================================
# 2. Create a simple swatch grid
# ==============================================================================

png("man/figures/swatches.png", width = 800, height = 600, res = 100)
par(mfrow = c(5, 1), mar = c(0.5, 4, 0.5, 0.5), oma = c(0, 0, 2, 0))

for (pal_name in names(palettes_list)) {
  colors <- cam_palette(pal_name)
  n <- length(colors)
  barplot(rep(1, n), col = colors, border = NA, axes = FALSE, space = 0)
  mtext(pal_name, side = 2, las = 1, line = 1, cex = 0.9, font = 2)
}

mtext("cantabcolors palettes", outer = TRUE, cex = 1.5, font = 2, line = 0.5)
dev.off()

# ==============================================================================
# 3. Create individual palette cards
# ==============================================================================

for (pal_name in names(palettes_list)) {
  colors <- cam_palette(pal_name)
  n <- length(colors)
  
  png(paste0("man/figures/palette_", pal_name, ".png"), 
      width = 600, height = 150, res = 100)
  
  par(mar = c(3, 0, 2, 0))
  barplot(rep(1, n), col = colors, border = "white", axes = FALSE, 
          space = 0, main = toupper(pal_name), cex.main = 1.2)
  
  # Add color names
  text(seq(0.5, by = 1, length.out = n), -0.1, 
       names(colors), srt = 45, adj = 1, xpd = TRUE, cex = 0.7)
  
  # Add hex codes
  text(seq(0.5, by = 1, length.out = n), 0.5, 
       colors, cex = 0.8, col = ifelse(pal_name == "winter" & 
                                       grepl("snow|granite", names(colors)), 
                                       "black", "white"))
  dev.off()
}

# ==============================================================================
# 4. Create a color comparison chart
# ==============================================================================

png("man/figures/color_comparison.png", width = 1000, height = 600, res = 100)

# Set up the plot area
par(mar = c(8, 8, 3, 2), las = 2)

# Create matrix of all colors
all_pals <- c("spring", "summer", "autumn", "winter", "river")
max_colors <- 5
color_matrix <- matrix(NA, nrow = length(all_pals), ncol = max_colors)

for (i in 1:length(all_pals)) {
  pal_colors <- cam_palette(all_pals[i])
  color_matrix[i, 1:length(pal_colors)] <- pal_colors
}

# Create the plot
plot(NULL, xlim = c(0, max_colors), ylim = c(0, length(all_pals)),
     xlab = "", ylab = "", axes = FALSE, main = "Cambridge Color Palettes")

# Add color rectangles
for (i in 1:nrow(color_matrix)) {
  for (j in 1:ncol(color_matrix)) {
    if (!is.na(color_matrix[i, j])) {
      rect(j - 1, i - 1, j, i, col = color_matrix[i, j], border = "white", lwd = 2)
    }
  }
}

# Add labels
axis(2, at = (1:length(all_pals)) - 0.5, labels = all_pals, tick = FALSE)
axis(1, at = (1:max_colors) - 0.5, labels = paste("Color", 1:max_colors), tick = FALSE)

dev.off()

# ==============================================================================
# 5. Create a simple logo/hex sticker concept
# ==============================================================================

library(hexSticker)
library(ggplot2)

# Create a simple plot for the hex sticker
p_hex <- ggplot() +
  geom_tile(data = data.frame(x = 1:5, y = 1, 
                              fill = cam_palette("autumn")),
            aes(x = x, y = y, fill = I(fill)), height = 0.8) +
  theme_void() +
  theme_transparent()

# Generate hex sticker (optional - requires hexSticker package)
tryCatch({
  sticker(p_hex,
          package = "cantabcolors",
          p_size = 18,
          s_x = 1,
          s_y = 0.75,
          s_width = 1.3,
          s_height = 0.8,
          p_color = cam_colors["granite"],
          h_fill = cam_colors["snow"],
          h_color = cam_colors["charles_blue"],
          filename = "man/figures/logo.png")
}, error = function(e) {
  message("hexSticker package not available - skipping logo generation")
})

# ==============================================================================
# Summary
# ==============================================================================

cat("\n========================================\n")
cat("SHOWCASE IMAGES GENERATED\n")
cat("========================================\n\n")

images_created <- list.files("man/figures", pattern = "\\.png$", full.names = FALSE)
cat("Created images:\n")
for (img in images_created) {
  cat(sprintf("  ✓ man/figures/%s\n", img))
}

cat("\n✅ All showcase images created successfully!\n")
cat("\nYou can now:\n")
cat("1. Run the test script to generate example plots\n")
cat("2. Update the README with your GitHub username\n")
cat("3. Push to GitHub\n\n")