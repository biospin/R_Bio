

#apt-get -y build-dep libcurl4-gnutls-dev
#apt-get -y install libcurl4-gnutls-dev

install.packages("devtools")
devtools::install_github("rstudio/sparklyr")


library(sparklyr)
spark_install(version = "1.6.1")

# java install require
sc <- spark_connect(master = "local")


install.packages("nycflights13")
install.packages("Lahman")

library(dplyr)
iris_tbl <- copy_to(sc, iris)
flights_tbl <- copy_to(sc, nycflights13::flights, "flights")
batting_tbl <- copy_to(sc, Lahman::Batting, "batting")

src_tbls(sc)

# Using dplyr
flights_tbl %>% filter(dep_delay == 2)


delay <- flights_tbl %>% 
  group_by(tailnum) %>%
  summarise(count = n(), dist = mean(distance), delay = mean(arr_delay)) %>%
  filter(count > 20, dist < 2000, !is.na(delay)) %>%
  collect

install.packages("ggplot2")
library(ggplot2)
ggplot(delay, aes(dist, delay)) +
  geom_point(aes(size = count), alpha = 1/2) +
  geom_smooth() +
  scale_size_area(max_size = 2)


# Using SQL

library(DBI)
iris_preview <- dbGetQuery(sc, "SELECT * FROM iris LIMIT 10")
iris_preview


#
# Machine Learning
#

mtcars_tbl <- copy_to(sc, mtcars)
partitions <- mtcars_tbl %>%
  filter(hp >= 100) %>%
  mutate(cyl8 = cyl == 8) %>%
  sdf_partition(training = 0.5, test = 0.5, seed = 1099)

fit <- partitions$training %>%
  ml_linear_regression(response = "mpg", features = c("wt", "cyl"))
fit

summary( fit )
