function(rw, d) {
  maj <- sum(rw[1:d]) / d
  return(if(maj>0.5) 1 else 0)
}
