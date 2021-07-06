# -------------------------------------------------------------------------

# Prática 1 : Importar a base do imdb separada por ano

# Carregar o pacote readr
library(readr)

# importar uma base
imdb_1916 <- read_rds("dados/por_ano/imdb_1916.rds")

# obtendo um vetor com o caminho para  todos os arquivos
arquivos <- list.files("dados/por_ano", full.names = TRUE, pattern = ".rds")

# ver o conteúdo de arquivos
arquivos

# aplicar a função read_rds para cada elemento do
# vetor arquivos, e unindo em um data.frame
imdb <- purrr::map_dfr(arquivos, read_rds)

# ver o conteudo de imdb: conseguimos a base completa!
imdb

##  duvida --- importar só parte dos arquivos
arquivos[1:9]
filmes_pre_guerra <- purrr::map_dfr(arquivos[1:9], read_rds)

## duvida 2 --- importar duas bases e empilhar
# importar as bases
imdb_1916 <- read_rds("dados/por_ano/imdb_1916.rds")
imdb_1920 <- read_rds("dados/por_ano/imdb_1920.rds")

# empilhar as bases
dplyr::bind_rows(imdb_1916, imdb_1920)

##### Solução com o for

library(readr)

todos_os_caminhos <- list.files(
  "dados/por_ano",
  full.names = TRUE,
  pattern = ".rds"
)

imdb <- read_rds(todos_os_caminhos[1])


for (caminho_para_arquivo in todos_os_caminhos[-1]) {
  tab <- read_rds(caminho_para_arquivo)
  imdb <- rbind(imdb, tab)
}

### outra solução

imdb <- NULL
# imdb <- data.frame() # tbm funciona
# imdb <- tibble::tibble() # tbm funciona

for (caminho_para_arquivo in todos_os_caminhos) {
  tab <- read_rds(caminho_para_arquivo)
  imdb <- rbind(imdb, tab)
}



# -------------------------------------------------------------------------

# Prática 2
# importar imdb_nao_estruturada.xlsx

# carregar o pacote readxl
library(readxl)

# verificar quais sheets/abas tem em uma base
excel_sheets("dados/imdb_nao_estruturada.xlsx")

# importar a aba "Sheet1" para obter o nome das colunas
nomes_colunas <- read_excel("dados/imdb_nao_estruturada.xlsx",
                            sheet = "Sheet1")
nomes_colunas$nome

# Importar usando a readxl
imdb_nao_estruturada <- read_excel(
  # caminho até a base
  path = "dados/imdb_nao_estruturada.xlsx",
  # número de linhas para pular
  skip = 3,
  # usar o vetor nomes_coluna$nome para nomear as colunas
  col_names = nomes_colunas$nome,
  # número maximo de linhas
  n_max = 3714
)


# Fazer a importação usando a ferramenta Import Dataset
# do RStudio

# Carregar o pacote readxl
library(readxl)
#
imdb_nao_estruturada_import <- read_excel(
  # caminho até a base
  "dados/imdb_nao_estruturada.xlsx",
  # não usar a primeira linha para nomear as colunas
  col_names = FALSE,
  # número de linhas para pular
  skip = 3
)

# ver o resultado
imdb_nao_estruturada_import

# daqui em diante teremos que "limpar" sem o import dataset

# Usar o vetor nomes_colunas$nome para nomear as colunas
# da base
names(imdb_nao_estruturada_import) <- nomes_colunas$nome

# extra! ---
# remover a última linha

# contar quantas linhas tem:
n_linhas <- nrow(imdb_nao_estruturada_import)

# remover ultima linha
imdb <- imdb_nao_estruturada_import[-n_linhas, ]
