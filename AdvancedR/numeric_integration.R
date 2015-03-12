midpoint <- function(f, a, b) {
  (b - a) * f((a + b) / 2)
}

trapezoid <- function(f, a, b) {
  (b - a) / 2 * (f(a) + f(b))
}

simpson <- function(f, a, b) {
  (b - a) / 6 * (f(a) + 4 * f((a + b) / 2) + f(b))
}

boole <- function(f, a, b) {
  pos <- function(i) a + i * (b - a) / 4
  fi <- function(i) f(pos(i))
  
  (b - a) / 90 *
    (7 * fi(0) + 32 * fi(1) + 12 * fi(2) + 32 * fi(3) + 7 * fi(4))
}

composite <- function(f, a, b, n=10, rule) {
  points <- seq(a, b, length=n+1)
  
  area <- 0
  for (i in seq_len(n)) {
    area <- area + rule(f, points[i], points[i+1])
  }
  
  area
}

composite(sin, 0, pi, n=10, rule=midpoint)
composite(sin, 0, pi, n = 10, rule = trapezoid)
composite(sin, 0, pi, n = 10, rule = simpson)
composite(sin, 0, pi, n = 10, rule = boole)

newton_cotes <- function(coef, open=FALSE) {
  n <- length(coef) + open
  
  function(f, a, b) {
    pos <- function(i) a + i * (b - a) / n
    points <- pos(seq.int(0, length(coef) - 1))
    
    (b - a) / sum(coef) * sum(f(points) * coef)
  }
}

boole <- newton_cotes(c(7, 32, 12, 32, 7))
milne <- newton_cotes(c(2, -1, 2), open=TRUE)
composite(sin, 0, pi, n=10, rule=milne)
