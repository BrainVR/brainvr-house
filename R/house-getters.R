#' @importFrom brainvr.reader get_trial_times
get_trial_times.house <- function(obj, i_trial){
  results_trial <- obj$data$results_log$data[obj$data$results_log$data$Trial == i_trial, ]
  # First action in the trial
  exp_trial <- get_trial_experiment_log.house(obj, i_trial)

  # This is kinda weird and I hope it actually works
  # Because there is no record of trial starting, I calculate it as athe time of the
  # first action minus duration to that action
  return(list(waitingToStart = exp_trial$Time[1] - exp_trial$Duration[1],
              start = exp_trial$Time[1] - exp_trial$Duration[1],
              end = tail(exp_trial$Time, 1)))
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
  if(has_object_positions(exp_log)){
    positions <- exp_log[, c("x", "z", "y", "RightWrong", "ObjectName")]
  } else {
    positions <- exp_log[, c("player_x", "player_z", "player_y", "RightWrong", "ObjectName")]
    colnames(positions) <- c("x", "z", "y", "RightWrong", "ObjectName")
  }
  return(positions)
}

get_item_correct_location <- function(location, deviation){
  # calculates distances
  distances <- apply(item_spawn_locations[, c("x", "y")], 1, navr::euclid_distance, location)
  i_location <- which((distances - abs(deviation))  < 1.2)
  if(length(i_location) == 0){
    warning("No location is deviated ", deviation, " from given location")
    return(NULL)
  }
  if(length(i_location) > 1){
    warning("More than one location is deviated ", deviation, " from given location")
    return(NULL)
  }
  location <- list(location = item_spawn_locations$location[i_location],
                   position = item_spawn_locations[i_location, c("x", "y")])
  return(location)
}
