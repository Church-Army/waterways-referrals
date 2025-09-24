## Anonymise data

library(vroom)
library(here)
library(dplyr)
library(digest)
library(janitor)
library(readr)

non_anonymised <-
  vroom(here("data", "wwc-referrals.csv")) |>
  clean_names()

anonymised <-
  select(
    non_anonymised,
    -phone, -address
  )

anonymised <-
  rowwise(anonymised) |>
  mutate(email_hash = sha1(email), .keep = "unused", .after = name) |>
  ungroup()

write_csv(anonymised, here("data", "wwc-referrals-anon.csv"))

file_delete(here("data", "wwc-referrals.csv"))
