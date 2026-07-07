# -----------------------------------------------------------------------------
# data-raw/simulate-growth.R
#
# One-off script generating the synthetic longitudinal dataset used in
# Tutorial 15 (Growth curve models). The PS teaching dataset is cross-sectional,
# so we generate a simple 3-wave simulated dataset to demonstrate latent growth
# curves in lavaan and growth models in lme4.
#
# Per Q15e-i: built once, committed to data/, used by tutorial 15.
# Re-run only if we want a fresh sim (will change fitted values in the tutorial).
#
# Run from the project root:  Rscript data-raw/simulate-growth.R
# -----------------------------------------------------------------------------

set.seed(1234)  # Per Q5c-i: explicit seed for reproducibility

n_persons <- 250
n_waves   <- 3

# Latent intercept and slope means
mean_i <- 3.5      # starting well-being at time 0
mean_s <- 0.20     # average growth per wave

# Within-person residual variance
sigma_e_sq <- 0.40

# Between-person variance around intercept and slope
var_i <- 0.55
var_s <- 0.06
cor_i_s <- 0.20   # mild correlation between starting point and growth rate

# Draw latent intercepts and slopes
cov_i_s <- cor_i_s * sqrt(var_i * var_s)
cov_mat <- matrix(c(var_i, cov_i_s, cov_i_s, var_s), 2, 2)
latents <- MASS::mvrnorm(n_persons, mu = c(mean_i, mean_s), Sigma = cov_mat)
i_vec <- latents[, 1]
s_vec <- latents[, 2]

# Wide format for lavaan (\eta_i, \eta_s -> 3 observed ys at t = 0, 1, 2)
df_wide <- data.frame(
  id = seq_len(n_persons),
  y1 = i_vec           + 0 * s_vec + rnorm(n_persons, sd = sqrt(sigma_e_sq)),
  y2 = i_vec + 1     * s_vec + rnorm(n_persons, sd = sqrt(sigma_e_sq)),
  y3 = i_vec + 2     * s_vec + rnorm(n_persons, sd = sqrt(sigma_e_sq))
)

# Long format for lme4 (same simulated data, reshaped)
df_long <- data.frame(
  id  = rep(df_wide$id, times = n_waves),
  t   = rep(0:(n_waves - 1), each = n_persons),
  y   = c(df_wide$y1, df_wide$y2, df_wide$y3)
)
df_long <- df_long[order(df_long$id, df_long$t), ]

# Persist to data/
out_wide <- "data/growth_sim_wide.csv"
out_long <- "data/growth_sim_long.csv"
write.csv(df_wide, out_wide, row.names = FALSE)
write.csv(df_long, out_long, row.names = FALSE)

message("Wrote: ", out_wide, " (", nrow(df_wide), " rows)")
message("Wrote: ", out_long, " (", nrow(df_long), " rows)")
message("\nEmpirical means:")
message("  mean(y1) = ", round(mean(df_wide$y1), 3))
message("  mean(y2) = ", round(mean(df_wide$y2), 3))
message("  mean(y3) = ", round(mean(df_wide$y3), 3))
