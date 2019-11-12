get_trial_times.house <- function(obj, i_trial){
  results_trial <- obj$data$results_log$data[obj$data$results_log$data$Trial == i_trial, ]
  # First action in the trial
  exp_trial <- obj$data$experiment_log$data[obj$data$experiment_log$data$Trial == i_trial, ][1, ]
  # This is kinda weird and I hope it actually works
  # Because there is no record of trial starting, I calculate it as athe time of the
  # first action minus duration to that action
  return(list(waitingToStart = exp_trial$Time - exp_trial$Duration,
              start = exp_trial$Time - exp_trial$Duration,
              end = results_trial$TimeFinished))
}
