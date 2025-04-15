.collapse_query_string <- function(value) {
    value <- paste0(value, collapse = ",")
    return(value)
}

.check_leagues <- function(self, leagues) {
    if (!missing(leagues)) {
        if (any(!leagues %in% self$LEAGUES)) {
            stop(glue::glue("Leagues are limited only to the following options: {paste0(self$LEAGUES, collapse = ', ')}."))
        }
    }
}

.check_leagues_salaries <- function(self, leagues) {
    if (!missing(leagues)) {
        if (any(leagues != "mls")) {
            stop("Only MLS salary data is publicly available.")
        }
    }
}

.check_ids_names <- function(ids, names) {
    if ((!missing(ids) & !missing(names)) && (!is.null(ids) & !is.null(names))) {
        stop("Please specify only IDs or names, not both.")
    }

    if (!missing(ids)) {
        if (!is.null(ids) & (!methods::is(ids, "character") | length(ids) < 1)) {
            stop("IDs must be passed as a vector of characters with length >= 1.")
        }
    }

    if (!missing(names)) {
        if (!is.null(names) & (!methods::is(names, "character") | length(names) < 1)) {
            stop("Names must be passed as a vector of characters with length >= 1.")
        }
    }
}

.check_clear_cache <- function(self) {
    .latest_update_timestamp <- .get_latest_update_timestamp(self)
    if (is.null(self$latest_update_timestamp) || .latest_update_timestamp > self$latest_update_timestamp) {
        cli::cat_line("  INFO: New data found. Clearing session cache and refreshing `AmericanSoccerAnalysis` class.", col = "yellow")
        httpcache::clearCache()
        .initialize_entities(self)
        self$latest_update_timestamp <- .latest_update_timestamp
    }
}

#' @importFrom rlang .data
.get_latest_update_timestamp <- function(self) {
    games <- list()

    for (league in self$LEAGUES) {
        url <- glue::glue("{self$base_url}/{league}/games")
        response <- .execute_query(self, url, uncached = )
        games <- append(games, list(response))
    }

    latest_update_timestamp <- data.table::rbindlist(games, fill = TRUE) %>%
        dplyr::pull("last_updated_utc") %>%
        max(na.rm = TRUE) %>%
        as.POSIXct(format="%Y-%m-%d %H:%M:%S", tz="UTC")

    return(latest_update_timestamp)
}

.convert_names_to_ids <- function(df, names) {
    . <- NULL
    names_clean <- .clean_names(names)
    names_string <- paste0(names_clean, collapse = "|")

    ids <- df %>%
        dplyr::mutate(dplyr::across(dplyr::matches("(_name|_abbreviation)$"), .fns = list(clean = ~.clean_names(.)))) %>%
        dplyr::filter(dplyr::if_any(dplyr::ends_with("_clean"), ~grepl(names_string, .))) %>%
        dplyr::select(!dplyr::ends_with("_clean")) %>%
        dplyr::pull(names(.)[which(grepl("_id$", names(.)))])

    return(ids)
}

.clean_names <- function(names) {
    names <- stringi::stri_trans_general(str = names, id = "Latin-ASCII")
    names <- tolower(names)
    return(names)
}

.stop_for_status <- function(r) {
    if (r$status_code == 400) {
        error_message <- r %>%
            httr::content(as = "text", encoding = "UTF-8") %>%
            jsonlite::fromJSON() %>%
            magrittr::extract2("message")

        error_message <- glue::glue("HTTP 400: {error_message}")
        stop(error_message)
    } else if (r$status_code %in% c(404, 502, 503)) {
        error_message <- glue::glue(
            "HTTP {r$status_code}: This resource is temporarily unavailable, or it has been removed. If you believe you are receiving this message in error, please reach out to the maintainer(s). Otherwise, please try again shortly."
        )
        stop(error_message)
    } else if (r$status_code != 200) {
        httr::stop_for_status(r)
    }
}

.single_request <- function(self, url, query, uncached) {
    for (arg_name in names(query)) {
        if (length(query[[arg_name]]) > 1) {
            query[[arg_name]] <- .collapse_query_string(query[[arg_name]])
        }
    }

    if (!uncached) r <- httpcache::GET(url = url, query = query, self$httr_configs)
    if (uncached)  r <- httr::GET(url = url, query = query, self$httr_configs)
    .stop_for_status(r)
    response <- r %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON()

    return(response)
}

.execute_query <- function(self, url, query = list(), uncached = FALSE) {
    tmp_response <- .single_request(self, url, query, uncached)
    response <- tmp_response

    if (is.data.frame(tmp_response)) {
        offset <- self$MAX_API_LIMIT
        addtl_responses <- list()

        while (nrow(tmp_response) == self$MAX_API_LIMIT) {
            query$offset <- offset
            tmp_response <- .single_request(self, url, query, uncached)
            # if we get an empty list or data.frame we should probably break
            if (length(tmp_response) == 0) {
                break
            }

            tmp_response <- .cast_lists_to_vectors(tmp_response)

            addtl_responses <- append(addtl_responses, list(tmp_response))
            offset <- offset + self$MAX_API_LIMIT
        }

        if (length(addtl_responses) > 0) {
            response <- data.table::rbindlist(
                append(list(response), addtl_responses),
                fill = TRUE
            )
        }
    }

    return(response)
}

.cast_lists_to_vectors <- function(df) {
    target_cols <- names(which(sapply(df, mode) == "list"))

    for (target_col in target_cols) {
        idx <- which(sapply(df[[target_col]], class) == "list")
        df[[target_col]][idx] <- lapply(df[[target_col]][idx], unlist)
    }

    return(df)
}

.format_comma <- function(..., .max = 6) {
    x <- paste0(...)
    if (length(x) > .max) {
        length(x) <- .max
        x[[.max]] <- "..."
    }

    paste0(x, collapse = ", ")
}

.format_args <- function(x) {
    args <- if (length(x) == 1) "Argument" else "Arguments"
    glue::glue("{args} {.format_comma(x)}")
}
