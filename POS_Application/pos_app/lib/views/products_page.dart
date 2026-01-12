import 'package:flutter/material.dart';

// --- MODELLER ---
class CategoryModel {
  String id;
  String name;
  Color color;
  int productCount;
  CategoryModel({required this.id, required this.name, required this.color, this.productCount = 0});
}

class ProductModel {
  String id;
  String categoryId;
  String name;
  double price;
  bool isActive;
  ProductModel({required this.id, required this.categoryId, required this.name, required this.price, this.isActive = true});
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  CategoryModel? _selectedCategory;

  // --- BAŞLANGIÇ VERİLERİ ---
  final List<CategoryModel> _categories = [
    CategoryModel(id: '1', name: 'Kahveler', color: Colors.brown, productCount: 2),
    CategoryModel(id: '2', name: 'Soğuk İçecekler', color: Colors.blue, productCount: 2),
    CategoryModel(id: '3', name: 'Tatlılar', color: Colors.redAccent, productCount: 0),
    CategoryModel(id: '4', name: 'Atıştırmalıklar', color: Colors.orange, productCount: 0),
  ];

  final List<ProductModel> _products = [
    ProductModel(id: '101', categoryId: '1', name: 'Espresso', price: 45.0),
    ProductModel(id: '102', categoryId: '1', name: 'Latte', price: 55.0),
    ProductModel(id: '201', categoryId: '2', name: 'Ice Americano', price: 55.0),
    ProductModel(id: '202', categoryId: '2', name: 'Limonata', price: 40.0),
  ];

