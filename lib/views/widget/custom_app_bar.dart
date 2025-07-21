import 'package:flutter/material.dart';
import 'package:pv_deme/constant/app_color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack; // <- ajout

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack, // <- ajout
  });

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.of(context).canPop();

    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // TITRE CENTRÉ
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // BOUTON RETOUR SI POSSIBLE
            if (canGoBack || onBack != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: InkWell(
                    onTap: () {
                      if (onBack != null) {
                        onBack!(); // action personnalisée
                      } else {
                        Navigator.of(
                          context,
                        ).maybePop(); // comportement par défaut
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryLight,
                        border: Border.all(color: AppColors.primaryLight),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
