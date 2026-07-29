import Link from "next/link";

const features = [
  ["1.062", "temiz ve aranabilir malzeme"],
  ["1.000", "ayrıntılı yemek tarifi"],
  ["Saniyeler", "içinde uygun tarif eşleştirme"],
];

export default function Home() {
  return (
    <main>
      <nav className="nav shell" aria-label="Ana navigasyon">
        <Link className="brand" href="/">
          <span className="brand-mark">Y</span>
          Yemekolay
        </Link>
        <div className="nav-links">
          <Link href="/privacy">Gizlilik</Link>
          <Link href="/support">Destek</Link>
          <Link href="/terms">Koşullar</Link>
        </div>
      </nav>

      <section className="hero shell">
        <div className="eyebrow">iPhone ve iPad için</div>
        <h1>Evde ne varsa,<br /><span>yemeğin hazır.</span></h1>
        <p>
          Malzemelerini seç. Yemekolay elindekilere en uygun tarifleri,
          eksiklerini ve bütün pişirme adımlarını sade bir deneyimde göstersin.
        </p>
        <div className="hero-actions">
          <span className="store-button"> &nbsp; App Store’da yakında</span>
          <Link className="text-button" href="/support">Destek merkezi →</Link>
        </div>
      </section>

      <section className="stats shell" aria-label="Uygulama kapsamı">
        {features.map(([value, label]) => (
          <article className="glass" key={label}>
            <strong>{value}</strong>
            <span>{label}</span>
          </article>
        ))}
      </section>

      <section className="product shell">
        <article className="feature-card glass">
          <span className="icon">⌕</span>
          <h2>Malzemene göre bul</h2>
          <p>Türkçe karakterleri anlayan hızlı aramayla malzemelerini seç ve uygunluk oranına göre sıralanmış tarifleri gör.</p>
        </article>
        <article className="feature-card glass">
          <span className="icon">✦</span>
          <h2>Bugün ne pişirsem?</h2>
          <p>Kararsız kaldığında tek dokunuşla yemek önerisi al; malzemesinden püf noktasına kadar tarifin tamamına ulaş.</p>
        </article>
        <article className="feature-card glass">
          <span className="icon">♡</span>
          <h2>Sevdiklerini sakla</h2>
          <p>Beğendiğin tarifleri favorilerine ekle ve tekrar pişirmek istediğinde kolayca bul.</p>
        </article>
      </section>

      <footer className="footer shell">
        <span>© 2026 Yemekolay</span>
        <div>
          <Link href="/privacy">Gizlilik</Link>
          <Link href="/support">Destek</Link>
          <Link href="/terms">Kullanım Koşulları</Link>
        </div>
      </footer>
    </main>
  );
}
