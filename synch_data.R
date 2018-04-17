library(boxr)
library(yaml)
library(tidyverse)

CREDENTIAL_FILE = 'credentials.yml'
BOX_DATA_FOLDER = 'gainlab_example/'

credentials = read_yaml(CREDENTIAL_FILE)

box_auth(client_id = credentials$client_id, 
         client_secret = credentials$client_secret,
         write.Renv = TRUE)
# After running this for the first time if write.Renv = TRUE, credentials are 
# stored in ~/.Renviron and you can authenticate on that machine with just
# `box_auth()`
#
# You can also skip the file and just paste the credentials manually as described 
# in the vignette.
# 
# If you use the file don't forget to put `credentials.yml` into the .gitignore
# or you risk compromising your box account


example_df = data.frame(a = rep(0, 100), b = rep(1, 100))

# Write data to box folder

## Get the id of the box folder (you can also look it up in the browser)
folder_id = box_search('gainlab_example/') %>%
    tbl_df() %>%
    filter(type == 'folder') %>%
    select(id) %>%
    as.character()

write_report = box_write(x = example_df, filename = 'example_df.csv', 
                    dir_id = folder_id)
file_id = write_report$id

## Read data from box    
rm(example_df)
example_df = box_read_csv(file_id = file_id)
