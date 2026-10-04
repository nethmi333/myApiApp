#' Launch the Nobel Prize Shiny Application
#'
#' @export
run_my_app <- function() {
  app_dir <- system.file("shiny-app", package = "myApiApp")
  if (app_dir == "") {
    stop("Could not find Shiny app directory inside package.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
