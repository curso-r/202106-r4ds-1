# Pacotes -----------------------------------------------------------------
# install.packages("tidyverse")
library(tidyverse)

# Base de dados -----------------------------------------------------------

imdb <- read_rds("dados/imdb.rds")

# Jeito de ver a base -----------------------------------------------------

glimpse(imdb)
names(imdb)
View(imdb)

# dplyr: 6 verbos principais
# select()    # seleciona colunas do data.frame
# filter()    # filtra linhas do data.frame
# arrange()   # reordena as linhas do data.frame
# mutate()    # cria novas colunas no data.frame (ou atualiza as colunas existentes)
# summarise() + group_by() # sumariza o data.frame
# left_join()   # junta dois data.frames


# select ------------------------------------------------------------------

# Selcionando uma coluna da base

select(imdb, titulo)

# sinal de atribuicao: <-

# A operação NÃO MODIFICA O OBJETO imdb

imdb

# Selecionando várias colunas

select(imdb, titulo, ano, orcamento)

# dá para mudar a ordem das colunas
select(imdb, orcamento, ano, titulo)

1:10

select(imdb, titulo:cor)

# Funções auxiliares

select(imdb, starts_with("ator_"))
select(imdb, contains("to"))


select(imdb, titulo, starts_with("ator_"))

select(imdb, titulo, starts_with("ator_"), contains("ao"))


# Principais funções auxiliares

# starts_with(): para colunas que começam com um texto padrão
# ends_with(): para colunas que terminam com um texto padrão
# contains():  para colunas que contêm um texto padrão

# Selecionando colunas por exclusão

select(imdb, -starts_with("ator"), -titulo, -ends_with("s"))


# dúvidas

select(imdb, titulo:cor, -ano)

select(imdb, 1:5)

imdb_selecionado <- select(imdb, titulo, orcamento, receita)

# arrange -----------------------------------------------------------------

# Ordenando linhas de forma crescente de acordo com
# os valores de uma coluna

arrange(imdb, orcamento)

# Agora de forma decrescente

arrange(imdb, desc(orcamento))

# Ordenando de acordo com os valores
# de duas colunas

arrange(imdb, desc(ano))

arrange(imdb, desc(ano), desc(orcamento))

# O que acontece com o NA?

df <- tibble(x = c(NA, 2, 1), y = c(1, 2, 3))
df
arrange(df, x)
arrange(df, desc(x))

# Pipe (%>%) --------------------------------------------------------------

View(arrange(imdb, desc(ano), desc(orcamento)))


# Transforma funçõe aninhadas em funções
# sequenciais

# g(f(x)) = x %>% f() %>% g()

x %>% f() %>% g()   # CERTO
x %>% f(x) %>% g(x) # ERRADO

# Receita de bolo sem pipe.
# Tente entender o que é preciso fazer.

esfrie(
  asse(
    coloque(
      bata(
        acrescente(
          recipiente(
            rep(
              "farinha",
              2
            ),
            "água", "fermento", "leite", "óleo"
          ),
          "farinha", até = "macio"
        ),
        duração = "3min"
      ),
      lugar = "forma", tipo = "grande", untada = TRUE
    ),
    duração = "50min"
  ),
  "geladeira", "20min"
)

# Veja como o código acima pode ser reescrito
# utilizando-se o pipe.
# Agora realmente se parece com uma receita de bolo.

recipiente(rep("farinha", 2), "água", "fermento", "leite", "óleo") %>%
  acrescente("farinha", até = "macio") %>%
  bata(duração = "3min") %>%
  coloque(lugar = "forma", tipo = "grande", untada = TRUE) %>%
  asse(duração = "50min") %>%
  esfrie("geladeira", "20min")

# ATALHO DO %>%: CTRL (command) + SHIFT + M

View(arrange(imdb, desc(ano), desc(orcamento)))

# reescreve com o pipe

imdb_ordenado <- imdb %>%
  arrange(desc(ano), desc(orcamento)) %>%
  view() # view minusculo faz parte do tidyverse


# Conceitos importantes para filtros! --------------------------------------

## Comparações lógicas -------------------------------

x <- 1

# Testes com resultado verdadeiro
x == 1
"a" == "a"

# Testes com resultado falso
x == 2
"a" == "b"

# Maior
x > 3
x > 0

# Maior ou igual
x > 1
x >= 1

# Menor
x < 3
x < 0

