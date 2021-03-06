#' @importFrom brainvr.reader plot_trial_path
plot_trial_path.house <- function(obj, i_trial, background = FALSE, background_type = "topdown", custom_background = NULL, ...){
  navr_obj <- get_trial_position(obj, i_trial)
  g <- ggplot() + geom_navr_limits(navr_obj)+ theme_void()
  if(background){
    if(background_type == "topdown") background_path <- BACKGROUND_TOPDOWN_PATH
    if(!is.null(custom_background)) background_path <- custom_background
    g <- g + geom_navr_background(background_path, xlim=AREA_BOUNDARIES$x, ylim = AREA_BOUNDARIES$y)
  }
  g <- g + geom_navr_path(navr_obj, ...)
  df_placed <- get_items_placement_positions(obj, i_trial)
  g <- g + geom_items(df_placed)
  return(g)
}


geom_items <- function(df_items){
  res <- list(geom_point(data = df_items, aes(x, y, color = RightWrong, size = 2)),
             geom_label(data = df_items, aes(x, y, label = ObjectName, fill = RightWrong),
                       position = position_jitter(width=1, height=1),
                       fontface = "bold", colour = "white"))
  return(res)
}

geom_item_spawn_locations <- function(){
   res <- list(geom_point(data = item_spawn_locations, aes(x, y, size = 2), color = "white"),
             geom_label(data = item_spawn_locations, aes(x, y, label = location),
                       position = position_jitter(width=2, height=2),
                       fill = "blue", fontface = "bold", colour = "white"))
   return(res)
}
