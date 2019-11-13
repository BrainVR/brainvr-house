#' @importFrom brainvr.reader get_trial_times
get_trial_times.house <- function(obj, i_trial){
  results_trial <- obj$data$results_log$data[obj$data$results_log$data$Trial == i_trial, ]
  # First action in the trial
  exp_trial <- get_trial_experiment_log.house(obj, i_trial)[1, ]
  # This is kinda weird and I hope it actually works
  # Because there is no record of trial starting, I calculate it as athe time of the
  # first action minus duration to that action
  return(list(waitingToStart = exp_trial$Time - exp_trial$Duration,
              start = exp_trial$Time - exp_trial$Duration,
              end = results_trial$TimeFinished))
}

get_trial_experiment_log.house <- function(obj, i_trials = c()){
  exp_log <- get_experiment_log(obj)
  if(length(i_trials) > 0) exp_log <- exp_log[exp_log$Trial %in% i_trials, ]
  return(exp_log)
}


get_items_placement_positions <- function(obj, i_trials = c()){
  exp_log <- get_trial_experiment_log.house(obj, i_trials)
  exp_log <- exp_log[exp_log$TestPhase == "placement", ]
  #puts it in a matrix by columns
  positions <- as.data.frame(t(sapply(exp_log$PlayerPosition, unity_vector_to_numeric, USE.NAMES = F)))
  colnames(positions) <- c("x", "z", "y")
  positions$correct <- exp_log$RightWrong
  positions$name <- exp_log$ObjectName
  return(positions)
}