# Menor ou igual
x < 1
x <= 1

# Diferente
x != 1
x != 2

x %in% c(1, 2, 3)

"a" %in% c("b", "c")


## Operadores lógicos -------------------------------

## & - E - Para ser verdadeiro, os dois lados
# precisam resultar em TRUE

x <- 5
x >= 3 & x <=7


y <- 2
y >= 3 & y <= 7

## | - OU - Para ser verdadeiro, apenas um dos
# lados precisa ser verdadeiro

y <- 2
y >= 3 | y <=7

y <- 1
y >= 3 | y == 0


## ! - Negação - É o "contrário"

!TRUE

!FALSE


w <- 5
(!w < 4)

# filter ------------------------------------------------------------------

filter(imdb, nota_imdb > 9)

# Filtrando uma coluna da base
imdb %>% filter(nota_imdb >= 9)
imdb %>% filter(diretor == "Quentin Tarantino")

# Vendo categorias de uma variável
unique(imdb$cor) # saída é um vetor
imdb %>% distinct(cor) # saída é uma tibble

imdb %>% distinct(classificacao)

imdb %>% distinct(diretor) %>% arrange(diretor) # %>% nrow()

imdb$cor
imdb %>% select(cor)

# Filtrando duas colunas da base

## Recentes e com nota alta
imdb %>% filter(ano > 2010, nota_imdb > 8.5) %>% View()
imdb %>% filter(ano > 2010 & nota_imdb > 8.5)

## Gastaram menos de 100 mil, faturaram mais de 1 milhão
imdb %>% filter(orcamento < 100000, receita > 1000000) %>% View()

## Lucraram
imdb %>% filter(receita - orcamento > 0) %>% View()

## Lucraram mais de 500 milhões OU têm nota muito alta
imdb %>% filter(receita - orcamento > 500000000 | nota_imdb > 9) %>% View()

# O operador %in%

imdb %>% filter(ator_1 %in% c('Angelina Jolie Pitt', "Brad Pitt")) %>% View()



# duvida
pessoas_que_atuam <- c('Angelina Jolie Pitt', "Brad Pitt")
imdb %>% filter(ator_1 %in% pessoas_que_atuam | ator_2 %in% pessoas_que_atuam |
                  ator_3 %in% pessoas_que_atuam ) %>% View()


# Negação
imdb %>% filter(diretor %in% c("Quentin Tarantino", "Steven Spielberg")) %>% View()
imdb %>% filter(!diretor %in% c("Quentin Tarantino", "Steven Spielberg")) %>% View()

# O que acontece com o NA?
df <- tibble(x = c(1, NA, 3))

df

filter(df, x > 1)

filter(df, is.na(x) | x > 1)

# Filtrando texto sem correspondência exata
# A função str_detect()
textos <- c("a", "aa","abc", "bc", "A", NA)

str_detect(textos, pattern = "a")

## Pegando os seis primeiros valores da coluna "generos"
imdb$generos[1:6]

str_detect(
  string = imdb$generos[1:6],
  pattern = "Action"
)

str_detect(
  string = imdb$generos[1:6],
  pattern = "Action|Animation"
)

## Pegando apenas os filmes que
## tenham o gênero ação
imdb %>%
  filter(str_detect(generos, "Action")) %>%
  View()


str_detect(
  string = imdb$classificacao[1:10],
  pattern = "13"
)

# mutate ------------------------------------------------------------------

mutate(imdb, duracao = duracao/60) %>% View()

# Modificando uma coluna

imdb %>%
  mutate(duracao = duracao/60) %>%
  View()

imdb_duracao_em_horas <- imdb %>%
  mutate(duracao = duracao/60)


# write_rds(imdb_duracao_em_horas, "imdb_duracao_em_horas.Rds")

# Criando uma nova coluna

imdb %>%
  mutate(duracao_horas = duracao/60) %>%
  View()

imdb %>%
  mutate(lucro = receita - orcamento) %>%
  View()

# A função ifelse é uma ótima ferramenta
# para fazermos classificação binária

imdb %>% mutate(
  lucro = receita - orcamento,
  houve_lucro = if_else(lucro > 0, "Sim", "Não")
) %>%
  View()


# sugestao do Bruno

imdb %>% mutate(
  lucro = receita - orcamento,
  houve_lucro = lucro > 0
) %>%
  View()



