

# Criar tabela com os 10 filmes com maiores orcamentos

library(dplyr)

imdb <- readr::read_rds("dados/imdb.rds")

imdb %>%
  select(titulo, orcamento) %>%
  arrange(desc(orcamento)) %>%
  slice(1, 2, 3, 4, 5, 6, 7, 8)

# outra maneira de se fazer
imdb %>%
  select(titulo, orcamento) %>%
  slice_max(order_by = orcamento, n = 10)

# e para pegar os menores?
imdb %>%
  select(titulo, orcamento) %>%
  slice_min(order_by = orcamento, n = 10)


# maneira r base na parte do slice

imdb_orcamentos <- imdb %>%
  select(titulo, orcamento) %>%
  arrange(desc(orcamento))

imdb_orcamentos[1:10,]

# sem pipe
arrange(select(imdb, titulo, orcamento), desc(orcamento))

# Parenteses sobre startsWith
dplyr::starts_with("casa", "c")
dplyr::starts_with()
startsWith(c("casa", "predio", "cscola"), "c")
stringr


# mudando a ordem das colunas

imdb %>%
  select(titulo, diretor, ano)

imdb %>%
  select(orcamento, everything())

imdb %>%
  relocate(starts_with("ator"))


# slice_max com coluna de texto

imdb %>%
  slice_min(order_by = titulo, n = 10)


# -------------------------------------------------------------------------


# Tirar Nas da base

imdb %>%
  tidyr::drop_na(orcamento)

imdb %>%
  filter(!is.na(orcamento))

imdb %>%
  na.exclude()

imdb %>%
  na.omit()

filter(.data = imdb, orcamento > 1000, nota_imdb > 6.6)


filter(is.na())


imdb <- imdb %>%
  mutate(lucro = receita - orcamento)

imdb %>%
  mutate(orcamento = orcamento / 100000)


tibble::rownames_to_column(mtcars, "marca_do_carro") %>% as_tibble()

# -------------------------------------------------------------------------

# Vamos construir um ranking

library(dplyr)
# library(magrittr) # casa do pipe

imdb <- readr::read_rds("dados/imdb.rds")

ranking_lucro <- imdb %>%
  mutate(lucro = receita - orcamento) %>%
  # slice_max(lucro, n = 50) %>%
  arrange(desc(lucro)) %>%
  mutate(ranking_lucro = 1:n()) %>%
  select(ranking_lucro, titulo, lucro)

ranking_nota <- imdb %>%
  # slice_max(nota_imdb, n = 50) %>%
  arrange(desc(nota_imdb)) %>%
  mutate(ranking_nota = 1:n()) %>%
  select(ranking_nota, titulo, nota_imdb)

left_join(
  ranking_lucro,
  ranking_nota,
  by = "titulo"
) %>% View()

left_join(
  ranking_nota,
  ranking_lucro,
  by = "titulo"
) %>% View()

imdb[1,]


# -------------------------------------------------------------------------

# group_by com outros verbos

# pegar o filme de maior lucro para cada diretor

imdb %>%
  mutate(lucro = receita - orcamento) %>%
  group_by(diretor) %>%
  filter(lucro == max(lucro)) %>%
  select(titulo, diretor, lucro) %>%
  arrange(desc(lucro)) %>%
  View()

# filtrando tbm apenas diretores que fizeram 2 filmes ou mais
imdb %>%
  mutate(lucro = receita - orcamento) %>%
  group_by(diretor) %>%
  filter(lucro == max(lucro), n() >= 2) %>%
  select(titulo, diretor, lucro) %>%
  arrange(desc(lucro)) %>%
  View()



ranking_lucro <- imdb %>%
  mutate(lucro = receita - orcamento) %>%
  slice_max(lucro, n = 50) %>%
  # arrange(desc(lucro)) %>%
  mutate(ranking_lucro = 1:n()) %>%
  select(ranking_lucro, titulo, lucro)

ranking_nota <- imdb %>%
  slice_max(nota_imdb, n = 50) %>%
  # arrange(desc(nota_imdb)) %>%
  mutate(ranking_nota = 1:n()) %>%
  select(ranking_nota, titulo, nota_imdb)

left_join(
  ranking_lucro,
  ranking_nota,
  by = "titulo"
) %>% View()

imdb %>%
  summarise(num_filmes = n())





