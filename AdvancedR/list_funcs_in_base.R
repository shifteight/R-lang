objs <- mget(ls('package:base'), inherits=TRUE)
funs <- Filter(is.function, objs)
