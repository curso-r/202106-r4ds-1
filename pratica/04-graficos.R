library(dplyr)
library(ggplot2)

# mudar o idioma----------
# ver qual é o usado
Sys.getlocale("LC_TIME")

# alterar para portugues
Sys.setlocale("LC_TIME", "pt_BR.UTF-8")

# pratica 1: objetivo é analisar a relação de peso vs altura ---
View(starwars)

starwars %>%
  ggplot() +
  geom_point(aes(x = mass, y = height))

# vamos tirar o jabba da base!

starwars %>%
  filter(mass < 500) %>%
  ggplot(aes(x = mass, y = height, color = gender)) +
  geom_point() #+
#  coord_cartesian(xlim = c(0,300), ylim = c(0,300))

# pergunta sobre como tirar os NAs
starwars %>%
  tidyr::drop_na(gender) %>%
  filter(mass < 500) %>%
  ggplot(aes(x = mass, y = height, color = gender)) +
  geom_point() #+
#  coord_cartesian(xlim = c(0,300), ylim = c(0,300))

# pratica 2 --------
# qual o nível dos reservatorios em 2021?

# base: https://github.com/beatrizmilz/mananciais/raw/master/inst/extdata/mananciais.csv

# alterar para portugues
Sys.setlocale("LC_TIME", "pt_BR.UTF-8")

# carregar pacotes
library(readr)
library(dplyr)
library(ggplot2)

# importar os dados, usei o import dataset
mananciais <-
  read_delim(
    "https://github.com/beatrizmilz/mananciais/raw/master/inst/extdata/mananciais.csv",
    ";",
    escape_double = FALSE,
    col_types = cols(data = col_date(format = "%Y-%m-%d")),
    locale = locale(decimal_mark = ",", grouping_mark = "."),
    trim_ws = TRUE
  )
View(mananciais)

# criar um vetor com a data de hoje
data_de_hoje <- format(Sys.Date(), "%d/%m/%Y")

# criar o grafico!
# usando a base mananciais...
grafico_mananciais <- mananciais %>%
  # criar uma coluna: ano, extrair da coluna de data
  mutate(ano = lubridate::year(data)) %>%
  # filtrar para ano de 2021
  filter(ano == 2021) %>%
  # comecar o gráfico! a partir daqui usamos o +
  ggplot() +
  # queremos gráfico de linhas
  geom_line(aes(x = data, y = volume_porcentagem, color = sistema)) +
  # usar um tema mais simples/clean
  theme_bw() +
  # anotações nos eixos, legendas e títulos
  labs(
    x = "Mês",
    y = "Volume operacional (%)",
    color = "Sistema",
    title = "Volume operacional nos sistemas de \nabastecimento público da RMSP em 2021",
    caption = paste0(
      "Fonte: Dados do Portal Mananciais da SABESP, coletados em ",
      data_de_hoje,
      "."
    )
  ) +
  # mudar o a posição da legenda
  theme(legend.position = "bottom") +
  # mudar a escala da data
  scale_x_date(date_breaks = "1 month", date_labels = "%b")

# salvar o grafico
ggsave(
  # caminho para salvar o gráfico
  filename = "pratica/exemplo_mananciais.png",
  # nome do objeto
  plot = grafico_mananciais,

  # altura
  height = 5,
  # largura
  width = 5.5
)



# pergunta: como baixar o arquivo no computador?

# url do arquivo que queremos baixar
url <-
  "https://github.com/beatrizmilz/mananciais/raw/master/inst/extdata/mananciais.csv"

# path para salvar o arquivo
dest_file <- "pratica/mananciais.csv"

# fazer o download!
download.file(url, dest_file)
