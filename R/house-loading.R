#' Loads supermarket experiment data from folder
#'
#' @param folder folder with one or more supermarket experiments
#' @param language language of the items in the experiment log.
#' Only important if you are not logging item codes
#' See language options in [item_categories]. Default is "CZ".
#'
#' @return list with loaded experiments
#' @export
#'
#' @examples
load_house_experiments <- function(folder){
  exps <- load_experiments(folder)
  message("Loaded ", length(exps), " experiments from folder ", folder)
  for(i in 1:length(exps)){
    exp <- preprocess_house(exps[[i]])
    exps[[i]] <- exp
  }
  return(exps)
}
