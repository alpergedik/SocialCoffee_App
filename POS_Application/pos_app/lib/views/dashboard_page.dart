import 'package:flutter/material.dart';
import 'package:pos_app/core/app_colors.dart';



class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _areGraphsVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      
      // TÜM SAYFAYI KAPLAYAN DİKEY SCROLL
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16), // Üstten biraz boşluk
            
            // LAYOUT BUILDER: Ekran genişliğine göre karar veriyoruz
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 900;

                // --- 1. KISIM: İSTATİSTİK KARTLARI ---
                if (isMobile) {
                  // MOBİL İSE: YATAY KAYDIRMALI (Sola-Sağa Swipe)
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Yatay kaydırma açıldı
                    padding: const EdgeInsets.symmetric(horizontal: 16), // Kenar boşluğu
                    child: Row(
                      children: _buildStatCards(isMobile: true),
                    ),
                  );
                } else {
                  // TABLET/PC İSE: EKRANA YAYILMIŞ SABİT (Kaydırma yok, sığdırılmış)
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: _buildStatCards(isMobile: false),
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 24),

            // --- 2. KISIM: BUTON VE GRAFİKLER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildGraphSection(), // Grafik bölümünü çağır
            ),
          ],
        ),
      ),
    );
  }

  // --- GRAFİK BÖLÜMÜ ---
  Widget _buildGraphSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Buton
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _areGraphsVisible = !_areGraphsVisible;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryBrown,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  side: const BorderSide(color: AppColors.primaryBrown),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                icon: Icon(_areGraphsVisible ? Icons.keyboard_arrow_up : Icons.bar_chart),
                label: Text(_areGraphsVisible ? "Grafikleri Gizle" : "Grafikleri Gör"),
              ),
            ),

            // Grafikler (Açıksa göster)
            if (_areGraphsVisible) ...[
              const SizedBox(height: 24),
              if (isMobile)
                // Mobilde grafikler alt alta
                Column(
                  children: [
                    _buildPlaceholderGraph("Saatlik Satış Grafiği"),
                    const SizedBox(height: 16),
                    _buildPlaceholderGraph("Kategori Dağılımı"),
                  ],
                )
              else
                // Tablette grafikler yan yana
                Row(
                  children: [
                    Expanded(flex: 65, child: _buildPlaceholderGraph("Saatlik Satış Grafiği")),
                    const SizedBox(width: 24),
                    Expanded(flex: 35, child: _buildPlaceholderGraph("Kategori Dağılımı")),
                  ],
                ),
              const SizedBox(height: 50),
            ],
          ],
        );
      }
    );
  }

  // --- KART LİSTESİ OLUŞTURUCU ---
  List<Widget> _buildStatCards({required bool isMobile}) {
    final rawCards = [
      _buildCardContent("₺29,500", "Bugünkü Ciro", "+12%", Icons.attach_money, Colors.green, true),
      _buildCardContent("247", "Satış", "+8%", Icons.shopping_bag_outlined, Colors.blue, true),
      _buildCardContent("₺119", "Ort. Sepet", "Stabil", Icons.trending_up, Colors.purple, true),
      _buildCardContent("Latte", "Favori", "89 adet", Icons.verified_outlined, Colors.orange, true, isTextOnly: true),
    ];

    if (isMobile) {
      // MOBİL İÇİN AYAR:
      // Kartlara sabit bir genişlik (width: 280) veriyoruz ki
      // ekrandan taşsınlar ve scroll edilebilsinler.
      return rawCards.map((card) {
        return Container(
          width: 280, // <-- ÖNEMLİ: Sabit genişlik olmazsa kaymaz
          margin: const EdgeInsets.only(right: 12), // Kartlar arası boşluk
          child: card,
        );
      }).toList();
    } else {
      // TABLET İÇİN AYAR:
      // Expanded kullanarak mevcut genişliğe eşit dağıtıyoruz.
      return rawCards.map((card) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: card,
          ),
        );
      }).toList();
    }
  }

  // --- KART İÇERİĞİ (Tasarım) ---
  Widget _buildCardContent(String title, String subtitle, String change, IconData icon, MaterialColor color, bool isPositive,
      {bool isTextOnly = false}) {
    return Container(
      height: 160, // Yüksekliği sabitliyoruz
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 24),
              ),
              if (!isTextOnly)
                Icon(isPositive ? Icons.trending_up : Icons.trending_down,
                    color: isPositive ? Colors.green : Colors.red, size: 20),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Container(
             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
             decoration: isTextOnly ? null : BoxDecoration(
               color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
               borderRadius: BorderRadius.circular(4)
             ),
             child: Text(change, style: TextStyle(
               fontSize: 11, 
               fontWeight: FontWeight.bold, 
               color: isTextOnly ? Colors.grey : (isPositive ? Colors.green : Colors.red)
             )),
           ),
        ],
      ),
    );
  }

  // --- PLACEHOLDER GRAPH ---
  Widget _buildPlaceholderGraph(String title) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: AppColors.accentOrange),
                const SizedBox(height: 16),
                Text("Yükleniyor...", style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}