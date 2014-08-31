## findwords <- function(tf) {
##   # read in the words from the file, into a vector of mode character
##   txt <- scan(tf, "")
##   wl <- list()
##   for (i in 1:length(txt)) {
##     wrd <- txt[i]  # ith word in input file
##     wl[[wrd]] <- c(wl[[wrd]], i)
##   }
##   return(wl)
## }

findwords <- function(tf) {
    txt <- scan(tf,"")
    words <- split(1:length(txt),txt)
    return(words)
}

# sort wrdlst, the output of findwords() alphabetically by word
alphawl <- function(wrdlst) {
  nms <- names(wrdlst)
  sn <- sort(nms)
  return(wrdlst[sn])
}

# orders the output of findwords() by word frequency
freqwl <- function(wrdlst) {
  freqs <- sapply(wrdlst, length)
  return(wrdlst[order(freqs)])
}
