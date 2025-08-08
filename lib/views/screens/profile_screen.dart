import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pv_deme/api/Service/merchant_data_store_controller.dart';
import 'package:pv_deme/api/Service/merchant_stat_controller.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/api/models/contact_info_model.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/widget/custom_circle_progress_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final apiController = Get.find<ApiController>();
  final merchantController = Get.find<MerchantController>();
  final homeController = Get.find<HomeController>();

  Future<void> _launchUrl(String urlText, String linkType) async {
    late Uri url;

    if (linkType == 'phone') {
      // Ajout du préfixe tel:
      url = Uri.parse('tel:$urlText');
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Nous n\'avons pas pu appeler le numéro $urlText');
      }
    } else if (linkType == 'email') {
      // Ajout du préfixe mailto:
      url = Uri.parse('mailto:$urlText');
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Nous n\'avons pas pu envoyer un email à $urlText');
      }
    } else {
      url = Uri.parse('https://$urlText');
      if (!await launchUrl(url)) {
        throw Exception('Nous n\'avons pas pu ouvrir le lien $urlText');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (apiController.contactInfoModel.value == null) {
      apiController.getContatInfos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final merchant = apiController.merchantStat.value;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔷 HEADER
          Container(
            width: double.infinity,
            height: 200.h,
            color: AppColors.primaryLight,
            child: Column(
              children: [
                SizedBox(height: 16.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Mon profil',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40.r,
                      backgroundColor: Colors.transparent,
                      backgroundImage: const AssetImage('assets/img/pro.png'),
                    ),
                    // Espace entre la photo et le texte
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            merchant != null
                                ? '${merchant.lastname.toUpperCase()} ${merchant.firstname}'
                                : 'Utilisateur inconnu',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            merchant?.phone ?? 'Téléphone non disponible',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🔷 CONTENU PRINCIPAL
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Gestion du compte', Icons.settings),
                    SizedBox(height: 8.h),
                    ListTile(
                      leading: Icon(Icons.lock_outline, size: 18.sp),
                      title: Text(
                        'Changer de mot de passe',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      subtitle: Text(
                        'Appuyer pour pour commencer',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primary,
                        size: 16.sp,
                      ),
                      onTap: () => Get.toNamed(AppRoutes.updatePassword),
                    ),
                    // _simpleCard(
                    //   icon: Icons.lock_outline,
                    //   text: 'Modifier le mot de passe',
                    //   onTap: () {
                    //     Get.toNamed(AppRoutes.updatePassword);
                    //   },
                    // ),
                    SizedBox(height: 20.h),
                    _sectionTitle(
                      'Contacts et infos utiles',
                      Icons.contact_page,
                    ),
                    SizedBox(height: 8.h),
                    Obx(() {
                      final contact = apiController.contactInfoModel.value;

                      if (apiController.isLoading.value) {
                        return const Center(
                          child: CustomCircleProgressBar(
                            color: Colors.white,
                            backgroundColor: AppColors.primary,
                            strokeWidth: 5,
                          ),
                        );
                      }

                      if (contact == null) {
                        return Center(
                          child: Column(
                            children: [
                              SizedBox(height: 20.h),
                              Icon(
                                Icons.error,
                                color: AppColors.primary,
                                size: 80.sp,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Impossible de charger les infos de contact",
                                style: TextStyle(fontSize: 14.sp),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return _contactCard(contact);
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),

          // 🔷 BOUTON DÉCONNEXION
          Padding(
            padding: EdgeInsets.all(12.w),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => merchantController.logout(),
                icon: Icon(Icons.logout, color: AppColors.primary, size: 20.sp),
                label: Text(
                  'Déconnexion',
                  style: TextStyle(color: AppColors.primary, fontSize: 14.sp),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24.sp),
        SizedBox(width: 6.w),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
      ],
    );
  }

  Widget simpleCard({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: AppColors.textPrimary, size: 22.sp),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            decoration: TextDecoration.underline,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _contactCard(ContactInfoModel contact) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.phone, size: 18.sp),
          title: Text('Téléphone', style: TextStyle(fontSize: 16.sp)),
          subtitle: Text(
            contact.callCenterPhoneNumber,
            style: TextStyle(fontSize: 12.sp),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primary,
            size: 16.sp,
          ),
          onTap: () => _launchUrl(contact.callCenterPhoneNumber, 'phone'),
        ),
        ListTile(
          leading: Icon(Icons.email, size: 18.sp),
          title: Text('Adresse email', style: TextStyle(fontSize: 16.sp)),
          subtitle: Text(
            contact.callCenterEmail,
            style: TextStyle(fontSize: 12.sp),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primary,
            size: 16.sp,
          ),
          onTap: () => _launchUrl(contact.callCenterEmail, 'email'),
        ),
        ListTile(
          leading: Icon(Icons.language, size: 18.sp),
          title: Text('Site web', style: TextStyle(fontSize: 16.sp)),
          subtitle: Text('www.website.com', style: TextStyle(fontSize: 12.sp)),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primary,
            size: 16.sp,
          ),
          onTap: () => _launchUrl('www.website.com', 'website'),
        ),
        ListTile(
          leading: Icon(Icons.map, size: 18.sp),
          title: Text('Adresse', style: TextStyle(fontSize: 16.sp)),
          subtitle: Text('Ouagadougou', style: TextStyle(fontSize: 12.sp)),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primary,
            size: 16.sp,
          ),
          // Tu peux aussi ajouter un onTap si tu veux ouvrir un plan ou une carte
          onTap: () {}, // optionnel
        ),
      ],
    );
  }
}
