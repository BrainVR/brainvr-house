#' @noRd
preprocess_house <- function(obj){
  # obj$data$position <- add_area_boundaries(obj$data$position, AREA_BOUNDARIES)
  #' NECESSARY TO come before expeirment because of the "has_item_codes" function
  #' The has_item_codes is currently deduced form experiment log, which is processed
  #' and thus adds them - results then thinks that codes are present and wouldn't process
  #' properly
  obj <- preprocess_house_results(obj)
  obj <- preprocess_house_experiment(obj)
  obj <- preprocess_house_position(obj)
  class(obj) <- append("house", class(obj))
  return(obj)
}

preprocess_house_position <- function(obj){
  obj$data$position$area_boundaries <- AREA_BOUNDARIES
  return(obj)
}

preprocess_house_experiment <- function(obj, language = "CZ"){
  exp <- get_experiment_log(obj)
  exp <- rename_experiment_log_columns(obj)
  exp$RightWrong <- exp$RightWrong == "True"
  colnames(exp)[colnames(exp) == "Time.1"] <- "Duration"
  if(!("Trial" %in% colnames(exp))) exp <- add_trial_column_experiment_log(exp)
  if(!has_item_codes(obj)){
    exp$ObjectName <- convert_name_to_item_code(exp$ObjectName, language)
  }
  player_positions <- as.data.frame(t(sapply(exp$PlayerPosition, unity_vector_to_numeric, USE.NAMES = F)))
  exp[, c("player_x", "player_z", "player_y")] <- positions
  positions <- as.data.frame(t(sapply(exp$ObjectPosition, unity_vector_to_numeric, USE.NAMES = F)))
  exp[, c("x", "z", "y")] <- positions
  obj$data$experiment_log$data <- exp
  return(obj)
}

#' Returns if the expeirment log has object positions
#' The old house logs had only PLAYER positions of returned item,
#' not the item position at the time of being dropped
has_object_positions <- function(exp){
  return("x" %in% colnames(exp))
}

#' renames experiment log columns so all abide by the same standard
rename_experiment_log_columns <- function(obj){
  exp <- get_experiment_log(obj)
  exp <- rename_columns(exp, experiment_log_column_names_convertor)
  obj$data$experiment_log$data <- exp
}

preprocess_house_results <- function(obj){
  res <- get_results_log(obj)
  if(is.null(res)) return(obj)
  if(!("Trial" %in% colnames(res)) & nrow(res) > 0) res$Trial <- 1:nrow(res)
  res <- rename_columns(res, results_log_column_names_convertor)
  res <- remove_parentheses_columns(res, c("TaskItemsList", "ItemsCollectedList", "AdditionalItemsList",
                                           "MissingItemsList", "PlacementItemsList", "PlacementItemsDistances",
                                           "PlacementItemsTimes", "PlacementItemsTrajectories"))
  if(!has_item_codes(obj)){
    res$MissingItemsList <- convert_strings_to_item_codes(res$MissingItemsList, language)
    res$AdditionalItemsList <- convert_strings_to_item_codes(res$AdditionalItemsList, language)
  }
  obj$data$results_log$data <- res
  return(obj)
}

has_item_codes <- function(obj){
  return(TRUE)
  exp_log <- get_experiment_log(obj)
  if(nrow(exp_log) < 1) stop("Experiment log has no information")
  return(grepl("ITEM", exp_log$ObjectName[1]))
}

convert_name_to_item_code <- function(items, language){
  # The [1] is there because some of the items have two IDs in the item_categories data
  codes <- sapply(items, function(x){item_categories$ID[item_categories[[language]] == x][1]}, simplify = TRUE)
  return(codes)
}

#' Used on MissingItemsList and AdditionalItemsList to just replace names with proper CODES
#' takes strings like "potato chips, apple" and returns "ITEM_CHIPS, ITEM_APPLE"
#' @noRd
convert_strings_to_item_codes <- function(strings, language){
  res <- sapply(strings, function(x){paste(convert_name_to_item_code(strsplit(x, ",")[[1]], language), collapse=",")})
  return(res)
}

remove_parentheses_columns <- function(df, columns){
  res <- df
  for(column in columns){
    if(column %in% colnames(df)) res[[column]] <- remove_parentheses(res[[column]])
  }
  return(res)
}

remove_parentheses <- function(strings){
  return(gsub("[()]","", strings))
}

#' renames columns as per conversion table. Conversion table is a data.frame
#' with old_name and new_name columns
rename_columns <- function(df, conversion_table){
  iRenames <- which(colnames(df) %in% conversion_table$old_name)
  colnames(df)[iRenames] <- conversion_table$new_name
  return(df)
}

add_trial_column_experiment_log <- function(exp_log){
  ## Adds trial numbers - last placement signifies next trial
  rl <- rle(exp_log$TestPhase)
  i_placement <- which(rl$values == "placement")
  i_start <- c(1, i_placement[1:length(i_placement) - 1] + 1) #starts for each test_phase
  # sums lengths of phases between two placements
  trial_lenghts <- sapply(1:length(i_placement), function(x){return(sum(rl$lengths[i_start[x]:i_placement[x]]))})
  exp_log$Trial <- rep(1:length(trial_lenghts), trial_lenghts)
  return(exp_log)
}
