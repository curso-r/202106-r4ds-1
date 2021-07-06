

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










