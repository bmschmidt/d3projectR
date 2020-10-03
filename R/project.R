

#' @param dataframe
#'
#' Project a dataframe composed with individual x and y points. Will not fully handle clipping.
#'
#' @param lat_field The name of the latitude field. Default 'lat'.
#' @param long_field The name of the longitude field. Default 'long'.
#' @param x_label The name of the y coordinates added. Default 'y'.
#' @param y_label The name of the x coordinates. Default 'x'.
#' @param projection A projection in d3-geo or d3-geo-projection. (Mollweide, Aitoff, etc.)
#' @param ... Additional arguments are passed to the projection.
#'
#' @import dplyr
#' @import rlang
#' @export

d3project_tibble = function(dataframe, lat_field = lat, long_field = long, x_label = x, y_label = y,
                     projection = "Mollweide", ...) {
  # Additional arguments
  ct = V8::v8()

  ct$source(file = system.file("js/d3-array.v2.min.js", package = "d3projectR"))
  ct$source(file = system.file("js/d3-geo.v2.min.js", package = "d3projectR"))
  ct$source(file = system.file("js/d3-geo-projection.v3.min.js", package = "d3projectR"))

  additional_args = list(...)
  args = additional_args %>% imap(~str_glue(".{.y}({jsonlite::toJSON(.x, auto_unbox=TRUE)})")) %>% stringr::str_c(collapse="")
  ct$assign("projection", V8::JS(stringr::str_glue("d3.geo{projection}(){args}")))
  ct$assign("x", dataframe %>% pull({{long_field}}))
  ct$assign("y", dataframe %>% pull({{lat_field}}))

  fr = ct$get("{
    const vals = [];
    for (let i = 0; i < x.length; i++) {
      let p = projection([x[i], y[i]])
      if (p === null) {
        p = [null, null]
      }
      vals.push(p)
    }
    vals}")
  dataframe %>% mutate({{x_label}} := fr[,1], {{y_label}} := fr[,2])
}

