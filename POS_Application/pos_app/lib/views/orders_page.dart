import 'package:flutter/material.dart';

// --- MODELLER ---
class OrderProductModel {
  String name;
  int quantity;
  double price;
  OrderProductModel({required this.name, required this.quantity, required this.price});
  double get total => quantity * price;
}

class OrderModel {
  String orderNo;
  String date;
  String time;
  String paymentType;
  String cashier;
  double total;
  List<OrderProductModel> products;

  OrderModel({
    required this.orderNo,
    required this.date,
    required this.time,
    required this.paymentType,
    required this.cashier,
    required this.total,
    required this.products,
  });
}

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  OrderModel? _selectedOrder;

  // Veriler
  final List<OrderModel> _orders = [
    OrderModel(
      orderNo: "ORD-2026-001", date: "8 Oca 2026", time: "10:30", paymentType: "Kart", cashier: "Ahmet Yılmaz", total: 150.00,
      products: [OrderProductModel(name: "Cappuccino", quantity: 2, price: 55.0), OrderProductModel(name: "Croissant", quantity: 1, price: 40.0)]
    ),
    OrderModel(
      orderNo: "ORD-2026-002", date: "8 Oca 2026", time: "11:15", paymentType: "Nakit", cashier: "Ahmet Yılmaz", total: 125.00,
      products: [OrderProductModel(name: "Latte", quantity: 1, price: 55.0), OrderProductModel(name: "Cheesecake", quantity: 1, price: 70.0)]
    ),
    OrderModel(
      orderNo: "ORD-2026-003", date: "8 Oca 2026", time: "12:00", paymentType: "QR/Temassız", cashier: "Ahmet Yılmaz", total: 135.00,
      products: [OrderProductModel(name: "Filtre Kahve", quantity: 3, price: 45.0)]
    ),
    OrderModel(
      orderNo: "ORD-2026-004", date: "8 Oca 2026", time: "13:45", paymentType: "Kart", cashier: "Ahmet Yılmaz", total: 210.00,
      products: [OrderProductModel(name: "Mocha", quantity: 2, price: 60.0), OrderProductModel(name: "Tiramisu", quantity: 1, price: 90.0)]
    ),
    OrderModel(
      orderNo: "ORD-2026-005", date: "8 Oca 2026", time: "14:20", paymentType: "Nakit", cashier: "Zeynep Demir", total: 45.00,
      products: [OrderProductModel(name: "Espresso", quantity: 1, price: 45.0)]
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 900; 
    bool isDetailOpen = _selectedOrder != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // 1. KATMAN: LİSTE
          Padding(
            padding: const EdgeInsets.all(24.0), // Mobilde padding biraz azaltılabilir
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Sipariş Geçmişi", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 20),
                
                // Arama
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Sipariş no ara...",
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // TABLO KUTUSU
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        // Başlıklar (Responsive)
                        _buildResponsiveHeader(isMobile),
                        const Divider(height: 1, color: Colors.grey),
                        
                        // Liste (Responsive)
                        Expanded(
                          child: ListView.separated(
                            itemCount: _orders.length,
                            separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black12),
                            itemBuilder: (context, index) {
                              final order = _orders[index];
                              return _buildResponsiveRow(order, isMobile);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. KATMAN: KARARTMA (Detay açılınca)
          if (isDetailOpen)
            GestureDetector(
              onTap: () => setState(() => _selectedOrder = null),
              child: Container(
                color: Colors.black.withOpacity(0.4),
                width: double.infinity,
                height: double.infinity,
              ),
            ),

          // 3. KATMAN: DETAY PANELİ (SLIDE OVERLAY)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 0,
            bottom: 0,
            // Ekran darsa (mobil) -screenWidth diyerek tamamen dışarı atıyoruz, açılınca 0 oluyor.
            // Genişse -450.
            right: isDetailOpen ? 0 : (isMobile ? -screenWidth : -450), 
            // Genişlik mobilde tüm ekran, PC'de 450px
            width: isMobile ? screenWidth : 450, 
            
            child: _buildDetailPanel(),
          ),
        ],
      ),
    );
  }

  // --- RESPONSIVE TABLO YAPISI ---

  // Başlık Kısmı
  Widget _buildResponsiveHeader(bool isMobile) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        children: [
          // Mobilde Tarih sütununu gizleyip Sipariş No altına alacağız, o yüzden başlık sadece Sipariş No
          const Expanded(flex: 3, child: Text("Sipariş No", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13))),
          
          // Mobilde Tarih sütunu başlığı GİZLİ
          if (!isMobile) 
            const Expanded(flex: 3, child: Text("Tarih & Saat", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13))),
          
          // Ödeme Tipi
          const Expanded(flex: 2, child: Text("Ödeme", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13))),
          
          // Mobilde Kasiyer GİZLİ
          if (!isMobile)
            const Expanded(flex: 3, child: Text("Kasiyer", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13))),
          
          // Toplam
          const Expanded(flex: 2, child: Text("Toplam", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13))),
          
          // İşlemler
          const Expanded(flex: 1, child: Text("İşlem", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13))),
        ],
      ),
    );
  }

  // Satır Kısmı
  Widget _buildResponsiveRow(OrderModel order, bool isMobile) {
    return InkWell(
      onTap: () => setState(() => _selectedOrder = order),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            // 1. SÜTUN: SİPARİŞ NO (Mobilde altına tarihi ekliyoruz)
            Expanded(
              flex: 3, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.orderNo, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14)),
                  // Mobilde tarihi buraya sıkıştırıyoruz
                  if (isMobile)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text("${order.date}, ${order.time}", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ),
                ],
              )
            ),

            // 2. SÜTUN: TARİH (Sadece PC'de ayrı sütun)
            if (!isMobile)
              Expanded(flex: 3, child: Text("${order.date}, ${order.time}", style: const TextStyle(color: Colors.black87))),

            // 3. SÜTUN: ÖDEME TİPİ (Mobilde sadece ikon, PC'de ikon+yazı)
            Expanded(flex: 2, child: _buildPaymentBadge(order.paymentType, isMobile)),

            // 4. SÜTUN: KASİYER (Sadece PC'de)
            if (!isMobile)
              Expanded(flex: 3, child: Text(order.cashier, style: const TextStyle(color: Colors.black54))),

            // 5. SÜTUN: TOPLAM
            Expanded(flex: 2, child: Text("₺${order.total.toStringAsFixed(2)}", textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),

            // 6. SÜTUN: İŞLEM (Göz İkonu)
            Expanded(
              flex: 1, 
              child: Center(
                child: Icon(Icons.remove_red_eye_outlined, color: Colors.black54, size: 20),
              )
            ),
          ],
        ),
      ),
    );
  }

  // --- DETAY PANELİ (Tüm Ekranı Kaplayan Overlay) ---
  
  Widget _buildDetailPanel() {
    if (_selectedOrder == null) return const SizedBox();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20)],
      ),
      child: Column(
        children: [
          // HEADER (Kapat Butonu)
          // SafeArea mobilde çentik (notch) altında kalmasını sağlar
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Sipariş Detayı", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => setState(() => _selectedOrder = null),
                    icon: const Icon(Icons.close, size: 28),
                    style: IconButton.styleFrom(backgroundColor: Colors.grey.shade100), // Butonu belirginleştir
                  )
                ],
              ),
            ),
          ),
          
          const Divider(height: 1),

          // İÇERİK
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailInfoBlock("Sipariş No", _selectedOrder!.orderNo),
                  const SizedBox(height: 12),
                  _buildDetailInfoBlock("Tarih & Saat", "${_selectedOrder!.date}, ${_selectedOrder!.time}"),
                  const SizedBox(height: 12),
                  _buildDetailInfoBlock("Ödeme Tipi", _selectedOrder!.paymentType),
                  const SizedBox(height: 12),
                  _buildDetailInfoBlock("Kasiyer", _selectedOrder!.cashier),
                  
                  const SizedBox(height: 30),
                  const Text("Ürünler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  ..._selectedOrder!.products.map((p) => _buildDetailProductRow(p)).toList(),

                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Toplam:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text("₺${_selectedOrder!.total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF2C2520))),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // YARDIMCI WIDGETLAR
  
  Widget _buildDetailInfoBlock(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildDetailProductRow(OrderProductModel product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text("${product.quantity} Adet x ₺${product.price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
          Text("₺${product.total.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildPaymentBadge(String type, bool isMobile) {
    IconData icon;
    Color color;
    if (type == "Kart") { icon = Icons.credit_card; color = Colors.blue; }
    else if (type == "Nakit") { icon = Icons.money; color = Colors.green; }
    else { icon = Icons.qr_code; color = Colors.indigo; }

    // Mobilde sadece ikon göster, yer kaplamasın. PC'de ikon + yazı.
    if (isMobile) {
      return Row(children: [Icon(icon, size: 20, color: color)]);
    }

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(type, style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}