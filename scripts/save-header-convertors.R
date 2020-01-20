pairs <- list(
  c("Timestamp", "Timestamp"),
  c("Test_phase", "TestPhase"),
  c("Player_possition", "PlayerPosition"),
  c("Object_name", "ObjectName"),
  c("Action", "Action"),
  c("Right_action", "RightWrong"),
  c("Object_possition", "ObjectPosition"),
  c("Placement_deviation","Deviation"),
  c("Action_trajectory","Trajectory"),
  c("Action_time","Time")
)

column_names_convertor <- data.frame(matrix(unlist(pairs), ncol = 2, byrow = TRUE), stringsAsFactors = FALSE)
colnames(column_names_convertor) <- c("old_name", "new_name")

usethis::use_data(column_names_convertor, overwrite = TRUE)
