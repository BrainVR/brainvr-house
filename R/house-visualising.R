#' @importFrom brainvr.reader plot_trial_path
plot_trial_path.house <- function(obj, i_trial){
  navr_obj <- get_trial_position(obj, i_trial)
  plt <- navr::plot_path(navr_obj)
  plt <- plt + navr::geom_navr_limits(navr_obj)
  df_placed <- get_items_placement_positions(obj, i_trial)
  plt <- plt + geom_items(df_placed)
  return(plt)
}


geom_items <- function(df_items){
  res <- list(geom_point(data = df_items, aes(x, y, color = correct, size = 2)),
             geom_label(data = df_items, aes(x, y, label = name, fill = correct),
                       position = position_jitter(width=1, height=1),
                       fontface = "bold", colour = "white"))
  return(res)
}
