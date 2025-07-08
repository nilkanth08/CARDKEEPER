import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/card_item_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/search_bar_widget.dart';

class CardListDashboard extends StatefulWidget {
  const CardListDashboard({super.key});

  @override
  State<CardListDashboard> createState() => _CardListDashboardState();
}

class _CardListDashboardState extends State<CardListDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Mock data for cards
  final List<Map<String, dynamic>> _cardsList = [
    {
      "id": 1,
      "bankName": "Chase Bank",
      "cardType": "Credit",
      "lastFourDigits": "4532",
      "paymentStatus": "paid",
      "daysUntilDue": 15,
      "cardLimit": "\$5,000",
      "billAmount": "\$1,250.50",
      "dueDate": "2024-02-15",
      "bankLogo":
          "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=100&h=100&fit=crop",
    },
    {
      "id": 2,
      "bankName": "Bank of America",
      "cardType": "Debit",
      "lastFourDigits": "8976",
      "paymentStatus": "unpaid",
      "daysUntilDue": 3,
      "cardLimit": "\$2,500",
      "billAmount": "\$890.25",
      "dueDate": "2024-02-05",
      "bankLogo":
          "https://images.unsplash.com/photo-1541354329998-f4d9a9f9297f?w=100&h=100&fit=crop",
    },
    {
      "id": 3,
      "bankName": "Wells Fargo",
      "cardType": "Credit",
      "lastFourDigits": "2341",
      "paymentStatus": "partial",
      "daysUntilDue": 7,
      "cardLimit": "\$3,000",
      "billAmount": "\$1,500.75",
      "dueDate": "2024-02-10",
      "bankLogo":
          "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=100&h=100&fit=crop",
    },
    {
      "id": 4,
      "bankName": "Citibank",
      "cardType": "Prepaid",
      "lastFourDigits": "7654",
      "paymentStatus": "paid",
      "daysUntilDue": 20,
      "cardLimit": "\$1,000",
      "billAmount": "\$450.00",
      "dueDate": "2024-02-20",
      "bankLogo":
          "https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=100&h=100&fit=crop",
    },
  ];

  List<Map<String, dynamic>> get _filteredCards {
    if (_searchQuery.isEmpty) return _cardsList;

    return _cardsList.where((card) {
      final bankName = (card['bankName'] as String).toLowerCase();
      final cardType = (card['cardType'] as String).toLowerCase();
      final status = (card['paymentStatus'] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();

      return bankName.contains(query) ||
          cardType.contains(query) ||
          status.contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Simulate refresh by updating data
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  void _onCardTap(Map<String, dynamic> card) {
    Navigator.pushNamed(context, '/card-details', arguments: card);
  }

  void _onMarkAsPaid(Map<String, dynamic> card) {
    setState(() {
      final index = _cardsList.indexWhere((c) => c['id'] == card['id']);
      if (index != -1) {
        _cardsList[index]['paymentStatus'] = 'paid';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Card payment marked as paid'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _onDeleteCard(Map<String, dynamic> card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Card'),
        content: Text('Are you sure you want to delete this card?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _cardsList.removeWhere((c) => c['id'] == card['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Card deleted successfully'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
              );
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _onSetReminder(Map<String, dynamic> card) {
    Navigator.pushNamed(context, '/payment-reminders', arguments: card);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          if (_isSearching) _buildSearchSection(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDashboardTab(),
                _buildPlaceholderTab('Add Card'),
                _buildPlaceholderTab('Reminders'),
                _buildPlaceholderTab('Settings'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0 ? _buildFAB() : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.cardColor,
      elevation: 2,
      title: _isSearching
          ? null
          : Text(
              'CardKeeper',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
      actions: [
        if (!_isSearching) ...[
          Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_cardsList.length} Cards',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: _toggleSearch,
            icon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ] else ...[
          IconButton(
            onPressed: _toggleSearch,
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      color: AppTheme.lightTheme.cardColor,
      child: SearchBarWidget(
        controller: _searchController,
        onChanged: _onSearchChanged,
        hintText: 'Search by bank, type, or status...',
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.lightTheme.cardColor,
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              size: 20,
              color: _tabController.index == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            text: 'Dashboard',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'add_card',
              size: 20,
              color: _tabController.index == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            text: 'Add Card',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'notifications',
              size: 20,
              color: _tabController.index == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            text: 'Reminders',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'settings',
              size: 20,
              color: _tabController.index == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            text: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return _filteredCards.isEmpty
        ? EmptyStateWidget(
            onAddCard: () => Navigator.pushNamed(context, '/add-card'),
          )
        : RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              itemCount: _filteredCards.length,
              itemBuilder: (context, index) {
                final card = _filteredCards[index];
                return CardItemWidget(
                  card: card,
                  onTap: () => _onCardTap(card),
                  onMarkAsPaid: () => _onMarkAsPaid(card),
                  onDelete: () => _onDeleteCard(card),
                  onSetReminder: () => _onSetReminder(card),
                );
              },
            ),
          );
  }

  Widget _buildPlaceholderTab(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'construction',
            size: 48,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 2.h),
          Text(
            '$tabName Coming Soon',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, '/add-card'),
      child: CustomIconWidget(
        iconName: 'add',
        size: 24,
        color: AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor!,
      ),
    );
  }
}
