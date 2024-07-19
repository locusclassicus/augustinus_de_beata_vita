library(readr)
library(stringr)
library(tippy)

text <- readLines("DE BEATA VITA.txt")

text

new_text <- str_replace_all(text,
                             "(?<!^)\\[(\\w+)\\]",
                             "{{id='\\1'}}</span>") |> 
  str_replace_all("(\\w+)(?=\\{)", "<span style='color:blue;'> [\\1]")


new_text

new_text2 <- str_replace(new_text, "^\\[([a-z]+)\\](.+)$",
            "tippy::tippy_this(elementId = '\\1', 
            tooltip = '\\2', theme = 'light')")

idx <- which(str_detect(new_text2, "^tippy"))

main <- new_text2[-idx] |> 
  str_c(collapse = "\n\n")


comm <- new_text2[idx] |> 
  str_c(collapse = "\n ")


my_qmd <- str_glue("---
title: 'De vita beata'
format: html
fontsize: '16pt'
toc: true
---

```{{r setup, include=FALSE}}
knitr::opts_chunk$set(echo = FALSE)
library(tippy)
```", "\n", main, "\n",  "```{{r}}", "\n", comm, "\n", "```")

#my_qmd <- str_replace_all(my_qmd, "\\s{2}(?=###)", "\\n\\n")

write_lines(my_qmd, "index.qmd")
