### Aplica??es da Psicometria Bayesiana: Do B?sico ao Avan?ado

### Limpar a ?rea de trabalho, os gr?ficos e o console
rm(list=ls())
dev.off()
cat("\014")

######### Escore de soma====
### Gerar dados aleat?rios de padr?o de resposta de um estudante em 100 testes,
### com 4 quest?es cada. O vi?s verdadeiro do estudante ? igual a 0,50.
set.seed(123)
n     <- 100
probs <- .5
x     <- rbinom(n, 4, probs)
  
### Ajustar os dados a um modelo binomial
fitdistrplus::fitdist(x, "binom", fix.arg=list('size'=4), start=list("prob"=.7))

### Transformar os dados para um vetor bin?rio
bin <- as.vector(sapply(seq_along(x), function(g) rep(c(0,1), c(4-x[g], x[g]))))
## Ajustar os dados a um modelo de Bernoulli
fitdistrplus::fitdist(bin, "binom", fix.arg=list('size'=1), start=list("prob"=.7))

### Usar o modelo Bayesiano
install.packages("remotes")
remotes::install_github("vthorrf/bsem")
require(bsem)
modeloBayes <- bern.score(bin)
## Recuperar a estimativa pontual
modeloBayes$abil
## Recuperar HDI da estimativa
modeloBayes$abilHDI[,1]
## Distribui??o posteriori da estimativa
plot(density(modeloBayes$abilFull[,1]), main="Distribui??o posteriori da aptid?o",
     xlab=expression(theta), ylab="Densidade")

######### Modelagem por Equa??es Estruturais Bayesiana====
require(psych)
data(bfi)
ocean <- bfi[complete.cases(bfi),1:25] # Selecionar apenas os itens do question?rio

set.seed(123)
amostra <- sample(1:nrow(ocean), 300, replace=F)
myData <- ocean[amostra,]

factors <- rep(1:5, each=5) # Definir quais itens fazem parte de qual fator

MEEB <- BSEM(myData, factors)

MEEB$output

MEEB$corr

plot(MEEB$abil)

######### MEEB - Dois par?metros log?sticos====
myData <- myData - 1
min(myData) == 0
RevData <- reverse.code(c(-1,1,1,1,1, 
                          1,1,1,-1,-1, 
                          -1,-1,1,1,1, 
                          1,1,1,1,1, 
                          1,-1,1,1,-1), myData)

k <- max(myData)
MEEBIRT <- BSEMIRT(RevData, factors, k=k)

MEEBIRT$output

MEEBIRT$corr

plot(MEEBIRT$abil)

######### Compara??o====
MEEB$dic; MEEBIRT$dic

####====---- FIM ----====####