### PERGUNTA: como exportar o arquivo? ----

imdb_lucro <- imdb %>% mutate(
  lucro = receita - orcamento,
  houve_lucro = if_else(lucro > 0, "Sim", "Não")
)

write_csv2(imdb_lucro, "dados/imdb_lucro.csv")
writexl::write_xlsx(imdb_lucro, "dados/imdb_lucro.xlsx")

# cria a pasta dados-export
fs::dir_create("dados-export")

imdb %>%
  mutate(
  lucro = receita - orcamento,
  houve_lucro = if_else(lucro > 0, "Sim", "Não")
) %>%
  write_csv2("dados-export/imdb_lucro_pipe.csv")


# USANDO TRUE E FALSE
imdb %>% mutate(
  lucro = receita - orcamento,
  houve_lucro = if_else(lucro > 0, TRUE, FALSE)
) %>%
  View()

?if_else()




# summarise ---------------------------------------------------------------

# Sumarizando uma coluna

imdb %>% summarise(media_orcamento = mean(orcamento, na.rm = TRUE),
                   media_receita = mean(receita, na.rm = TRUE))

# duvida: diferenca summary e summarize
summary(imdb)
glimpse(imdb)


# repare que a saída ainda é uma tibble


# Sumarizando várias colunas
imdb %>% summarise(
  media_orcamento = mean(orcamento, na.rm = TRUE),
  media_receita = mean(receita, na.rm = TRUE),
  media_lucro = mean(receita - orcamento, na.rm = TRUE)
)

# Diversas sumarizações da mesma coluna
imdb %>% summarise(
  media_orcamento = mean(orcamento, na.rm = TRUE),
  mediana_orcamento = median(orcamento, na.rm = TRUE),
  variancia_orcamento = var(orcamento, na.rm = TRUE)
)

# Tabela descritiva
imdb %>% summarise(
  media_orcamento = mean(orcamento, na.rm = TRUE),
  media_receita = mean(receita, na.rm = TRUE),
  qtd = n(),
  qtd_diretores = n_distinct(diretor)
)



# funcoes que transformam -> N valores
log(1:10)
sqrt()
str_detect()

# funcoes que sumarizam -> 1 valor
mean(c(1, NA, 2))
mean(c(1, NA, 2), na.rm = TRUE)
n_distinct()


# group_by + summarise ----------------------------------------------------

# Agrupando a base por uma variável.

imdb %>% group_by(cor)

imdb %>%
  group_by(cor) %>%
  summarise(qtd = n())

imdb %>%
  group_by(cor) %>%
  summarise(media_orcamento = mean(orcamento, na.rm = TRUE))

imdb %>%
  group_by(diretor) %>%
  summarise(qtd = n()) %>%
  arrange(desc(qtd))


# Agrupando e sumarizando
imdb %>%
  group_by(cor) %>%
  summarise(
    media_orcamento = mean(orcamento, na.rm = TRUE),
    qnt_orcamento_sem_na = sum(!is.na(orcamento)), # dupla
    media_receita = mean(receita, na.rm = TRUE),
    qtd = n(),
    qtd_diretores = n_distinct(diretor)
  )




# left join ---------------------------------------------------------------

# A função left join serve para juntarmos duas
# tabelas a partir de uma chave.
# Vamos ver um exemplo bem simples.

band_members
band_instruments

band_members %>% left_join(band_instruments)


band_instruments %>% left_join(band_members)

# o argumento 'by'
band_members %>% left_join(band_instruments, by = "name")


# o argumento 'by' - quando as bases tem colunas com nomes diferentes
band_members %>%
  rename("nome" = name) %>%
  left_join(band_instruments, by = c("nome" = "name"))


# Fazendo de-para

depara_cores <- tibble(
  cor = c("Color", "Black and White"),
  cor_em_ptBR = c("colorido", "preto e branco")
)

left_join(imdb, depara_cores, by = c("cor")) %>%
  relocate(cor_em_ptBR, .after = cor) %>%
  View()

imdb %>%
  left_join(depara_cores, by = c("cor")) %>%
  select(cor, cor_em_ptBR) %>%
  View()

# OBS: existe uma família de joins

band_instruments %>% left_join(band_members)
band_instruments %>% right_join(band_members)
band_instruments %>% inner_join(band_members)
band_instruments %>% full_join(band_members)
band_instruments %>% anti_join(band_members)

