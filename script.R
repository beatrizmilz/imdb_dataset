library(magrittr, include.only = "%>%")
# Objetivo: criar um dataset atualizado para os
# dados usados no curso "R para Ciência de Dados I"

# Dados obtidos no kaggle: 
# https://www.kaggle.com/stefanoleone992/imdb-extensive-dataset
# Dados obtidos em 16 de março de 2021

# Mimetizar a base que usamos no curso: 
imdb_curso_R <- readr::read_csv("https://raw.githubusercontent.com/curso-r/main-r4ds-1/master/dados/imdb.csv") 

dplyr::glimpse(imdb_curso_R)

# > dplyr::glimpse(imdb_curso_R)
# Rows: 3,713
# Columns: 15
# $ titulo         <chr> "Avatar ", "Pirates of the …
# $ ano            <dbl> 2009, 2007, 2012, 2012, 200…
# $ diretor        <chr> "James Cameron", "Gore Verb…
# $ duracao        <dbl> 178, 169, 164, 132, 156, 10…
# $ cor            <chr> "Color", "Color", "Color", …
# $ generos        <chr> "Action|Adventure|Fantasy|S…
# $ pais           <chr> "USA", "USA", "USA", "USA",…
# $ classificacao  <chr> "A partir de 13 anos", "A p…
# $ orcamento      <dbl> 237000000, 300000000, 25000…
# $ receita        <dbl> 760505847, 309404152, 44813…
# $ nota_imdb      <dbl> 7.9, 7.1, 8.5, 6.6, 6.2, 7.…
# $ likes_facebook <dbl> 33000, 0, 164000, 24000, 0,…
# $ ator_1         <chr> "CCH Pounder", "Johnny Depp…
# $ ator_2         <chr> "Joel David Moore", "Orland…
# $ ator_3         <chr> "Wes Studi", "Jack Davenpor…


# Bases disponíveis no kaggle:

arquivos <- list.files(path = "data-raw", pattern = ".csv$")

# [1] "IMDb movies.csv"  #  filmes        
# [2] "IMDb names.csv"    # atores e atrizes       
# [3] "IMDb ratings.csv"  # notas       
# [4] "IMDb title_principals.csv" # tipo de participacao


# Base IMDB movies

IMDb_movies <- readr::read_csv("data-raw/IMDb movies.csv")

imdb_filmes <- IMDb_movies %>%
  
  dplyr::filter(country == "USA") %>%  # na base que usamos na aula, só usamos filmes dos EUA

  dplyr::transmute(
    id = imdb_title_id, # deixei o id temporariamente para caso seja necessário fazer join
    titulo = title,
    ano = year,
    diretor = director,
    duracao = duration,
    # cor = , # não encontrei na base
    generos = genre,
    pais = country,
    # classificacao = , # não encontrei na base
    orcamento = budget,
    receita = worlwide_gross_income ,
    nota_imdb = avg_vote,
    # likes_facebook = , # não encontrei na base
    atores = actors
  ) %>% 
  tidyr::separate(atores, 
                  into = c("ator_1", "ator_2", "ator_3"), 
                  sep = ",", 
                  extra = "drop",
                  remove = TRUE) %>% 
  dplyr::mutate(
    generos = stringr::str_replace_all(generos, ",", "|"),
    orcamento = readr::parse_number(orcamento),
    receita = readr::parse_number(receita),
    
  )



dplyr::glimpse(imdb_filmes)

imdb_filmes %>% readr::write_csv2(file = "data-output/imdb.csv")
