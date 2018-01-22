library(tidyverse)

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ,y=hwy))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = cyl, y = hwy))

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, color=class))

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, alpha=class))

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, shape=class))

# color, size, shape for continuous variables
ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, color=cty))

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, size=cty))

ggplot(data=mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, shape=cty)) # error

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color="blue")

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

ggplot(mapping = aes(x = displ, y = hwy)) + 
  geom_point(data = mpg) + 
  geom_smooth(data = mpg)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

ggplot(data=diamonds) +
  geom_bar(mapping=aes(x=cut, fill=cut))

ggplot(data=diamonds) +
  geom_bar(mapping=aes(x=cut, fill=clarity))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "identity") +
  ggtitle('Position = "identity"')

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "stack") +
  ggtitle('Position = "stack"')

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill") +
  ggtitle('Position = "fill"')

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge") +
  ggtitle('Position = "dodge"')

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter") + 
  ggtitle('Position = "jitter"')

demo <- data.frame(
  a = c("bar_1","bar_2","bar_3"),
  b = c(20, 30, 40)
)

ggplot(data = demo) +
  geom_bar(mapping = aes(x = a, y = b), stat = "identity")

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut), width = 1) + 
  coord_polar()

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = factor(1), fill = cut), width = 1) + 
  coord_polar(theta = "y")

library(nycflights13)

(dec25 <- filter(flights, month == 12, day == 25))

filter(flights, month %in% c(11,12))


df <- data_frame(
  x = c(FALSE, TRUE, FALSE), 
  y = c(TRUE, FALSE, TRUE)
)
