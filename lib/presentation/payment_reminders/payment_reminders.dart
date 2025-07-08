import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/date_header_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/reminder_card_widget.dart';

class PaymentReminders extends StatefulWidget {
  const PaymentReminders({super.key});

  @override
  State<PaymentReminders> createState() => _PaymentRemindersState();
}

class _PaymentRemindersState extends State<PaymentReminders>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  bool _isRefreshing = false;

  final List<Map<String, dynamic>> _mockReminders = [
    {
      "id": 1,
      "cardName": "Chase Sapphire Preferred",
      "bankName": "Chase Bank",
      "bankLogo":
          "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=100&h=100&fit=crop",
      "billAmount": "\$2,450.00",
      "dueDate": DateTime.now().add(Duration(days: 2)),
      "status": "unpaid",
      "cardType": "Credit",
      "lastFourDigits": "4521"
    },
    {
      "id": 2,
      "cardName": "American Express Gold",
      "bankName": "American Express",
      "bankLogo":
          "https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=100&h=100&fit=crop",
      "billAmount": "\$1,875.50",
      "dueDate": DateTime.now().add(Duration(days: 5)),
      "status": "unpaid",
      "cardType": "Credit",
      "lastFourDigits": "1009"
    },
    {
      "id": 3,
      "cardName": "Wells Fargo Platinum",
      "bankName": "Wells Fargo",
      "bankLogo":
          "https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=100&h=100&fit=crop",
      "billAmount": "\$892.25",
      "dueDate": DateTime.now().subtract(Duration(days: 1)),
      "status": "overdue",
      "cardType": "Credit",
      "lastFourDigits": "7834"
    },
    {
      "id": 4,
      "cardName": "Bank of America Cash Rewards",
      "bankName": "Bank of America",
      "bankLogo":
          "https://images.unsplash.com/photo-1541354329998-f4d9a9f9297f?w=100&h=100&fit=crop",
      "billAmount": "\$1,234.75",
      "dueDate": DateTime.now().add(Duration(days: 10)),
      "status": "unpaid",
      "cardType": "Credit",
      "lastFourDigits": "2156"
    },
    {
      "id": 5,
      "cardName": "Citi Double Cash",
      "bankName": "Citibank",
      "bankLogo":
          "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=100&h=100&fit=crop",
      "billAmount": "\$567.80",
      "dueDate": DateTime.now().add(Duration(days: 15)),
      "status": "paid",
      "cardType": "Credit",
      "lastFourDigits": "9876"
    },
    {
      "id": 6,
      "cardName": "Capital One Venture",
      "bankName": "Capital One",
      "bankLogo":
          "https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=100&h=100&fit=crop",
      "billAmount": "\$3,125.00",
      "dueDate": DateTime.now().subtract(Duration(days: 3)),
      "status": "overdue",
      "cardType": "Credit",
      "lastFourDigits": "4455"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredReminders() {
    final now = DateTime.now();
    switch (_selectedTabIndex) {
      case 0: // Upcoming
        return _mockReminders.where((reminder) {
          final dueDate = reminder["dueDate"] as DateTime;
          return dueDate.isAfter(now) && reminder["status"] != "paid";
        }).toList();
      case 1: // Overdue
        return _mockReminders.where((reminder) {
          final dueDate = reminder["dueDate"] as DateTime;
          return dueDate.isBefore(now) && reminder["status"] != "paid";
        }).toList();
      case 2: // Paid
        return _mockReminders
            .where((reminder) => reminder["status"] == "paid")
            .toList();
      case 3: // All
      default:
        return _mockReminders;
    }
  }

  int _getOverdueCount() {
    final now = DateTime.now();
    return _mockReminders.where((reminder) {
      final dueDate = reminder["dueDate"] as DateTime;
      return dueDate.isBefore(now) && reminder["status"] != "paid";
    }).length;
  }

  String _getDueDateText(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;

    if (difference < 0) {
      return "Overdue by ${difference.abs()} day${difference.abs() == 1 ? '' : 's'}";
    } else if (difference == 0) {
      return "Due today";
    } else if (difference == 1) {
      return "Due tomorrow";
    } else {
      return "Due in $difference days";
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _handleQuickAction(String action, Map<String, dynamic> reminder) {
    switch (action) {
      case 'mark_paid':
        setState(() {
          reminder["status"] = "paid";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment marked as paid')),
        );
        break;
      case 'snooze_1':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reminder snoozed for 1 day')),
        );
        break;
      case 'snooze_3':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reminder snoozed for 3 days')),
        );
        break;
      case 'snooze_7':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reminder snoozed for 1 week')),
        );
        break;
      case 'edit_amount':
        Navigator.pushNamed(context, '/card-details');
        break;
    }
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notification Settings',
                    style: AppTheme.lightTheme.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 3.h),
                  _buildSettingsTile(
                    'Reminder Frequency',
                    'Daily',
                    Icons.schedule,
                  ),
                  _buildSettingsTile(
                    'Notification Time',
                    '9:00 AM',
                    Icons.access_time,
                  ),
                  _buildSettingsTile(
                    'Sound Selection',
                    'Default',
                    Icons.volume_up,
                  ),
                  _buildSettingsTile(
                    'Badge Settings',
                    'Enabled',
                    Icons.notifications_active,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(String title, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: icon.toString().split('.').last,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 6.w,
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodyLarge,
        ),
        subtitle: Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: CustomIconWidget(
          iconName: 'chevron_right',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 5.w,
        ),
        onTap: () {},
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupRemindersByDate(
      List<Map<String, dynamic>> reminders) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final reminder in reminders) {
      final dueDate = reminder["dueDate"] as DateTime;
      final dateKey = "${dueDate.day}/${dueDate.month}/${dueDate.year}";

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(reminder);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final filteredReminders = _getFilteredReminders();
    final groupedReminders = _groupRemindersByDate(filteredReminders);
    final overdueCount = _getOverdueCount();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Payment Reminders'),
        actions: [
          IconButton(
            onPressed: _showNotificationSettings,
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Upcoming'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Overdue'),
                  if (overdueCount > 0) ...[
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.errorLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        overdueCount.toString(),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(text: 'Paid'),
            Tab(text: 'All'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: filteredReminders.isEmpty
            ? EmptyStateWidget(
                tabIndex: _selectedTabIndex,
                onAddReminder: () {
                  Navigator.pushNamed(context, '/add-card');
                },
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                itemCount: groupedReminders.length,
                itemBuilder: (context, index) {
                  final dateKey = groupedReminders.keys.elementAt(index);
                  final remindersForDate = groupedReminders[dateKey]!;
                  final firstReminder = remindersForDate.first;
                  final dueDate = firstReminder["dueDate"] as DateTime;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DateHeaderWidget(
                        date: dueDate,
                        reminderCount: remindersForDate.length,
                      ),
                      ...remindersForDate.map((reminder) => ReminderCardWidget(
                            reminder: reminder,
                            dueDateText: _getDueDateText(
                                reminder["dueDate"] as DateTime),
                            onTap: () {
                              Navigator.pushNamed(context, '/card-details');
                            },
                            onQuickAction: (action) =>
                                _handleQuickAction(action, reminder),
                          )),
                    ],
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-card');
        },
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor!,
          size: 6.w,
        ),
      ),
    );
  }
}
