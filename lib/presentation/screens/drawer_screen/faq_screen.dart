import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<FAQItem> _filteredFaqItems = [];

  final List<FAQItem> _faqItems = [
    FAQItem(
      question: 'What is this app about?',
      answer:
          'This app helps users manage electronic waste (e-waste) by using AI to classify items for reselling or recycling. It also includes a guide, a marketplace, a community page, and a rewards system.',
    ),
    FAQItem(
      question: 'How does AI classify my e-waste?',
      answer:
          'You can upload a photo of your e-waste, and our AI will assess its condition to suggest whether it should be resold, repaired, or recycled.',
    ),
    FAQItem(
      question: 'Can I manually choose to recycle or resell my item?',
      answer:
          'Yes, while AI provides recommendations, you have the final decision on whether to recycle or sell your item.',
    ),
    FAQItem(
      question: 'What happens if AI makes a wrong classification?',
      answer:
          'If you think an item was misclassified, you can manually override the suggestion or report it for review.',
    ),
    FAQItem(
      question: 'How does the marketplace work?',
      answer:
          'The marketplace allows users to list reusable electronics for sale. Buyers can browse listings and contact sellers directly through the app.',
    ),
    FAQItem(
      question: 'What types of items can I sell?',
      answer:
          'You can sell items like smartphones, laptops, chargers, TVs, and other electronic devices that are still functional or repairable.',
    ),
    FAQItem(
      question: 'Are transactions secure?',
      answer:
          'While the app connects buyers and sellers, we recommend using secure payment methods and verifying the product before purchase.',
    ),
    FAQItem(
      question: 'What is the community page for?',
      answer:
          'The community page allows users to discuss e-waste topics, share tips, and seek advice on repairing or recycling electronics.',
    ),
    FAQItem(
      question: 'How do I earn rewards?',
      answer:
          'You can earn rewards by recycling e-waste, selling reusable items, or engaging in the community. Points can be redeemed for discounts, vouchers, or cashback.',
    ),
    FAQItem(
      question: 'Where can I see my reward points?',
      answer:
          'You can track your reward points in the app’s "Rewards" section.',
    ),
    FAQItem(
      question: 'What if my location has no recycling centers?',
      answer:
          'If no centers are available nearby, the app suggests alternative recycling options and connects you with the nearest available service.',
    ),
    FAQItem(
      question: 'How can I contact customer support?',
      answer:
          'You can reach us through the in-app chat or email support@example.com.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredFaqItems = _faqItems;
    _searchController.addListener(_filterFAQs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFAQs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredFaqItems = _faqItems;
      } else {
        _filteredFaqItems = _faqItems
            .where((item) =>
                item.question.toLowerCase().contains(query) ||
                item.answer.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50).withValues(alpha: 0.1),
        title: const CustomText(
          textName: 'Frequently Asked Questions',
          fontWeight: FontWeight.w700,
        ),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 24, left: 24),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.green),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Icon(Icons.search, color: AppColors.dark),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search FAQs...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              color: AppColors.dark,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _filteredFaqItems.isEmpty
                  ? const Center(
                      child: Text(
                        'No matching FAQs found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredFaqItems.length,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      itemBuilder: (context, index) {
                        return FAQExpansionTile(
                            faqItem: _filteredFaqItems[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;
  bool isExpanded;

  FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}

class FAQExpansionTile extends StatefulWidget {
  final FAQItem faqItem;

  const FAQExpansionTile({
    super.key,
    required this.faqItem,
  });

  @override
  _FAQExpansionTileState createState() => _FAQExpansionTileState();
}

class _FAQExpansionTileState extends State<FAQExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      borderOnForeground: true,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: CustomText(
          textName: widget.faqItem.question,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        trailing: Icon(
          widget.faqItem.isExpanded
              ? Icons.keyboard_arrow_up
              : Icons.keyboard_arrow_down,
          color: Colors.grey.shade700,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            widget.faqItem.isExpanded = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: CustomText(
              textName: widget.faqItem.answer,
              textColor: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
              lineHeight: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
