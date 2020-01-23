experiment_log_pairs <- list(
  c("Timestamp", "Time"),
  c("Test_phase", "TestPhase"),
  c("Player_possition", "PlayerPosition"),
  c("Object_name", "ObjectName"),
  c("Action", "Action"),
  c("Right_action", "RightWrong"),
  c("Object_possition", "ObjectPosition"),
  c("Placement_deviation","Deviation"),
  c("Action_trajectory","Trajectory"),
  c("Action_time","Duration")
)

experiment_log_column_names_convertor <- data.frame(matrix(unlist(experiment_log_pairs), ncol = 2, byrow = TRUE), stringsAsFactors = FALSE)
colnames(experiment_log_column_names_convertor) <- c("old_name", "new_name")
usethis::use_data(experiment_log_column_names_convertor, overwrite = TRUE)

# THIS IS CURRENTLY WRONG AND NEEDS TO BE CORRECTED
results_log_pairs <- list(
  c("Timestamp", "TimeFinished"),
  c("Task_objects", "TaskItems"),
  c("Task_objects_list", "TaskItemsList"),
  c("Objects_collected","ItemsCollected"),
  c("Objects_collected_list","ItemsCollectedList"),
  c("Additional_objects", "AdditionalItems"),
  c("Additional_objects_list","AdditionalItemsList"),
  c("Missing_objects", "MissingItems"),
  c("Missing_objects_list", "MissingItemsList"),
  c("Placement_time", "PlacementTime"),
  c("Placement_trajectory", "PlacementTrajectory"),
  c("Placement_order_list", "PlacementItemsList"),
  c("Object_order_errors", "PlacementItemsOrderErrors"),
  c("Location_order_errors", "PlacementItemsDistanceErrors"),
  c("Location_order_distances", "PlacementItemsDistances"),
  c("Placement_objects_times", " PlacementItemsTimes"),
  c("Placement_objects_trajectories", "PlacementItemsTrajectories")
)

results_log_column_names_convertor <- data.frame(matrix(unlist(results_log_pairs), ncol = 2, byrow = TRUE), stringsAsFactors = FALSE)
colnames(results_log_column_names_convertor) <- c("old_name", "new_name")
usethis::use_data(results_log_column_names_convertor, overwrite = TRUE)
