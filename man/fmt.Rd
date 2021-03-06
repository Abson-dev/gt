% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/format_data.R
\name{fmt}
\alias{fmt}
\title{Set a column format with a formatter function}
\usage{
fmt(data, columns = NULL, rows = NULL, fns)
}
\arguments{
\item{data}{A table object that is created using the \code{\link[=gt]{gt()}} function.}

\item{columns}{The columns to format. Can either be a series of column names
provided in \code{\link[=vars]{vars()}}, a vector of column indices, or a helper function
focused on selections. The select helper functions are: \code{\link[=starts_with]{starts_with()}},
\code{\link[=ends_with]{ends_with()}}, \code{\link[=contains]{contains()}}, \code{\link[=matches]{matches()}}, \code{\link[=one_of]{one_of()}}, and \code{\link[=everything]{everything()}}.}

\item{rows}{Optional rows to format. Not providing any value results in all
rows in \code{columns} being formatted. Can either be a vector of row captions
provided \code{\link[=c]{c()}}, a vector of row indices, or a helper function focused on
selections. The select helper functions are: \code{\link[=starts_with]{starts_with()}},
\code{\link[=ends_with]{ends_with()}}, \code{\link[=contains]{contains()}}, \code{\link[=matches]{matches()}}, \code{\link[=one_of]{one_of()}}, and \code{\link[=everything]{everything()}}.
We can also use expressions to filter down to the rows we need (e.g.,
\verb{[colname_1] > 100 & [colname_2] < 50}).}

\item{fns}{Either a single formatting function or a named list of functions.}
}
\value{
An object of class \code{gt_tbl}.
}
\description{
The \code{fmt()} function provides greater control in formatting raw data values
than any of the specialized \verb{fmt_*()} functions that are available in
\strong{gt}. Along with the \code{columns} and \code{rows} arguments that provide some
precision in targeting data cells, the \code{fns} argument allows you to define
one or more functions for manipulating the raw data.
If providing a single function to \code{fns}, the recommended format is in the
form: \code{fns = function(x) ...}. This single function will format the targeted
data cells the same way regardless of the output format (e.g., HTML, LaTeX,
RTF).
If you require formatting of \code{x} that depends on the output format, a list of
functions can be provided for the \code{html}, \code{latex}, and \code{default} contexts.
This can be in the form of \code{fns = list(html = function(x) ..., latex = function(x) ..., default = function(x) ...)}. In this multiple-function case,
we recommended including the \code{default} function as a fallback if all contexts
aren't provided.
}
\details{
As with all of the \verb{fmt_*()} functions, targeting of values is done through
\code{columns} and additionally by \code{rows} (if nothing is provided for \code{rows} then
entire columns are selected). A number of helper functions exist to make
targeting more effective. Conditional formatting is possible by providing a
conditional expression to the \code{rows} argument. See the Arguments section for
more information on this.
}
\section{Figures}{

\if{html}{\figure{man_fmt_1.svg}{options: width=100\%}}
}

\section{Function ID}{

3-11
}

\examples{
# Use `exibble` to create a gt table;
# format the numeric values in the `num`
# column with a function supplied to
# the `fns` argument
tab_1 <-
  exibble \%>\%
  dplyr::select(-row, -group) \%>\%
  gt() \%>\%
  fmt(
    columns = vars(num),
    fns = function(x) {
      paste0("'", x * 1000, "'")
    }
  )

}
\seealso{
Other Format Data: 
\code{\link{data_color}()},
\code{\link{fmt_currency}()},
\code{\link{fmt_datetime}()},
\code{\link{fmt_date}()},
\code{\link{fmt_markdown}()},
\code{\link{fmt_missing}()},
\code{\link{fmt_number}()},
\code{\link{fmt_passthrough}()},
\code{\link{fmt_percent}()},
\code{\link{fmt_scientific}()},
\code{\link{fmt_time}()},
\code{\link{text_transform}()}
}
\concept{Format Data}
