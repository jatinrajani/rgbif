#' Networks metadata.
#' 
#' @template all
#' @export
#' 
#' @param data The type of data to get. Default is all data.
#' @param uuid UUID of the data network provider. This must be specified if data
#'    is anything other than 'all'.
#' @param callopts Further args passed on to GET.
#' @param name THIS IS A DEPRECATED ARGUMENT. data network name search string, 
#'    by default searches all data networks by defining name = ''
#' @param code THIS IS A DEPRECATED ARGUMENT. return networks identified by the 
#'    supplied short identifier code.
#' @param modifiedsince THIS IS A DEPRECATED ARGUMENT. return only records which 
#'    have been indexed or modified on or after the supplied date (format YYYY-MM-DD, 
#'    e.g. 2006-11-28)
#' @param startindex THIS IS A DEPRECATED ARGUMENT. return the subset of the matching 
#'    records that starts at the supplied (zero-based index).
#' @param maxresults THIS IS A DEPRECATED ARGUMENT. max number of results to return
#' 
#' @examples \dontrun{
#' networks()
#' networks(uuid='16ab5405-6c94-4189-ac71-16ca3b753df7')
#' networks(data='endpoint', uuid='16ab5405-6c94-4189-ac71-16ca3b753df7')
#' networks(data='identifier', uuid='16ab5405-6c94-4189-ac71-16ca3b753df7')
#' }
#' @examples \donttest{
#' # should throw error message saying params are deprecated
#' networks(maxresults=10)
#' }

networks <- function(data = 'all', uuid = NULL, callopts=list(), name = NULL, code = NULL, 
  modifiedsince = NULL, startindex = NULL, maxresults = NULL)
{
  calls <- deparse(sys.calls())
  calls_vec <- sapply(c("name", "code", "modifiedsince", "startindex", "maxresults"), 
                      function(x) grepl(x, calls))
  if(any(calls_vec))
    stop("The parameters name, code, modifiedsince, startindex, and maxresults \nhave been removed, and were only relavant in the old GBIF API. \n\nPlease see documentation for this function ?networks.")

  data <- match.arg(data, choices=c('all', 'contact', 'endpoint', 'identifier', 
                                    'tag', 'machineTag', 'comment', 'constituents'))
  
  # Define function to get data
  getdata <- function(x){
    if(!x == 'all' && is.null(uuid))
      stop('You must specify a uuid if data does not equal "all"')
    
    if(is.null(uuid)){
      url <- paste0(gbif_base(), '/network')
    } else
    {
      if(x=='all'){
        url <- sprintf('%s/network/%s', gbif_base(), uuid)
      } else
      {
        url <- sprintf('%s/network/%s/%s', gbif_base(), uuid, x)
      }
    }
    gbif_GET(url, list(), callopts)
  }
  
  # Get data
  if(length(data)==1){ out <- getdata(data) } else
    { out <- lapply(data, getdata) }
  
  out
}
