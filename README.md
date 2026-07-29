# Yemekolay v2

Bu sürümde:

- Apple tarzı cam yüzeyli SwiftUI arayüz
- 3200 gerçek ve numarasız malzeme
- 1000 tarif
- Türkçe karakterleri normalize eden çalışan arama
- Uygunluk yüzdesi ve eksik malzeme gösterimi
- Bugün Ne Pişirsem bölümünde tarif kartı ve tarif detayına geçiş
- Ne Sipariş Etsem önerileri
- Görünür banner reklam alanları
- Geçiş ve ödüllü reklam entegrasyon noktaları
- StoreKit 2 Premium abonelik altyapısı
- Günlük 1 ücretsiz tarif hakkı
- Favoriler

## Önemli

`BannerAdArea` şu anda tasarım ve yerleşim alanıdır. Gerçek reklam göstermek için Google Mobile Ads SDK eklenmeli ve `AdManager.swift` gerçek reklam sınıflarıyla bağlanmalıdır.

Abonelik ürün kimliği:

`com.azizsaybir.yemekolay.premium.monthly`
