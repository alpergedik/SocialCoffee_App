import 'package:flutter/material.dart';
import 'package:pos_app/core/app_colors.dart';
import 'main_layout.dart';
import 'sales_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    // Ekran boyutlarını alıyoruz
    final screenSize = MediaQuery.of(context).size;
    // Ekran yüksekliğine göre dinamik boşluk hesaplıyoruz
    final dynamicSpacing = screenSize.height * 0.02; // Yüksekliğin %2'si kadar boşluk

    return Scaffold(
      backgroundColor: AppColors.primaryBrown,
      // SafeArea: Çentik vb. alanların altında kalmayı önler
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // KRİTİK NOKTA: FittedBox
            // İçeriği, mevcut alana (ekrana) sığacak şekilde orantılı olarak küçültür.
            // BoxFit.scaleDown: Sadece sığmıyorsa küçültür, sığıyorsa büyütmez.
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // İçerik kadar yer kapla
                children: [
                  // LOGO VE BAŞLIK
                  const Icon(Icons.coffee_rounded, size: 60, color: AppColors.accentOrange),
                  SizedBox(height: dynamicSpacing),
                  const Text(
                    "Daniel's Coffee",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: dynamicSpacing),

                  // GİRİŞ KARTI
                  // ConstrainedBox: Kartın maksimum genişliğini sınırlar.
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Giriş Yapın",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: dynamicSpacing * 1.5),
                          
                          // E-POSTA
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "E-posta",
                              prefixIcon: const Icon(Icons.email_outlined, size: 20),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              isDense: true, // Daha kompakt görünüm
                            ),
                          ),
                          SizedBox(height: dynamicSpacing),
                          
                          // ŞİFRE
                          TextFormField(
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: "Şifre",
                              prefixIcon: const Icon(Icons.lock_outline, size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, size: 20),
                                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              isDense: true,
                            ),
                          ),
                          
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              // Yazı boyutunu biraz küçülttük
                              child: const Text("Şifremi unuttum?", style: TextStyle(color: AppColors.accentOrange, fontSize: 12)),
                            ),
                          ),
                          SizedBox(height: dynamicSpacing),

                          // GİRİŞ BUTONU
                          SizedBox(
                            height: 45, // Buton yüksekliği
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.darkButton,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 2,
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MainLayout(child: SalesPage())),
                                );
                              },
                              child: const Text("Giriş Yap", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: dynamicSpacing * 1.5),
                  // Alt Bilgi
                  const Text(
                    "© 2026 Daniel's Coffee Inc.",
                    style: TextStyle(color: Colors.white38, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}