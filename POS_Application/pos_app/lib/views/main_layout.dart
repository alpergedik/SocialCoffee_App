import 'package:flutter/material.dart';
import 'package:pos_app/core/app_colors.dart';
import 'package:pos_app/views/sales_page.dart';
import 'package:pos_app/views/dashboard_page.dart';
import 'package:pos_app/views/daily_report_page.dart';
import 'package:pos_app/views/products_page.dart'; // <--- YENİ EKLENEN IMPORT
import 'package:pos_app/views/orders_page.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // 1. ÜST BAR (AppBar)
      appBar: AppBar(
        backgroundColor: AppColors.primaryBrown,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.coffee, color: AppColors.accentOrange, size: 24),
            const SizedBox(width: 8),
            if (MediaQuery.of(context).size.width > 600)
              const Text("Daniel's Coffee", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          if (MediaQuery.of(context).size.width > 800) ...[
             const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("12 Ocak 2026", style: TextStyle(color: Colors.white, fontSize: 12)),
                Text("20:45", style: TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
            const SizedBox(width: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: const Text("Vardiya Aktif", style: TextStyle(color: Colors.greenAccent, fontSize: 11)),
            ),
            const SizedBox(width: 15),
          ],
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white24,
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),

      // 2. YAN MENÜ (DRAWER)
      drawer: Drawer(
        width: 280,
        child: Container(
          color: const Color(0xFF2C2520), // Koyu Kahve Arka Plan
          child: Column(
            children: [
              _buildDrawerHeader(),
              
              // MENÜ LİSTESİ
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  children: [
                    _buildMenuItem(
                      context, 
                      title: "Satış", 
                      icon: Icons.shopping_cart_outlined, 
                      targetPage: const SalesPage()
                    ),
                    _buildMenuItem(
                      context, 
                      title: "Dashboard", 
                      icon: Icons.grid_view, 
                      targetPage: const DashboardPage()
                    ),
                    _buildMenuItem(
                      context, 
                      title: "Günlük Rapor", 
                      icon: Icons.description_outlined, 
                      targetPage: const DailyReportPage()
                    ),
                    
                    // --- GÜNCELLENEN KISIM ---
                    _buildMenuItem(
                      context, 
                      title: "Ürünler", 
                      icon: Icons.inventory_2_outlined,
                      targetPage: const ProductsPage() // Artık ProductsPage'e gidiyor
                    ),
                    // "Kategoriler" butonu kaldırıldı çünkü Ürünler'in içinde.
                    
                    _buildMenuItem(
                      context, 
                      title: "Siparişler", 
                      icon: Icons.assignment_outlined, 
                      targetPage: const OrdersPage() // <--- BAĞLANTIYI YAP
                    ),
                    _buildMenuItem(context, title: "İadeler", icon: Icons.replay), 
                    _buildMenuItem(context, title: "Kasa", icon: Icons.account_balance_wallet_outlined), 
                    _buildMenuItem(context, title: "Vardiya", icon: Icons.schedule), 
                    _buildMenuItem(context, title: "Kullanıcılar", icon: Icons.people_outline), 
                  ],
                ),
              ),

              // ALT MENÜ (Profil/Ayarlar)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.white10, width: 1)),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(context, title: "Profil", icon: Icons.person_outline),
                    _buildMenuItem(context, title: "Ayarlar", icon: Icons.settings_outlined),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: child,
    );
  }

  // --- YARDIMCI METOTLAR ---

  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: const Color(0xFFD4A574), borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: const Text("D", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2C2520))),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Daniel's Coffee", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              Text("POS Sistemi", style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required String title, required IconData icon, Widget? targetPage}) {
    // Aktif sayfa kontrolü
    bool isActive = false;
    if (targetPage != null) {
      isActive = child.runtimeType == targetPage.runtimeType;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFD4A574) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: isActive ? const Color(0xFF2C2520) : const Color(0xFFAFAFAF), size: 22),
        title: Text(title, style: TextStyle(color: isActive ? const Color(0xFF2C2520) : const Color(0xFFAFAFAF), fontWeight: isActive ? FontWeight.w600 : FontWeight.normal, fontSize: 14)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        dense: true,
        onTap: () {
          Navigator.pop(context); // Menüyü kapat
          
          if (targetPage != null && !isActive) {
            // Farklı bir sayfaya gidiliyorsa yönlendir
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainLayout(child: targetPage)));
          } else if (targetPage == null) {
            // Sayfa yoksa uyarı ver
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$title sayfası henüz aktif değil.")));
          }
        },
      ),
    );
  }
}