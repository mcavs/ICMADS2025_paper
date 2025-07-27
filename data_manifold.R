# Gerekli paketleri yükleyelim
library(Rdimtools)       # intrinsic dimensionality
library(RSSL)            # swiss roll üretimi
library(igraph)          # topolojik analiz
library(RANN)            # nearest neighbors
library(TDA)             # persistent homology
library(curvHDR)         # curvature
library(vegan)           # distance-based redundancy analysis (dbrda, density gibi)

set.seed(123)

# 1. Veri Üretimi (Swiss Roll)
n <- 1000
swiss_roll <- generateScurve(n)$X
colnames(swiss_roll) <- c("x", "y", "z")

# --------------------------------------------------------------------
# 2. Intrinsic Dimensionality (Gerçek manifold boyutu)
# --------------------------------------------------------------------
id_result <- est.dims(swiss_roll, method = "MLE")
cat("Intrinsic Dimensionality Tahmini:", id_result$estdim, "\n")
# Yorum: Gerçek boyut, gözlenen boyuttan (3D) daha düşükse manifold varsayımı makul olabilir.

# --------------------------------------------------------------------
# 3. Curvature (Yerel eğrilik analizi)
# --------------------------------------------------------------------
# Mesafeleri hesapla
dmat <- dist(swiss_roll)
curvature_result <- curvature2D(as.matrix(swiss_roll[, c(1,3)]))  # 2D projeksiyon üzerinden eğrilik
summary(curvature_result$kappa)
# Yorum: Pozitif/negatif eğrilik değerleri, manifold üzerindeki bükülmeleri tanımlar. Yüksek mutlak değerli eğrilikler yerel yapısal değişiklikleri gösterir.

# --------------------------------------------------------------------
# 4. Persistent Homology (Topolojik metrikler: delikler, bağlantılar)
# --------------------------------------------------------------------
diag <- ripsDiag(X = swiss_roll, maxdimension = 1, maxscale = 5, dist = "euclidean")
plot(diag[["diagram"]])
# Yorum: H0 doğan ve ölen noktalar: bağlantılar. H1: döngüler. Uzun süre yaşayan H1'ler anlamlı delikleri gösterir.

# --------------------------------------------------------------------
# 5. Local Anisotropy (Yoğunluğun yönelimi)
# --------------------------------------------------------------------
get_anisotropy <- function(data, k = 15) {
  nn <- nn2(data, k = k + 1)$nn.idx[, -1]
  anisotropy_vals <- numeric(nrow(data))
  
  for (i in 1:nrow(data)) {
    neighbors <- data[nn[i, ], ]
    cov_matrix <- cov(neighbors)
    eig_vals <- eigen(cov_matrix)$values
    anisotropy_vals[i] <- 1 - min(eig_vals) / max(eig_vals)
  }
  return(anisotropy_vals)
}

anisotropy <- get_anisotropy(swiss_roll)
summary(anisotropy)
# Yorum: 0’a yakın değerler izotropik (simetrik yoğunluk), 1’e yakın değerler yönelimi güçlü (daha çizgisel yapı).

# --------------------------------------------------------------------
# 6. Görselleştirme (Anisotropy ile renklendirme)
# --------------------------------------------------------------------
library(ggplot2)
df <- as.data.frame(swiss_roll)
df$anisotropy <- anisotropy

ggplot(df, aes(x = x, y = z, color = anisotropy)) +
  geom_point(size = 1) +
  scale_color_viridis_c() +
  theme_minimal() +
  labs(title = "Yerel Anisotropy ile Swiss Roll", color = "Anisotropy")

# --------------------------------------------------------------------
# Ek: Yoğunluk bilgisi (local density via distance)
# --------------------------------------------------------------------
library(FNN)
get_density <- function(data, k = 10) {
  nn <- get.knn(data, k = k)$nn.dist
  rowMeans(nn)  # küçük mesafeler yüksek yoğunluk
}
local_density <- get_density(swiss_roll)
summary(local_density)
# Yorum: Küçük değerler yüksek yoğunluklu bölgeleri gösterir. Normalizasyonla karşılaştırmalı analiz yapılabilir.

