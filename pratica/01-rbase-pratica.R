# Importar a base para o R

library(readr)

imdb <- read_rds("dados/imdb.rds")

# Estrutura da base (colunas)
str(imdb)

# Variável resposta: receita

min(imdb$receita, na.rm = TRUE)
max(imdb$receita, na.rm = TRUE)
mean(imdb$receita, na.rm = TRUE)

summary(imdb)



# Podemos contar quantos filmes estão acima
# da receita média e quantos estão abaixo

imdb[1, 1]
receitas <- imdb$receita

receita_media <- mean(imdb$receita, na.rm = TRUE)

receitas > receita_media

sum(c(TRUE, FALSE, TRUE))

as.numeric(c(TRUE, FALSE))

sum(receitas > receita_media, na.rm = TRUE)