  @override
  Widget build(BuildContext context) {
    bool isCategoryView = _selectedCategory == null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. HEADER (Başlık ve Ekle Butonu)
            _buildHeader(isCategoryView),

            const SizedBox(height: 15),

            // 2. İÇERİK (Kategori Grid veya Ürün Listesi)
            Expanded(
              child: isCategoryView ? _buildCategoryGrid() : _buildProductList(),
            ),
          ],
        ),
      ),
    );
  }

  // --- HEADER ---
  Widget _buildHeader(bool isCategoryView) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Sol Taraf (Geri Butonu + Başlık)
        Expanded(
          child: Row(
            children: [
              if (!isCategoryView)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: () => setState(() => _selectedCategory = null),
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCategoryView ? "Kategoriler" : "Ürünler",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isCategoryView)
                      Text(
                        "${_selectedCategory?.name}",
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Sağ Taraf (Ekle Butonu)
        ElevatedButton.icon(
          onPressed: () => isCategoryView ? _showCategoryDialog() : _showProductDialog(),
          icon: const Icon(Icons.add, size: 18),
          label: Text(isCategoryView ? "Kategori Ekle" : "Ürün Ekle"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2C2520), // Koyu Kahve
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        )
      ],
    );
  }

  // --- KATEGORİ LİSTESİ (GRID) ---
  Widget _buildCategoryGrid() {
    double screenWidth = MediaQuery.of(context).size.width;
    // Mobilde kart boyunu ayarlıyoruz
    double aspectRatio = screenWidth < 600 ? 1.2 : 1.5;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300, 
        childAspectRatio: aspectRatio, 
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return InkWell(
          onTap: () => setState(() => _selectedCategory = category),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: category.color.withOpacity(0.1),
                        radius: 20,
                        child: Icon(Icons.circle, color: category.color, size: 20),
                      ),
                      const Spacer(),
                      Text(
                        category.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text("${category.productCount} ürün", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                // Düzenle ve Sil Butonları
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => _showCategoryDialog(category: category),
                        child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.edit, size: 18, color: Colors.grey)),
                      ),
                      InkWell(
                        onTap: () => _deleteCategory(category),
                        child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.delete, size: 18, color: Colors.redAccent)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // --- ÜRÜN LİSTESİ ---
  Widget _buildProductList() {
    final filteredProducts = _products.where((p) => p.categoryId == _selectedCategory!.id).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Column(
        children: [
           Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: const [
                Expanded(flex: 4, child: Text("Ürün Adı", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                Expanded(flex: 2, child: Text("Fiyat", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                Expanded(flex: 2, child: Text("Durum", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))), 
                Expanded(flex: 2, child: Text("İşlem", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
              ],
            ),
          ),
          const Divider(height: 1),
          
          Expanded(
            child: filteredProducts.isEmpty
            ? const Center(child: Text("Bu kategoride ürün bulunamadı.", style: TextStyle(color: Colors.grey)))
            : ListView.separated(
              itemCount: filteredProducts.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                  child: Row(
                    children: [
                      Expanded(flex: 4, child: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                      Expanded(flex: 2, child: Text("₺${product.price.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                        flex: 2, 
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: product.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(product.isActive ? "Aktif" : "Pasif", style: TextStyle(fontSize: 10, color: product.isActive ? Colors.green : Colors.red)),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2, 
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () => _showProductDialog(product: product),
                              child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.edit, color: Colors.grey, size: 18)),
                            ),
                            InkWell(
                              onTap: () => _deleteProduct(product),
                              child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.delete, color: Colors.redAccent, size: 18)),
                            ),
                          ],
                        ),
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

  // --- İŞLEM FONKSİYONLARI (LOGIC) ---

  void _deleteCategory(CategoryModel category) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Kategoriyi Sil"),
        content: Text("${category.name} silinecek. İçindeki ürünler de silinsin mi?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              setState(() {
                _products.removeWhere((p) => p.categoryId == category.id);
                _categories.remove(category);
              });
              Navigator.pop(context);
            }, 
            child: const Text("Sil", style: TextStyle(color: Colors.white))
          )
        ],
      )
    );
  }

  void _deleteProduct(ProductModel product) {
    setState(() {
      _products.remove(product);
      // Kategori sayacını düşür
      var cat = _categories.firstWhere((c) => c.id == product.categoryId);
      if (cat.productCount > 0) cat.productCount--;
    });
  }

  // --- POP-UP DIALOGLAR ---

  void _showCategoryDialog({CategoryModel? category}) {
    final nameController = TextEditingController(text: category?.name ?? "");
    // Varsayılan renk
    Color selectedColor = category?.color ?? Colors.brown;
    
    showDialog(
      context: context,
      builder: (context) {
        // StatefulBuilder, dialog içinde setstate yapabilmek için gerekli
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(category == null ? "Yeni Kategori" : "Düzenle", style: const TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Kategori Adı", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController, 
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        hintText: "Ör: Kahveler",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12)
                      )
                    ),
                    const SizedBox(height: 20),
                    const Text("Renk Seç", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12, runSpacing: 12,
                      children: [Colors.brown, Colors.blue, Colors.red, Colors.orange, Colors.purple, Colors.green, Colors.teal, Colors.indigo]
                          .map((color) => InkWell(
                                onTap: () {
                                  setStateDialog(() { selectedColor = color; });
                                },
                                child: Container(
                                  width: 32, height: 32,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: selectedColor == color ? Border.all(color: Colors.black, width: 2) : null
                                  ),
                                  child: selectedColor == color ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.all(16),
              actions: [
                // İPTAL BUTONU
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
                  ),
                  onPressed: () => Navigator.pop(context), 
                  child: const Text("İptal")
                ),
                // KAYDET BUTONU
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C2520),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
                  ),
                  onPressed: () {
                    if (nameController.text.isEmpty) return; // Boşsa kaydetme
                    
                    // Ana State'i güncelle
                    this.setState(() {
                      if (category == null) {
                        // YENİ EKLEME FONKSİYONU
                        _categories.add(CategoryModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(), // Benzersiz ID
                          name: nameController.text,
                          color: selectedColor,
                        ));
                      } else {
                        // DÜZENLEME FONKSİYONU
                        category.name = nameController.text;
                        category.color = selectedColor;
                      }
                    });
                    Navigator.pop(context);
                  }, 
                  child: const Text("Kaydet", style: TextStyle(fontWeight: FontWeight.bold))
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _showProductDialog({ProductModel? product}) {
    final nameController = TextEditingController(text: product?.name ?? "");
    final priceController = TextEditingController(text: product?.price.toStringAsFixed(0) ?? "");
    bool isActive = product?.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(product == null ? "Yeni Ürün" : "Düzenle", style: const TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Ürün Adı", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))
                    ),
                    const SizedBox(height: 16),
                    const Text("Fiyat (₺)", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: isActive, 
                          activeColor: const Color(0xFF2C2520),
                          onChanged: (v){ setStateDialog(() => isActive = v!); }
                        ),
                        const Text("Satışta (Aktif)")
                      ],
                    )
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.all(16),
              actions: [
                // İPTAL BUTONU
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("İptal")
                ),
                // KAYDET BUTONU
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C2520),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
                  ),
                  onPressed: () {
                    if (nameController.text.isEmpty || priceController.text.isEmpty) return;

                    // Ana State'i güncelle
                    this.setState(() {
                      double price = double.tryParse(priceController.text) ?? 0;

                      if (product == null) {
                        // YENİ ÜRÜN EKLEME
                        _products.add(ProductModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          categoryId: _selectedCategory!.id,
                          name: nameController.text,
                          price: price,
                          isActive: isActive
                        ));
                        // Kategori sayacını artır
                        _selectedCategory!.productCount++;
                      } else {
                        // ÜRÜN DÜZENLEME
                        product.name = nameController.text;
                        product.price = price;
                        product.isActive = isActive;
                      }
                    });
                    Navigator.pop(context);
                  }, 
                  child: const Text("Kaydet", style: TextStyle(fontWeight: FontWeight.bold))
                ),
              ],
            );
          }
        );
      },
    );
  }
}