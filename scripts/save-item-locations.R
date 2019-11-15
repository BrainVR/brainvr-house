#' Item locations are in a file with a data.frame
#' Data frame has two columns:
#' location: name of the location
#' position: (x, y, z) string
#'
#' Example:
#' location; position
#' Garage; (-1,0,11)
#' Hall; (5,11,12.4)

item_spawn_locations <- read.table("spawn_points_emthouse.txt", sep=";", header=TRUE)

positions <- t(sapply(item_spawn_locations$position, brainvr.reader::unity_vector_to_numeric))
item_spawn_locations$position <- NULL
item_spawn_locations[, c("x", "z", "y")] <- positions

usethis::use_data(item_spawn_locations, overwrite = TRUE)
