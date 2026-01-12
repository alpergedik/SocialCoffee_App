import 'package:flutter/material.dart';
import 'package:pos_app/core/app_colors.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
        final isCompactHeight = constraints.maxHeight < 600;

        if (isMobile && constraints.maxWidth < constraints.maxHeight) {
          // --- MOBİL DİK (PORTRAIT) ---
          return Column(
            children: [
              Expanded(child: _buildProductSection(constraints.maxWidth, isCompactHeight: false)),
              _buildCompactBottomBar(context),
            ],
          );
        } else {
          // --- YATAY MOD (LANDSCAPE TELEFON VEYA TABLET) ---
          return Row(
            children: [
              Expanded(
                flex: 7, 
                child: _buildProductSection(constraints.maxWidth, isCompactHeight: isCompactHeight)
              ),
              SizedBox(
                width: 340, 
                child: _buildFixedCart(isCompactHeight),
              ),
            ],
          );
        }
      },
    );
  }

  // --- SOL TARAFTAKİ ÜRÜNLER ---
  Widget _buildProductSection(double availableWidth, {required bool isCompactHeight}) {
    double aspectRatio = isCompactHeight ? 0.8 : 0.75; 
    
    int crossAxisCount = (availableWidth / 140).floor();
    if (crossAxisCount < 2) crossAxisCount = 2;

    return Container(
      color: const Color(0xFFF5F5F5),
      padding: EdgeInsets.all(isCompactHeight ? 8.0 : 16.0),
      child: Column(
        children: [
          // Kategoriler
          SizedBox(
            height: isCompactHeight ? 40 : 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ["Kahveler", "Soğuk İçecekler", "Tatlılar", "Atıştırmalıklar"].map((e) {
                bool isSelected = e == "Kahveler";
                return Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? AppColors.darkButton : Colors.white,
                      foregroundColor: isSelected ? Colors.white : Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: () {},
                    child: Text(e, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: isCompactHeight ? 8 : 16),

          // Ürün Listesi
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: aspectRatio,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                // Test için uzun isimler ekleyelim ki çalıştığını görelim
                String productName = index % 3 == 0 
                    ? "White Choc. Mocha" 
                    : (index % 2 == 0 ? "Filtre Kahve" : "Espresso");

                return Container(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.coffee, 
                        size: isCompactHeight ? 32 : 40, 
                        color: AppColors.accentOrange
                      ),
                      SizedBox(height: isCompactHeight ? 6 : 10),

                      // --- DÜZELTME BURADA: FittedBox ---
                      // Bu widget, içindeki metni kutuya sığacak şekilde küçültür (scaleDown).
                      // maxLines: 1 diyerek tek satıra zorluyoruz.
                      SizedBox(
                        width: double.infinity, // Yatayda tüm alanı kapla
                        child: FittedBox(
                          fit: BoxFit.scaleDown, // Sığmıyorsa küçült
                          child: Text(
                            productName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: isCompactHeight ? 14 : 15 // Başlangıç puntosu
                            ),
                            maxLines: 1, // Asla alt satıra geçme
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      Text(
                        "₺45.00", 
                        style: TextStyle(
                          color: AppColors.primaryBrown, 
                          fontWeight: FontWeight.bold, 
                          fontSize: isCompactHeight ? 12 : 13
                        )
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- SAĞ TARAFTAKİ SEPET (2x2 DÜZEN) ---
  Widget _buildFixedCart(bool isCompact) {
    final double padding = isCompact ? 12.0 : 20.0;
    final double buttonHeight = isCompact ? 42.0 : 50.0;
    final double fontSizeTitle = isCompact ? 16.0 : 20.0;

    return Container(
      margin: EdgeInsets.all(isCompact ? 8 : 16),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Sipariş Özeti", style: TextStyle(fontSize: fontSizeTitle, fontWeight: FontWeight.bold)),
          Divider(height: isCompact ? 12 : 24),
          
          Expanded(
            child: isCompact 
            ? const Center(child: Text("Sepet boş", style: TextStyle(color: Colors.grey, fontSize: 12)))
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.coffee_outlined, size: 60, color: Colors.grey.shade300),
                    const SizedBox(height: 10),
                    Text("Sepet boş", style: TextStyle(color: Colors.grey.shade400)),
                  ],
                ),
              ),
          ),
          
          Divider(height: isCompact ? 12 : 24),
          
          _buildSummaryRow("Ara Toplam:", "₺0.00", isCompact),
          _buildSummaryRow("KDV (%18):", "₺0.00", isCompact),
          SizedBox(height: isCompact ? 4 : 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Genel Toplam:", style: TextStyle(fontSize: isCompact ? 16 : 18, fontWeight: FontWeight.bold, color: Colors.black)),
              Text("₺0.00", style: TextStyle(fontSize: isCompact ? 20 : 24, fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
          SizedBox(height: isCompact ? 8 : 16),

          Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildActionButton("Nakit", AppColors.darkButton, Colors.white, () {}, height: buttonHeight)),
                  SizedBox(width: 8),
                  Expanded(child: _buildActionButton("Kart", AppColors.accentOrange, Colors.white, () {}, height: buttonHeight)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildActionButton("QR", AppColors.accentOrange, Colors.white, () {}, height: buttonHeight)),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton("İptal", Colors.white, Colors.red, () {}, 
                      height: buttonHeight, isBordered: true, borderColor: Colors.red
                    )
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- MOBİL İÇİN ALT BAR ---
  Widget _buildCompactBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("Toplam", style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text("₺0.00", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkButton,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {},
              child: const Text("Sepet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, bool isCompact) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: isCompact ? 12 : 13)),
          Text(value, style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w600, fontSize: isCompact ? 12 : 13)),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, Color bg, Color text, VoidCallback onTap, {bool isBordered = false, Color? borderColor, double height = 50}) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: text,
          elevation: 0,
          side: isBordered ? BorderSide(color: borderColor!, width: 1.5) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.zero,
        ),
        onPressed: onTap,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }
}