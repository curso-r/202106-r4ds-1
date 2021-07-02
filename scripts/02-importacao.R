## install.packages("tidyverse")

library(tidyverse)

# Caminhos até o arquivo --------------------------------------------------

# Caminhos absolutos
"/home/william/Documents/Curso-R/main-r4ds-1/dados/imdb.csv"

# Caminhos relativos
"dados/imdb.csv"

# (cara(o) professora(o), favor lembrar de falar da dica
# de navegação entre as aspas)

"dados/imdb.csv"

# Tibbles -----------------------------------------------------------------

airquality
class(airquality)
as_tibble(airquality)
class(as_tibble(airquality))

# Lendo arquivos de texto -------------------------------------------------

imdb_csv <- read_csv("dados/imdb.csv")

# CSV, separado por vírgula
imdb_csv <- read_csv(file = "dados/imdb.csv")

glimpse(imdb_csv)

# ERRO!! O arquivo é separado por ponto e virgula, e a função
# espera a separacao por virgula
View(read_csv("dados/imdb2.csv"))

# CSV, separado por ponto-e-vírgula
imdb_csv2 <- read_csv2(file = "dados/imdb2.csv")

# TXT, separado por tabulação (tecla TAB)
imdb_txt <- read_delim(file = "dados/imdb.txt", delim = "\t")

# A função read_delim funciona para qualquer tipo de separador
imdb_delim <- read_delim("dados/imdb.csv", delim = ",")
imdb_delim2 <- read_delim("dados/imdb2.csv", delim = ";")

# direto da internet
imdb_csv_url <- read_csv("https://raw.githubusercontent.com/curso-r/202005-r4ds-1/master/dados/imdb.csv")

# Interface point and click do RStudio também é útil!

library(readr)
imdb2 <- read_delim("dados/imdb2.csv", ";",
                    escape_double = FALSE, trim_ws = TRUE)
View(imdb2)

# Lendo arquivos do Excel -------------------------------------------------
# install.packages("readxl")
library(readxl)

imdb_excel <- read_excel("dados/imdb.xlsx")
excel_sheets("dados/imdb.xlsx")

?read_excel()

read_excel("dados/imdb.xlsx", sheet = "Sheet1")

# Salvando dados ----------------------------------------------------------

# As funções iniciam com 'write'


# CSV
write_csv(imdb_csv, file = "imdb.csv")

# Excel
library(writexl)
write_xlsx(imdb_excel, path = "imdb.xlsx")

# O formato rds -----------------------------------------------------------

# .rds são arquivos binários do R
# Você pode salvar qualquer objeto do R em formato .rds

imdb_rds <- readr::read_rds("dados/imdb.rds")
# equivalente do base: readRDS()

readr::write_rds(imdb_rds, file = "dados/imdb_rds.rds")
# equivalente do base:  saveRDS()

# função do base
# Função diferente:   ?save() - é para salvar o .RData


# EXTRA!
# importando dados do google sheets -----------

url <- "https://docs.google.com/spreadsheets/d/1y3oRSspAKQzLyAx2F3cpj89RiTI88wVf-hYZb4oRiuA/edit?usp=sharing"

# install.packages("googlesheets4")
library(googlesheets4)
library(janitor)

dados_formulario <- read_sheet(url)

# dados_formulario$`Em qual estado você mora?`

#install.packages("janitor")

dados_limpo <- clean_names(dados_formulario)

# dados_limpo$em_qual_estado_voce_mora

