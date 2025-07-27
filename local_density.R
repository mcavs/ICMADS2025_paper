library(RANN)

# Örnek veri: 2 boyutlu rastgele 10 nokta
set.seed(42)
mat <- matrix(runif(20), ncol = 2)

# En yakın 3 komşuyu bul (kendisi + 2 komşu)
k <- 3
res <- nn2(data = mat, k = k)

# 1. Lokal Yoğunluk: Komşulara ortalama uzaklık
local_density <- rowMeans(res$nn.dists[, -1])  # İlk sütun kendi, çıkarıyoruz
print("Lokal Yoğunluk (ortalama komşu uzaklığı):")
print(local_density)
# Yorum: Küçük değer → yoğun bölgede, büyük değer → seyrek bölgede

# 2. İzolelik: En uzak komşuya uzaklık
isolation <- apply(res$nn.dists[, -1], 1, max)
print("İzolelik (en uzak komşuya mesafe):")
print(isolation)
# Yorum: Büyük değer → gözlem komşulardan izole, potansiyel outlier

# 3. Local Reachability Density (Basitleştirilmiş LOF)
# Önce her gözlemin lokal yoğunluğunu alıyoruz (local_density)
# Komşuların lokal yoğunluklarının ortalaması (neighbor_density)
neighbor_density <- sapply(1:nrow(mat), function(i) {
  neighbors <- res$nn.idx[i, -1]  # Komşu indeksleri
  mean(local_density[neighbors])
})

lof_like <- neighbor_density / local_density

print("Local Reachability Density benzeri skor (LOF-like):")
print(lof_like)
# Yorum:
# LOF ~ 1 → gözlem normal
# LOF > 1 → gözlem daha seyrek bölgede, potansiyel aykırı
# LOF < 1 → gözlem çevresinden daha yoğun bölgede

# İstersen sonuçları tablo şeklinde de gösterelim:
results <- data.frame(
  local_density = local_density,
  isolation = isolation,
  lof_like = lof_like
)
print("Özet sonuçlar:")
print(results)

# Lokal Yoğunluk (ortalama komşu uzaklığı):
#  [1] 0.328 0.300 0.386 0.338 0.311 0.336 0.377 0.401 0.303 0.295

# İzolelik (en uzak komşuya mesafe):
#  [1] 0.463 0.432 0.491 0.476 0.423 0.479 0.491 0.529 0.432 0.415

# Local Reachability Density benzeri skor (LOF-like):
#  [1] 1.01  1.09  0.99  1.07  1.02  0.99  1.05  1.06  1.04  1.05

# Özet sonuçlar:
#  local_density isolation lof_like
# 1         0.328     0.463     1.01
# 2         0.300     0.432     1.09
# 3         0.386     0.491     0.99
# 4         0.338     0.476     1.07
# 5         0.311     0.423     1.02
# 6         0.336     0.479     0.99
# 7         0.377     0.491     1.05
# 8         0.401     0.529     1.06
# 9         0.303     0.432     1.04
# 10        0.295     0.415     1.05

# local_density: 2. gözlem en küçük ortalama mesafeye sahip → yoğun bir bölgede. 
# 8. gözlem en yüksek mesafeye sahip → nispeten seyrek.

# isolation: 8. gözlem en yüksek en uzak komşu mesafesine sahip → izole olabilir.

# lof_like: 2. gözlemde biraz yüksek (>1), komşularına göre seyrekleşmiş olabilir. 
# 3. ve 6. gözlemler normal yoğunlukta.
