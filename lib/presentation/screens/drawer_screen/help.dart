import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const CustomText(
          textName: 'Help & Support',
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: const Color(0xFF4CAF50).withValues(alpha: 0.1),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF4CAF50).withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSearchBar(),
            const SizedBox(height: 24),
            _buildQuickHelp(context),
            const SizedBox(height: 24),
            _buildHelpSection(
              context,
              title: 'AI Classification',
              icon: Icons.camera_alt,
              color: Colors.blue,
              children: [
                _buildHelpTopic(
                  'How to scan e-waste',
                  'Point your camera at the electronic item and tap the scan button. '
                      'Our AI will analyze the item and suggest whether it should be recycled or resold.',
                  Icons.photo_camera,
                ),
                _buildHelpTopic(
                  'Improving scan accuracy',
                  'Ensure good lighting and a clear background. Place the item on a flat surface '
                      'and make sure the entire item is visible in the frame.',
                  Icons.lightbulb_outline,
                ),
                _buildHelpTopic(
                  'Understanding results',
                  'After scanning, you\'ll see either "Recycle" or "Resell" recommendation along with '
                      'an estimated value and environmental impact score.',
                  Icons.assessment,
                ),
              ],
            ),
            _buildHelpSection(
              context,
              title: 'Recycling & Reselling Guide',
              icon: Icons.eco,
              color: Colors.green,
              children: [
                _buildHelpTopic(
                  'Preparing items for recycling',
                  'Remove batteries, clean the item, and package it safely. Follow our item-specific '
                      'guidelines for data wiping and disassembly if needed.',
                  Icons.delete_outline,
                ),
                _buildHelpTopic(
                  'Preparing items for resale',
                  'Clean the item thoroughly, take clear photos from multiple angles, and provide an '
                      'honest description including any defects or wear.',
                  Icons.sell,
                ),
                _buildHelpTopic(
                  'Finding recycling centers',
                  'Use the map feature to locate certified e-waste recycling centers near you. '
                      'Filter by accepted items and operating hours.',
                  Icons.location_on,
                ),
              ],
            ),
            _buildHelpSection(
              context,
              title: 'Marketplace',
              icon: Icons.store,
              color: Colors.orange,
              children: [
                _buildHelpTopic(
                  'Listing an item',
                  'Tap the "+" button on the Marketplace tab, upload photos, add a description, '
                      'set your price, and choose shipping options.',
                  Icons.add_box,
                ),
                _buildHelpTopic(
                  'Safe transactions',
                  'Use our in-app payment system for buyer protection. Never share payment details '
                      'outside the app. Meet in public places for local pickups.',
                  Icons.security,
                ),
                _buildHelpTopic(
                  'Shipping guidelines',
                  'Package electronics securely with appropriate padding. Use our integrated '
                      'shipping labels for discounted rates and tracking.',
                  Icons.local_shipping,
                ),
              ],
            ),
            _buildHelpSection(
              context,
              title: 'Community',
              icon: Icons.people,
              color: Colors.purple,
              children: [
                _buildHelpTopic(
                  'Joining local groups',
                  'Browse community groups on the Community tab and tap "Join" to connect with '
                      'like-minded people in your area interested in sustainable electronics.',
                  Icons.group_add,
                ),
                _buildHelpTopic(
                  'Creating events',
                  'Organize e-waste collection drives or repair workshops by tapping "Create Event" '
                      'and filling in the details. Invite community members directly.',
                  Icons.event,
                ),
                _buildHelpTopic(
                  'Sharing knowledge',
                  'Post repair guides, upcycling ideas, or recycling tips to help others extend '
                      'the life of their electronics and reduce waste.',
                  Icons.lightbulb,
                ),
              ],
            ),
            _buildHelpSection(
              context,
              title: 'Rewards Program',
              icon: Icons.card_giftcard,
              color: Colors.amber,
              children: [
                _buildHelpTopic(
                  'Earning points',
                  'Earn EcoPoints for every item you recycle or resell, participating in community '
                      'events, and completing educational challenges about e-waste.',
                  Icons.stars,
                ),
                _buildHelpTopic(
                  'Redeeming rewards',
                  'Exchange your EcoPoints for discounts at partner stores, tree planting donations, '
                      'or credits toward shipping fees on the marketplace.',
                  Icons.redeem,
                ),
                _buildHelpTopic(
                  'Achievement badges',
                  'Unlock special badges for milestones like recycling your first 10 items or '
                      'helping divert 100kg of e-waste from landfills.',
                  Icons.emoji_events,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildContactSupport(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for help...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF4CAF50)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildQuickHelp(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Help',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildQuickHelpCard(
                context,
                'How to Scan',
                Icons.camera_alt,
                Colors.blue.shade100,
                () {
                  // Navigate to specific help topic
                },
              ),
              _buildQuickHelpCard(
                context,
                'Selling Guide',
                Icons.sell,
                AppColors.green.withValues(alpha: 0.6),
                () {
                  // Navigate to specific help topic
                },
              ),
              _buildQuickHelpCard(
                context,
                'Recycling Map',
                Icons.map,
                Colors.orange.shade100,
                () {
                  // Navigate to specific help topic
                },
              ),
              _buildQuickHelpCard(
                context,
                'Earn Rewards',
                Icons.card_giftcard,
                Colors.purple.shade100,
                () {
                  // Navigate to specific help topic
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickHelpCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: AppColors.dark.withValues(alpha: 0.7)),
            const SizedBox(height: 8),
            CustomText(
              textName: title,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500,
              textColor: AppColors.dark.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: children,
      ),
    );
  }

  Widget _buildHelpTopic(String title, String content, IconData icon) {
    return ExpansionTile(
      leading: Icon(icon, color: AppColors.dark, size: 20),
      title: CustomText(
        textName: title,
        fontSize: 15,
        textColor: AppColors.dark,
        fontWeight: FontWeight.w500,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: CustomText(
            textName: content,
            textColor: AppColors.dark.withValues(alpha: 0.7),
            fontWeight: FontWeight.w400,
            lineHeight: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildContactSupport(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Still need help?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Open chat with support
                  },
                  icon: Icon(
                    Icons.chat,
                    color: AppColors.white,
                  ),
                  label: CustomText(
                    textName: 'Chat with us',
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Open email client
                  },
                  icon: Icon(
                    Icons.email,
                    color: AppColors.green,
                  ),
                  label: CustomText(
                    textName: 'Email support',
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.green,
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.green,
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    side: BorderSide(
                      color: AppColors.green,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              onPressed: () {
                Get.toNamed("/faq");
              },
              icon: Icon(
                Icons.help_outline,
                size: 18,
                color: AppColors.dark,
              ),
              label: CustomText(
                textName: 'View Frequently Asked Questions',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                textColor: AppColors.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
