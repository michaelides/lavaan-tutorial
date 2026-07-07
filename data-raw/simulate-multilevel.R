# -----------------------------------------------------------------------------
# data-raw/simulate-multilevel.R
#
# One-off script generating the synthetic two-level dataset for Tutorial 14
# (Multilevel models). The PS dataset is single-level, so we simulate a small
# nested dataset (employees within teams) suitable for both lme4 random
# intercepts / random slopes and lavaan two-level SEM.
#
# Per Q15e-i analog: built once, committed to data/, used by tutorial 14.
# Re-run only if we want a fresh sim.
#
# Run from the project root:  Rscript data-raw/simulate-multilevel.R
# -----------------------------------------------------------------------------

set.seed(1234)  # Per Q5c-i

n_teams     <- 30        # level-2 units
team_size_range <- 8:15  # employees per team
n_total     <- sum(sample(team_size_range, n_teams, replace = TRUE))

# Level-2 (team) varying coefficients
gamma_00 <- 2.5   # grand intercept
gamma_01 <- 0.35  # effect of team-level X on individual Y
sigma_u0 <- 0.55  # between-team SD of intercepts
sigma_u1 <- 0.10  # between-team SD of slopes

# Level-1 (individual)
gamma_10 <- 0.45   # effect of individual X on Y
sigma_e  <- 0.70   # level-1 residual SD

# Generate team-level X (continuous) and random effects
team_x <- rnorm(n_teams, mean = 0, sd = 1)
u0    <- rnorm(n_teams, mean = 0, sd = sigma_u0)
u1    <- rnorm(n_teams, mean = 0, sd = sigma_u1)
cor_u01 <- 0.1
u1 <- u0 * cor_u01 + u1 * sqrt(1 - cor_u01^2)  # mild corr between u0 and u1

# Compose individual rows
df <- do.call(rbind, lapply(seq_len(n_teams), function(j) {
  n_j <- team_size_range[sample.int(length(team_size_range), 1)]
  x <- rnorm(n_j, mean = 0, sd = 1)
  y <- (gamma_00 + u0[j]) +
       (gamma_10 + u1[j]) * x +
       gamma_01 * team_x[j] +
       rnorm(n_j, mean = 0, sd = sigma_e)
  data.frame(
    employee_id = NA,  # reassigned below with sequential ids
    team_id     = j,
    team_x      = team_x[j],
    ind_x       = x,
    y           = y
  )
}))

# Simpler sequential employee ids
df$employee_id <- paste0("E", sprintf("%04d", seq_len(nrow(df))))

out <- "data/multilevel_sim.csv"
write.csv(df, out, row.names = FALSE)

message("Wrote: ", out)
message("  ", nrow(df), " employees across ", n_teams, " teams")
message("  mean team size: ", round(nrow(df) / n_teams, 2))
message("\nVariance components (population values):")
message("  sigma_u0^2 = ", round(sigma_u0^2, 3))
message("  sigma_u1^2 = ", round(sigma_u1^2, 3))
message("  sigma_e^2  = ", round(sigma_e^2,  3))
