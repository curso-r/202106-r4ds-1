
# Carregar pacotes --------------------------------------------------------

library(tidyverse)

# Ler base IMDB -----------------------------------------------------------

library(readr)
library(dplyr)
library(ggplot2)


imdb <- read_rds("dados/imdb.rds")

imdb <- imdb %>% mutate(lucro = receita - orcamento)


# Gráfico de pontos (dispersão) -------------------------------------------


# Apenas o canvas
imdb %>%
  ggplot()

ggplot(imdb)

# Salvando em um objeto=
p <- imdb %>%
  ggplot()

write_rds(p, "grafico.rds")

# Gráfico de dispersão da receita contra o orçamento
imdb %>%
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita))

# Inserindo a reta x = y
# y = a + b*x
#
# y = 0 + 1*x
# y = x

imdb %>%
  ggplot() +
  geom_point(aes(x = orcamento, y = receita)) +
  geom_abline(intercept = 0, slope = 1, color = "red")


# Observe como cada elemento é uma camada do gráfico.
# Agora colocamos a camada da linha antes da camada
# dos pontos.
imdb %>%
  ggplot() +
  geom_abline(intercept = 0, slope = 1, color = "red") +
  geom_point(aes(x = orcamento, y = receita))

# Atribuindo a variável lucro aos pontos
imdb %>%
  ggplot() +
  geom_point(aes(x = orcamento, y = receita, color = lucro))

# Categorizando o lucro antes
imdb %>%
  mutate(
    lucrou = ifelse(lucro <= 0, "Não", "Sim")
  ) %>%
  ggplot() +
  geom_point(aes(x = orcamento, y = receita, color = lucrou))

# Salvando um gráfico em um arquivo
p <- imdb %>%
  mutate(
    lucrou = ifelse(lucro <= 0, "Não", "Sim")
  ) %>%
  ggplot() +
  geom_point(aes(x = orcamento, y = receita, color = lucrou))

ggsave("pratica/meu_grafico.jpeg")
ggsave("meu_grafico_p.png", p)


# Filosofia ---------------------------------------------------------------

# Um gráfico estatístico é uma representação visual dos dados
# por meio de atributos estéticos (posição, cor, forma,
# tamanho, ...) de formas geométricas (pontos, linhas,
# barras, ...). Leland Wilkinson, The Grammar of Graphics

# Layered grammar of graphics: cada elemento do
# gráfico pode ser representado por uma camada e
# um gráfico seria a sobreposição dessas camadas.
# Hadley Wickham, A layered grammar of graphics

# Gráfico de linhas -------------------------------------------------------

# Nota média dos filmes ao longo dos anos

imdb %>%
  group_by(ano) %>%
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>%
  ggplot() +
  geom_line(aes(x = ano, y = nota_media))

# Número de filmes coloridos e preto e branco por ano

imdb %>%
  filter(!is.na(cor)) %>%
  group_by(ano, cor) %>%
  summarise(num_filmes = n()) %>%
  ggplot() +
  geom_line(aes(x = ano, y = num_filmes, color = cor))

# Nota média do Robert De Niro por ano
imdb %>%
  filter(ator_1 == "Robert De Niro") %>%
  group_by(ano) %>%
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>%
  ggplot() +
  geom_line(aes(x = ano, y = nota_media))

# Colocando pontos no gráfico
imdb %>%
  filter(ator_1 == "Robert De Niro") %>%
  group_by(ano) %>%
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>%
  ggplot() +
  geom_line(aes(x = ano, y = nota_media)) +
  geom_point(aes(x = ano, y = nota_media))

# Reescrevendo de uma forma mais agradável
imdb %>%
  filter(ator_1 == "Robert De Niro") %>%
  group_by(ano) %>%
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>%
  ggplot(aes(x = ano, y = nota_media)) +
  geom_line() +
  geom_point()

# Colocando as notas no gráfico
imdb %>%
  filter(ator_1 == "Robert De Niro") %>%
  group_by(ano) %>%
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>%
  mutate(nota_media = round(nota_media, 1)) %>%
  ggplot() +
  geom_line(aes(x = ano, y = nota_media)) +
  geom_label(aes(x = ano, y = nota_media, label = nota_media))

