import Link from "next/link";

export default function Privacy() {
  return <main>
    <nav className="nav shell"><Link className="brand" href="/"><span className="brand-mark">Y</span>Yemekolay</Link></nav>
    <section className="legal shell">
      <header><span className="eyebrow">Yasal</span><h1>Gizlilik Politikası</h1><p className="updated">Son güncelleme: 29 Temmuz 2026</p></header>
      <article className="glass">
        <h2>Genel bakış</h2><p>Yemekolay, tarif bulmayı mümkün olduğunca cihaz üzerinde gerçekleştirir. Seçtiğiniz malzemeler, favorileriniz ve günlük kullanım hakkınız uygulamanın çalışması için cihazınızda saklanabilir.</p>
        <h2>Toplanan bilgiler</h2><p>Uygulama hesap açmanızı istemez ve tarif aramalarınızı kimliğinizle ilişkilendiren bir kullanıcı profili oluşturmaz. Satın alma işlemleri Apple tarafından yürütülür; ödeme kartı bilgilerinize erişmeyiz.</p>
        <h2>Reklamlar</h2><p>Ücretsiz sürüm Google Mobile Ads aracılığıyla banner, geçiş veya ödüllü reklam gösterebilir. Reklam sağlayıcısı; cihaz tanımlayıcıları, yaklaşık konum, reklam etkileşimleri ve tanılama verilerini izinleriniz ve geçerli mevzuat kapsamında işleyebilir. İzleme izni verilmemesi uygulamanın temel tarif özelliklerini engellemez.</p>
        <h2>Satın almalar</h2><p>Premium abonelikler Apple App Store üzerinden yönetilir. Satın alma durumunun doğrulanması için yalnızca Apple’ın sağladığı işlem bilgileri kullanılır.</p>
        <h2>Saklama ve güvenlik</h2><p>Cihazda tutulan tercihleri uygulamayı silerek kaldırabilirsiniz. Hizmet sağlayıcılarımızdan yalnızca hizmeti sunmak için gerekli güvenlik ve gizlilik standartlarına uymalarını bekleriz.</p>
        <h2>Çocukların gizliliği</h2><p>Yemekolay bilerek çocuklardan kişisel bilgi toplamaz. Bir çocuğa ait bilginin işlendiğini düşünüyorsanız destek sayfamız üzerinden iletişim kurabilirsiniz.</p>
        <h2>İletişim</h2><p>Gizlilik talepleri için <Link className="text-button" href="/support">destek sayfasını</Link> kullanabilirsiniz.</p>
      </article>
    </section>
  </main>;
}
