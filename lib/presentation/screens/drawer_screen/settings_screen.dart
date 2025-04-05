import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          textName: 'Settings',
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            // App Settings Section
            _buildSectionHeader('App Settings'),
            _buildSettingItem(
              context,
              'Clear Cache',
              'Free up storage space',
              Icons.cleaning_services_outlined,
              () => _showClearCacheDialog(context),
            ),
            const Divider(),

            // Support Section
            _buildSectionHeader('Support'),
            _buildSettingItem(
              context,
              'Report a Bug',
              'Help us improve the app',
              Icons.bug_report_outlined,
              () => _navigateToReportBug(context),
            ),
            const Divider(),
            _buildSettingItem(
              context,
              'Suggestions for Us',
              'Share your ideas',
              Icons.lightbulb_outline,
              () => _navigateToSuggestions(context),
            ),
            const Divider(),

            // Legal Section
            _buildSectionHeader('Legal'),
            _buildSettingItem(
              context,
              'Disclaimer',
              'Terms and conditions',
              Icons.description_outlined,
              () => _navigateToDisclaimer(context),
            ),
            const Divider(),

            // Account Section
            _buildSectionHeader('Account'),
            _buildSettingItem(
              context,
              'Delete Account',
              'Permanently delete your account',
              Icons.delete_outline,
              () => _showDeleteAccountDialog(context),
              isDestructive: true,
            ),
            const SizedBox(height: 24),

            // App Version
            Center(
              child: Text(
                'Version 1.0.5',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: CustomText(
        textName: title,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        textColor: AppColors.green,
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppColors.dark,
      ),
      title: CustomText(
        textName: title,
        textColor: isDestructive ? Colors.red : null,
        fontWeight: FontWeight.w600,
      ),
      subtitle: CustomText(
        textName: subtitle,
        fontWeight: FontWeight.w400,
        textColor: AppColors.placeHolder,
      ),
      onTap: onTap,
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear the app cache?'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.placeHolder,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.green,
            ),
            onPressed: () {
              DefaultCacheManager().emptyCache();
              imageCache.clear();
              imageCache.clearLiveImages();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: const Text('CLEAR'),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToReportBug(BuildContext context) async {
    const String subject = "Report Bug For EcoCycle";
    const String stringText = "Enter Details Of Bug Here And Send";
    String uri =
        'mailto:sarthak05patil@gmail.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(stringText)}';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No email client found")),
      );
    }
  }

  Future<void> _navigateToSuggestions(BuildContext context) async {
    const String subject = "Suggestions For EcoCycle";
    const String stringText =
        "Enter Details Of Your Suggestions, Feel Free To Send";
    String uri =
        'mailto:sarthak05patil@gmail.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(stringText)}';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No email client found')),
      );
      print("No email client found");
    }
  }

  void _navigateToDisclaimer(BuildContext context) {
    disclaimerDialog(context);
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              // TODO: Implement account deletion logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming Soon')),
              );
              Navigator.pop(context);
              // After successful deletion, navigate back to login screen
            },
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  void disclaimerDialog(BuildContext context) {
    var dialog = AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      title: CustomText(
        textName: "Disclaimer",
        fontSize: 20,
        textColor: Theme.of(context).textTheme.labelLarge!.color,
        fontWeight: FontWeight.bold,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      content: SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomText(
                fontWeight: FontWeight.w500,
                maxLines: 10,
                textColor: Theme.of(context).textTheme.labelMedium!.color,
                textName:
                    "Wallpapers Are For Personal Use Only. For Commercial Give Us Proper Credit. Sharing Of This Wallpapers Not Allowed"),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Container(
                  height: 50,
                  width: 70,
                  decoration: BoxDecoration(
                      color: Theme.of(context).textTheme.titleMedium!.color,
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                    child: CustomText(
                      textName: "OK",
                      textColor: Theme.of(context).textTheme.titleLarge!.color,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }
}