imdb %>%
  filter(ator_1 == "Robert De Niro") %>%
  group_by(ano) %>%
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>%
  mutate(nota_media = round(nota_media, 1)) %>%
  ggplot(aes(x = ano, y = nota_media)) +
  geom_line() +
  geom_label(aes(label = nota_media))


# Gráfico de barras -------------------------------------------------------

# Número de filmes dos diretores da base
imdb %>%
  group_by(diretor) %>%
  summarise(frequencia = n()) %>%
  arrange(desc(frequencia))

imdb %>%
  tidyr::drop_na(diretor) %>%
  # filter(!is.na(diretor)) %>%
  count(diretor, sort = TRUE, name = "frequencia") %>%
  slice_max(frequencia, n = 10) %>%
  # top_n(10, frequencia) %>%
  ggplot() +
  geom_col(aes(x = diretor, y = frequencia))

# Tirando NA e pintando as barras

imdb %>%
  tidyr::drop_na(diretor) %>%
  count(diretor, sort = TRUE, name = "frequencia") %>%
  slice_max(frequencia, n = 10) %>%
  ggplot() +
  geom_col(
    aes(x = diretor, y = frequencia, fill = diretor),
    show.legend = FALSE
  )


imdb %>%
  count(diretor) %>%
  filter(!is.na(diretor)) %>%
  top_n(10, n) %>%
  ggplot() +
  geom_col(
    aes(x = diretor, y = n),
    show.legend = FALSE
  )

# Invertendo as coordenadas

imdb %>%
  tidyr::drop_na(diretor) %>%
  count(diretor, sort = TRUE, name = "frequencia") %>%
  slice_max(frequencia, n = 10) %>%
  ggplot() +
  geom_col(
    aes(y = diretor, x = frequencia, fill = diretor),
    show.legend = FALSE
  )


imdb %>%
  count(diretor) %>%
  filter(!is.na(diretor)) %>%
  top_n(10, n) %>%
  ggplot() +
  geom_col(
    aes(x = n, y = diretor),
    show.legend = FALSE
  )


# Ordenando as barras

imdb %>%
  tidyr::drop_na(diretor) %>%
  count(diretor, sort = TRUE, name = "frequencia") %>%
  slice_max(frequencia, n = 10) %>%
  mutate(
    diretor = forcats::fct_reorder(diretor, frequencia)
  ) %>%
  ggplot() +
  geom_col(
    aes(y = diretor, x = frequencia, fill = diretor),
    show.legend = FALSE
  )



imdb %>%
  count(diretor) %>%
  filter(!is.na(diretor)) %>%
  top_n(10, n) %>%
  mutate(
    diretor = forcats::fct_reorder(diretor, n)
  ) %>%
  ggplot() +
  geom_col(
    aes(x = n, y = diretor, fill = diretor),
    show.legend = FALSE
  )

# Colocando label nas barras

imdb %>%
  tidyr::drop_na(diretor) %>%
  count(diretor, sort = TRUE, name = "frequencia") %>%
  slice_max(frequencia, n = 10) %>%
  mutate(
    diretor = forcats::fct_reorder(diretor, frequencia)
  ) %>%
  ggplot() +
  geom_col(
    aes(y = diretor, x = frequencia, fill = diretor),
    show.legend = FALSE
  ) +
  geom_label(aes(y = diretor, x = frequencia / 2, label = frequencia))






top_10_diretores <- imdb %>%
  count(diretor) %>%
  filter(!is.na(diretor)) %>%
  top_n(10, n)

top_10_diretores %>%
  mutate(
    diretor = forcats::fct_reorder(diretor, n)
  ) %>%
  ggplot() +
  geom_col(
    aes(x = n, y = diretor),
    show.legend = FALSE
  ) +
  geom_label(aes(x = n/2, y = diretor, label = n))


# Histogramas e boxplots --------------------------------------------------

# Histograma do lucro dos filmes do Steven Spielberg
imdb %>%
  filter(diretor == "Steven Spielberg") %>%
  ggplot() +
  geom_histogram(aes(x = lucro))

