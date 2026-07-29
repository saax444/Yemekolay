import Link from "next/link";

export default function Support() {
  return <main>
    <nav className="nav shell"><Link className="brand" href="/"><span className="brand-mark">Y</span>Yemekolay</Link></nav>
    <section className="legal shell">
      <header><span className="eyebrow">Yardım Merkezi</span><h1>Nasıl yardımcı olabiliriz?</h1><p className="updated">Yemekolay ile ilgili sık sorulan sorular</p></header>
      <article className="glass">
        <h2>Aradığım malzemeyi bulamıyorum</h2><p>Türkçe karakter kullanmadan da arayabilirsiniz. Malzemenin temel adını yazın; hazırlama biçimleri aynı temel malzeme altında birleştirilmiştir.</p>
        <h2>Tarif eşleşme yüzdesi nasıl hesaplanıyor?</h2><p>Seçtiğiniz malzemelerin tarifteki gerekli malzemeleri ne ölçüde karşıladığı hesaplanır. Sonuç ekranında eksik kalan malzemeler ayrıca gösterilir.</p>
        <h2>Premium aboneliğimi nasıl geri yüklerim?</h2><p>Uygulamada Ayarlar bölümünü açın, Premium alanına girin ve “Satın Alımları Geri Yükle” seçeneğine dokunun. Aynı Apple hesabını kullandığınızdan emin olun.</p>
        <h2>Reklam izledim fakat tarif açılmadı</h2><p>Bağlantınızı kontrol edip tekrar deneyin. Sorun devam ederse uygulamayı kapatıp yeniden açın; ücretli bir işlem yapılmaz.</p>
        <h2>Geri bildirim ve hata bildirimi</h2><p>Hata ve önerilerinizi <a className="text-button" href="https://github.com/saax444/Yemekolay/issues">Yemekolay destek sayfasından</a> iletebilirsiniz. Bildiriminize cihaz modeli, iOS sürümü ve sorunu yeniden oluşturma adımlarını eklemeniz çözümü hızlandırır.</p>
      </article>
    </section>
  </main>;
}
