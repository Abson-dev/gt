context("Ensuring that the `cols_width()` function works as expected")

# Create a table with four columns of values
tbl <-
  dplyr::tribble(
    ~col_1, ~col_2, ~col_3, ~col_4,
    767.6,  928.1,  382.0,  674.5,
    403.3,  461.5,   15.1,  242.8,
    686.4,   54.1,  282.7,   56.3,
    662.6,  148.8,  984.6,  928.1,
    198.5,   65.1,  127.4,  219.3,
    132.1,  118.1,   91.2,  874.3,
    349.7,  307.1,  566.7,  542.9,
    63.7,  504.3,  152.0,  724.5,
    105.4,  729.8,  962.4,  336.4,
    924.2,  424.6,  740.8,  104.2)

# Function to skip tests if Suggested packages not available on system
check_suggests <- function() {
  skip_if_not_installed("rvest")
  skip_if_not_installed("xml2")
}

# Gets the HTML attr value from a single key
selection_value <- function(html, key) {

  selection <- paste0("[", key, "]")

  html %>%
    rvest::html_nodes(selection) %>%
    rvest::html_attr(key)
}

# Gets the inner HTML text from a single value
selection_text <- function(html, selection) {

  html %>%
    rvest::html_nodes(selection) %>%
    rvest::html_text()
}

