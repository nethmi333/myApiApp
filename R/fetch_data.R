#' Fetch Nobel Prize Laureates
#'
#' @param category Category filter (e.g., 'che' for Chemistry, 'phy' for Physics, 'med', 'lit', 'pea', 'eco')
#' @param year Prize year (optional, e.g., 2020)
#' @return A data frame of Nobel laureates
#' @export
get_nobel_laureates <- function(category = NULL, year = NULL) {

  req <- httr2::request("https://api.nobelprize.org/2.1/laureates")


  if (!is.null(category) && category != "all") {
    req <- req |> httr2::req_url_query(nobelPrizeCategory = category)
  }
  if (!is.null(year) && year != "") {
    req <- req |> httr2::req_url_query(nobelPrizeYear = as.character(year))
  }


  resp <- httr2::req_perform(req)
  parsed <- httr2::resp_body_json(resp)

  laureates <- parsed$laureates
  if (length(laureates) == 0) {
    return(data.frame(
      Name = character(),
      Gender = character(),
      Category = character(),
      Year = integer(),
      Motivation = character(),
      stringsAsFactors = FALSE
    ))
  }


  results <- lapply(laureates, function(x) {

    name <- if (!is.null(x$fullName$en)) x$fullName$en else "Unknown"
    gender <- if (!is.null(x$gender)) x$gender else "Organization"


    prize <- x$nobelPrizes[[1]]
    cat_name <- if (!is.null(prize$category$en)) prize$category$en else "N/A"
    prize_year <- if (!is.null(prize$awardYear)) as.integer(prize$awardYear) else NA
    motivation <- if (!is.null(prize$motivation$en)) prize$motivation$en else "N/A"

    data.frame(
      Name = name,
      Gender = gender,
      Category = cat_name,
      Year = prize_year,
      Motivation = motivation,
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, results)
}