# Arrumando o tamanho das bases
imdb %>%
  filter(diretor == "Steven Spielberg") %>%
  ggplot() +
  geom_histogram(
    aes(x = lucro),
    binwidth = 100000000,
    color = "white"
  )

# Boxplot do lucro dos filmes dos diretores
# fizeram mais de 15 filmes
imdb %>%
  filter(!is.na(diretor)) %>%
  group_by(diretor) %>%
  filter(n() >= 15) %>%
  ggplot() +
  geom_boxplot(aes(x = diretor, y = lucro))

# Ordenando pela mediana

imdb %>%
  filter(!is.na(diretor)) %>%
  group_by(diretor) %>%
  filter(n() >= 15) %>%
  ungroup() %>%
  mutate(diretor = forcats::fct_reorder(diretor, lucro, na.rm = TRUE)) %>%
  ggplot() +
  geom_boxplot(aes(x = diretor, y = lucro))


# Título e labels ---------------------------------------------------------

# Labels
imdb %>%
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita, color = lucro)) +
  labs(
    x = "Orçamento ($)",
    y = "Receita ($)",
    color = "Lucro ($)",
    title = "Gráfico de dispersão",
    subtitle = "Receita vs Orçamento",
    caption = "Fonte: imdb.com"
  )

# Escalas
imdb %>%
  group_by(ano) %>%
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>%
  ggplot() +
  geom_line(aes(x = ano, y = nota_media)) +
  scale_x_continuous(breaks = seq(1916, 2016, 10)) +
  scale_y_continuous(breaks = seq(0, 10, 2))

# Visão do gráfico
imdb %>%
  group_by(ano) %>%
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>%
  ggplot() +
  geom_line(aes(x = ano, y = nota_media)) +
  scale_x_continuous(breaks = seq(1900, 2020, 10)) +
  scale_y_continuous(breaks = seq(0, 10, 2)) +
  coord_cartesian(ylim = c(0, 10), xlim = c(1940, 2020))

# Cores -------------------------------------------------------------------

# Escolhendo cores pelo nome
imdb %>%
  count(diretor) %>%
  filter(!is.na(diretor)) %>%
  top_n(5, n) %>%
  ggplot() +
  geom_col(
    aes(x = n, y = diretor, fill = diretor),
    show.legend = FALSE
  ) +
  scale_fill_manual(values = c("orange", "royalblue", "purple", "salmon", "darkred"))
# http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf

# Escolhendo pelo hexadecimal
imdb %>%
  count(diretor) %>%
  filter(!is.na(diretor)) %>%
  top_n(5, n) %>%
  ggplot() +
  geom_col(
    aes(x = n, y = diretor, fill = diretor),
    show.legend = FALSE
  ) +
  scale_fill_manual(
    values = c("#ff4500", "#268b07", "#ff7400", "#abefaf", "#33baba")
  )

# Mudando textos da legenda
imdb %>%
  filter(!is.na(cor)) %>%
  group_by(ano, cor) %>%
  summarise(num_filmes = n()) %>%
  ggplot() +
  geom_line(aes(x = ano, y = num_filmes, color = cor)) +
  scale_color_discrete(labels = c("Preto e branco", "Colorido"))

# Definiando cores das formas geométricas
imdb %>%
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita), color = "#ff7400")

# Tema --------------------------------------------------------------------

# Temas prontos
imdb %>%
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita)) +
  # theme_bw()
  # theme_classic()
  # theme_dark()
  theme_minimal()

# A função theme()
imdb %>%
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita)) +
  labs(
    title = "Gráfico de dispersão",
    subtitle = "Receita vs Orçamento"
  ) +
  theme(
    plot.title = element_text(hjust = -0.27),
    plot.subtitle = element_text(hjust = -0.25),
    panel.background = element_rect(fill = "orange")
  )

# Dúvida matheus
# gráfico usando duas tabelas diferentes

tab_medianas <- imdb %>%
  group_by(cor) %>%
  summarise(mediana = median(receita, na.rm = TRUE))

imdb %>%
  tidyr::drop_na(receita) %>%
  ggplot(aes(x = cor, y = receita)) +
  geom_boxplot() +
  geom_label(
    data = tab_medianas,
    aes(x = cor, y = mediana, label = mediana)
  )