test_that("the function `cols_width()` works correctly", {

  # Check that specific suggested packages are available
  check_suggests()

  # Create a `tbl_html` object with `gt()` and size
  # all columns to `100px`
  tbl_html <-
    gt(tbl) %>%
    cols_width(
      vars(col_1) ~ px(100),
      vars(col_2) ~ px(100),
      vars(col_3) ~ px(100),
      vars(col_4) ~ px(100)
    )

  # Expect that the all column widths are set to `100px`
  tbl_html %>%
    render_as_html() %>%
    tidy_grepl(
      paste0(
      "<colgroup>\n\\s*?<col style=\"width: 100px\"/>\n\\s*?",
      "<col style=\"width: 100px\"/>\n\\s*?<col style",
      "=\"width: 100px\"/>\\s*?<col style=\"width: 100px\"/>\\s*?",
      "</colgroup>")
    ) %>%
    expect_true()

  # Create a `tbl_html` object with `gt()` and size the
  # first two columns to `100px` and the remaining columns
  # to `70px`
  tbl_html <-
    gt(tbl) %>%
    cols_width(
      vars(col_1) ~ px(100),
      vars(col_2) ~ px(100),
      TRUE ~ px(70)
    )

  # Expect that the first two column widths are
  # set to `100px`, and the rest are `70px`
  tbl_html %>%
    render_as_html() %>%
    tidy_grepl(
      paste0(
        "<colgroup>\n\\s*?<col style=\"width: 100px\"/>\n\\s*?",
        "<col style=\"width: 100px\"/>\n\\s*?<col style",
        "=\"width: 70px\"/>\\s*?<col style=\"width: 70px\"/>\\s*?",
        "</colgroup>")
    ) %>%
    expect_true()

  # Create a `tbl_html` object with `gt()` and size the
  # first two columns to `100px`; the uncaptured columns
  # will get default width of `100px` (a warning will be
  # given)
  tbl_html <-
    suppressWarnings(
      gt(tbl) %>%
        cols_width(
          vars(col_1) ~ px(150),
          vars(col_2) ~ px(150)
        )
    )

  # Expect that the first two column widths are
  # set to `150px`, and the rest are `100px`
  suppressWarnings(
    tbl_html %>%
      render_as_html() %>%
      tidy_grepl(
        paste0(
          "<colgroup>\n\\s*?<col style=\"width: 150px\"/>\n\\s*?",
          "<col style=\"width: 150px\"/>\n\\s*?<col style",
          "=\"width: 100px\"/>\\s*?<col style=\"width: 100px\"/>\\s*?",
          "</colgroup>")
      )) %>%
    expect_true()

  # Create a `tbl_html` object with `gt()` and assign
  # a width of `150px` to all columns with the
  # `everything()` column select helper
  tbl_html <-
    gt(tbl) %>%
    cols_width(
      everything() ~ px(150)
    )

  # Expect that the all column widths are set to `150px`
  tbl_html %>%
    render_as_html() %>%
    tidy_grepl(
      paste0(
        "<colgroup>\n\\s*?<col style=\"width: 150px\"/>\n\\s*?",
        "<col style=\"width: 150px\"/>\n\\s*?<col style",
        "=\"width: 150px\"/>\\s*?<col style=\"width: 150px\"/>\\s*?",
        "</colgroup>")
    ) %>%
    expect_true()

  # Create a `tbl_html` object with `gt()` and assign
  # a width of `150px` to all columns with the
  # `starts_with()` column select helper
  tbl_html <-
    gt(tbl) %>%
    cols_width(
      starts_with("col") ~ px(150)
    )

  # Expect that the all column widths are set to `150px`
  tbl_html %>%
    render_as_html() %>%
    tidy_grepl(
      paste0(
        "<colgroup>\n\\s*?<col style=\"width: 150px\"/>\n\\s*?",
        "<col style=\"width: 150px\"/>\n\\s*?<col style",
        "=\"width: 150px\"/>\\s*?<col style=\"width: 150px\"/>\\s*?",
        "</colgroup>")
    ) %>%
    expect_true()

  # Create a `tbl_html` object with `gt()` and assign
  # a width of `150px` to the first column using the
  # `ends_with()` column select helper
  tbl_html <-
    gt(tbl) %>%
    cols_width(
      ends_with("1") ~ px(150),
      TRUE ~ px(100)
    )

  # Expect that the first column width is set to
  # `150px`, and the rest are `100px`
  tbl_html %>%
    render_as_html() %>%
    tidy_grepl(
      paste0(
        "<colgroup>\n\\s*?<col style=\"width: 150px\"/>\n\\s*?",
        "<col style=\"width: 100px\"/>\n\\s*?<col style",
        "=\"width: 100px\"/>\\s*?<col style=\"width: 100px\"/>\\s*?",
        "</colgroup>")
    ) %>%
    expect_true()

  # Create a `tbl_html` object with `gt()` and assign
  # a width of `150px` to all columns with the
  # `contains()` column select helper
  tbl_html <-
    gt(tbl) %>%
    cols_width(
      contains("_") ~ px(150)
    )

  # Expect that the all column widths are set to `150px`
  tbl_html %>%
    render_as_html() %>%
    tidy_grepl(
      paste0(
        "<colgroup>\n\\s*?<col style=\"width: 150px\"/>\n\\s*?",
        "<col style=\"width: 150px\"/>\n\\s*?<col style",
        "=\"width: 150px\"/>\\s*?<col style=\"width: 150px\"/>\\s*?",
        "</colgroup>")
    ) %>%
    expect_true()

  # Create a `tbl_html` object with `gt()` and assign
  # a width of `150px` to all columns with the
  # `matches()` column select helper
  tbl_html <-
    gt(tbl) %>%
    cols_width(
      matches("col_[0-9]") ~ px(150)
    )

  # Expect that the all column widths are set to `150px`
  tbl_html %>%
    render_as_html() %>%
    tidy_grepl(
      paste0(
        "<colgroup>\n\\s*?<col style=\"width: 150px\"/>\n\\s*?",
        "<col style=\"width: 150px\"/>\n\\s*?<col style",
        "=\"width: 150px\"/>\\s*?<col style=\"width: 150px\"/>\\s*?",
        "</colgroup>")
    ) %>%
    expect_true()

  # Create a `tbl_html` object with `gt()` and assign
  # a width of `150px` to the first two columns with the
  # `one_of()` column select helper
  tbl_html <-
    gt(tbl) %>%
    cols_width(
      one_of(c("col_1", "col_2")) ~ px(150),
      TRUE ~ px(100)
    )

  # Expect that the first two column widths are set to
  # `150px`, and the rest are `100px`
  tbl_html %>%
    render_as_html() %>%
    tidy_grepl(
      paste0(
        "<colgroup>\n\\s*?<col style=\"width: 150px\"/>\n\\s*?",
        "<col style=\"width: 150px\"/>\n\\s*?<col style",
        "=\"width: 100px\"/>\\s*?<col style=\"width: 100px\"/>\\s*?",
        "</colgroup>")
    ) %>%
    expect_true()

  # Create a `tbl_html` object with `gt()` and size the
  # first column to `175px` and the remaining columns
  # to `75px`; this uses multiple formulas with the first
  # column in the RHS (the expectation is that the first
  # formula will give the resultant width value)
  tbl_html <-
    gt(tbl) %>%
    cols_width(
      vars(col_1) ~ px(175),
      vars(col_1) ~ px(150),
      vars(col_1) ~ px(125),
      TRUE ~ px(75)
    )

  # Expect that the first column width is set to
  # `175px`, and the rest are `75px`
  tbl_html %>%
    render_as_html() %>%
    tidy_grepl(
      paste0(
        "<colgroup>\n\\s*?<col style=\"width: 175px\"/>\n\\s*?",
        "<col style=\"width: 75px\"/>\n\\s*?<col style",
        "=\"width: 75px\"/>\\s*?<col style=\"width: 75px\"/>\\s*?",
        "</colgroup>")
    ) %>%
    expect_true()

  # Create a `tbl_html` object with `gt()` and size the
  # first column to `150px` and the remaining columns
  # to `75px` in one call to `cols_width()`, and, make
  # a second call to `cols_width()` that sets the
  # first column to `250px`
  tbl_html <-
    gt(tbl) %>%
    cols_width(
      vars(col_1) ~ px(150),
      TRUE ~ px(75)
    ) %>%
    cols_width(
      vars(col_1) ~ px(250),
      TRUE ~ px(75)
    )

  # Expect that the first column width is set to
  # `250px`, and the rest are `75px`
  tbl_html %>%
    render_as_html() %>%
    tidy_grepl(
      paste0(
        "<colgroup>\n\\s*?<col style=\"width: 250px\"/>\n\\s*?",
        "<col style=\"width: 75px\"/>\n\\s*?<col style",
        "=\"width: 75px\"/>\\s*?<col style=\"width: 75px\"/>\\s*?",
        "</colgroup>")
    ) %>%
    expect_true()

  # Expect an error if a column provided is not
  # in the dataset
  expect_error(
    gt(tbl) %>%
      cols_width(
        vars(col_10) ~ px(150),
        TRUE ~ px(75)
      )
  )

  # Expect an error if no expressions given to `...`
  expect_error(
    gt(tbl) %>%
      cols_width()
  )
})
