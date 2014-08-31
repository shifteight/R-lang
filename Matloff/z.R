pdf("xh.pdf")
hist(rnorm(100000))
dev.off()

# counts the number of odds in x
oddcount <- function(x) {
  k <- 0
  for (n in x) {
    if (n %% 2 == 1) k <- k + 1
  }
  return(k)
}

f <- function(x) {
  y <- y - 1
  return(x+y)
}

y <- 3
f(5)

first1 <- function(x) {
  for (i in 1:length(x)) {
    if (x[i] == 1) break
  }
  return(i)
}

findruns <- function(x,k) {
  n <- length(x)
  runs <- NULL
  for (i in 1:(n-k+1)) {
    if (all(x[i:(i+k-1)] == 1)) runs <- c(runs, i)
  }
  return(runs)
}

findruns1 <- function(x,k) {
  n <- length(x)
  runs <- vector(length=n)
  count <- 0
  for (i in 1:(n-k+1)) {
    if (all(x[i:(i+k-1)] == 1)) {
      count <- count + 1
      runs[count] <- i
    }
  }
  if (count > 0) {
    runs <- runs[1:count]
  } else runs <- NULL
  return(runs)
}

# adds random noise to img, at the range rows,cols of img; img and the
# return value are both objects of class pixmap; the parameter q
# controls the weight of the noise, with the result being 1-q times the
# original image plus q times the random noise
blurpart <- function(img,rows,cols,q) {
  lrows <- length(rows)
  lcols <- length(cols)
  newimg <- img
  randomnoise <- matrix(nrow=lrows, ncol=lcols,runif(lrows*lcols))
  newimg@grey[rows,cols] <- (1-q) * img@grey[rows,cols] + q * randomnoise
  return(newimg)
}

makecov <- function(rho, n) {
  m <- matrix(nrow=n, ncol=n)
  m <- ifelse(row(m) == col(m), 1, rho)
  return(m)
}

copymaj <- function(rw, d) {
  maj <- sum(rw[1:d]) / d
  return(if(maj > 0.5) 1 else 0)
}

# find outliers, return index
findols <- function(x) {
  findol <- function(xrow) {
    mdn <- median(xrow)
    devs <- abs(xrow-mdn)
    return(which.max(devs))
  }
  return(apply(x,1,findol))
}

# returns the minimum value of d[i,j], i != j, and the row/col attaining
# that minimum, for square symmetric matrix d; no special policy on ties
mind <- function(d) {
  n <- nrow(d)
  # add a column to identify row number for apply()
  dd <- cbind(d,1:n)
  wmins <- apply(dd[-n,],1,imin)
  # wmins will be 2xn, 1st row being indices and 2nd being values
  i <- which.min(wmins[2,])
  j <- wmins[1,i]
  return(c(d[i,j],i,j))
}

# finds the location, value of the minimum in a row x
imin <- function(x) {
  lx <- length(x)
  i <- x[lx] # original row number
  j <- which.min(x[(i+1):(lx-1)])
  k <- i+j
  return(c(k,x[k]))
}

# if the smallest element is unique
minda <- function(d) {
  smallest <- min(d)
  ij <- which(d == smallest, arr.ind=TRUE)
  return(c(smallest, ij))
}

findwords <- function(tf) {
  # read in the words from the file, into a vector of mode character
  txt <- scan(tf,"")
  wl <- list()
  for (i in 1:length(txt)) {
    wrd <- txt[i]
    wl[[wrd]] <- c(wl[[wrd]],i)
  }
  return(wl)
}

# sorts wrdlst, the output of findwords() alphabetically by word
alphawl <- function(wrdlst) {
  nms <- names(wrdlst) # the words
  sn <- sort(nms) # same words in alpha order
  return(wrdlst[sn]) # return rearranged version
}

# orders the output of findwords() by word frequency
freqwl <- function(wrdlst) {
  freqs <- sapply(wrdlst,length)
  return(wrdlst[order(freqs)])
}