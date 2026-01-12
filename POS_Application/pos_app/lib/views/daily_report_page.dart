import 'package:flutter/material.dart';
import 'package:pos_app/core/app_colors.dart';

class DailyReportPage extends StatelessWidget {
  const DailyReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ekran genişliğini alıyoruz
    var screenWidth = MediaQuery.of(context).size.width;
    
    // 1100px altını "küçük ekran" kabul edip alt alta dizeceğiz.
    bool isSmallScreen = screenWidth < 1100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. BAŞLIK
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Günlük Rapor",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  children: const [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text("12.01.2026", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                  ],
                ),
              )
            ],
          ),
          
          const SizedBox(height: 24),

          // 2. ÖZET KARTLARI (Responsive Yapı)
          isSmallScreen 
              ? _buildVerticalCards() 
              : _buildHorizontalCards(),
          
          const SizedBox(height: 32),

          // 3. SATILAN ÜRÜNLER TABLOSU
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Satılan Ürünler",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                
                const Row(
                  children: [
                    Expanded(flex: 3, child: Text("Ürün Adı", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text("Adet", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600))),
                    Expanded(flex: 2, child: Text("Toplam Gelir", textAlign: TextAlign.right, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text("Katkı %", textAlign: TextAlign.right, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600))),
                  ],
                ),
                const Divider(height: 30, color: Colors.grey),

                _buildProductRow("Cappuccino", "89", "₺4.895", "16.6%"),
                _buildDivider(),
                _buildProductRow("Latte", "76", "₺4.180", "14.2%"),
                _buildDivider(),
                _buildProductRow("Americano", "54", "₺2.700", "9.2%"),
                _buildDivider(),
                _buildProductRow("Espresso", "48", "₺2.160", "7.3%"),
                _buildDivider(),
                _buildProductRow("Cheesecake", "32", "₺2.240", "7.6%"),
                _buildDivider(),
                _buildProductRow("Soğuk Latte", "28", "₺1.680", "5.7%"),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 4. İADE ÖZETİ
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("İade Özeti", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.04), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("İade Sayısı", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          SizedBox(height: 4),
                          Text("3", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text("İade Tutarı", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          SizedBox(height: 4),
                          Text("-₺185", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // --- LAYOUT MANTIĞI ---

  // 1. GENİŞ EKRAN (YAN YANA)
  Widget _buildHorizontalCards() {
    // IntrinsicHeight: Yan yana duranların hepsi en uzuna eşitlensin diye.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _buildDarkCard()),
          const SizedBox(width: 16),
          Expanded(child: _buildLightCard("Nakit Ödemeler", "₺12.300", "41.7%", Icons.money, Colors.green)),
          const SizedBox(width: 16),
          Expanded(child: _buildLightCard("Kart Ödemeler", "₺17.200", "58.3%", Icons.credit_card, Colors.blue)),
        ],
      ),
    );
  }

  // 2. DAR EKRAN (ALT ALTA)
  Widget _buildVerticalCards() {
    // Burada Fixed Height YOK. İçerik ne kadarsa o kadar uzasınlar.
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: _buildDarkCard()
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: _buildLightCard("Nakit Ödemeler", "₺12.300", "41.7%", Icons.money, Colors.green),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: _buildLightCard("Kart Ödemeler", "₺17.200", "58.3%", Icons.credit_card, Colors.blue),
        ),
      ],
    );
  }

  // --- KART TASARIMLARI ---

  // Koyu Kart Tasarımı
  Widget _buildDarkCard() {
    return Container(
      padding: const EdgeInsets.all(24), // Biraz daha geniş padding
      decoration: BoxDecoration(
        color: const Color(0xFF2C2520),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize.min: İçerik kadar yer kapla, zorla uzama.
        mainAxisSize: MainAxisSize.min, 
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.trending_up, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 24), // İkon ile yazı arasına sabit boşluk
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
               Text("₺29.500", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
               SizedBox(height: 4),
               Text("Toplam Ciro", style: TextStyle(fontSize: 14, color: Colors.white70)),
            ],
          )
        ],
      ),
    );
  }

  // Açık Renk Kart Tasarımı
  Widget _buildLightCard(String title, String amount, String percentage, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // İçerik kadar yer kapla
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 24),
              ),
              Text(percentage, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24), // Sabit boşluk
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(amount, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(String name, String count, String revenue, String percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87))),
          Expanded(flex: 1, child: Text(count, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54))),
          Expanded(flex: 2, child: Text(revenue, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
          Expanded(flex: 1, child: Text(percent, textAlign: TextAlign.right, style: const TextStyle(color: Colors.grey, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: Colors.black12);
  }
}