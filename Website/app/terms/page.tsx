import Link from "next/link";

export default function Terms() {
  return <main>
    <nav className="nav shell"><Link className="brand" href="/"><span className="brand-mark">Y</span>Yemekolay</Link></nav>
    <section className="legal shell">
      <header><span className="eyebrow">Yasal</span><h1>Kullanım Koşulları</h1><p className="updated">Son güncelleme: 29 Temmuz 2026</p></header>
      <article className="glass">
        <h2>Hizmet</h2><p>Yemekolay, elinizdeki malzemelere göre tarif ve yemek önerileri sunan bir yardımcı uygulamadır. Uygulamayı kullanarak bu koşulları kabul etmiş olursunuz.</p>
        <h2>Tarif güvenliği</h2><p>Tarifler genel bilgilendirme amaçlıdır. Alerjiler, özel beslenme gereksinimleri, çapraz bulaşma ve gıda güvenliği konusunda kendi koşullarınıza uygun önlemleri almak sizin sorumluluğunuzdadır. Et ve yumurta gibi ürünlerin güvenli iç sıcaklığa ulaşmasını kontrol edin.</p>
        <h2>Ücretsiz kullanım ve reklamlar</h2><p>Ücretsiz kullanım günlük haklarla sınırlandırılabilir. Ek tarif hakları ödüllü reklamlarla sunulabilir; reklamın kullanılabilirliği garanti edilmez.</p>
        <h2>Premium abonelik</h2><p>Abonelik ücretleri satın alma öncesinde App Store’da gösterilir. Abonelik, dönem bitiminden en az 24 saat önce iptal edilmezse Apple hesabınız üzerinden yenilenebilir. Yönetim ve iptal işlemleri App Store hesap ayarlarından yapılır.</p>
        <h2>Fikri mülkiyet</h2><p>Uygulamanın tasarımı, metinleri, işaretleri ve yazılımı ilgili hak sahiplerine aittir. Uygulamayı kopyalayamaz, tersine mühendislik yapamaz veya ticari olarak yeniden dağıtamazsınız.</p>
        <h2>Değişiklikler</h2><p>Özellikleri ve bu koşulları zaman zaman güncelleyebiliriz. Önemli değişiklikler bu sayfadaki tarih yenilenerek duyurulur.</p>
        <h2>Destek</h2><p>Sorularınız için <Link className="text-button" href="/support">Yemekolay Destek</Link> sayfasını ziyaret edin.</p>
      </article>
    </section>
  </main>;
}
