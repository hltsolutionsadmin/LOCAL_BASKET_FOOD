import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

import 'package:local_basket/components/custom_snackbar.dart';
import 'package:local_basket/components/custom_topbar.dart';
import 'package:local_basket/core/constants/colors.dart';
import 'package:local_basket/presentation/cubit/authentication/currentcustomer/get/current_customer_cubit.dart';
import 'package:local_basket/presentation/cubit/authentication/currentcustomer/get/current_customer_state.dart';
import 'package:local_basket/presentation/cubit/authentication/currentcustomer/update/update_current_customer_cubit.dart';
import 'package:local_basket/data/model/authentication/current_customer_model.dart';
import 'package:local_basket/presentation/cubit/authentication/deleteAccount/deleteAccount_cubit.dart';
import 'package:local_basket/presentation/cubit/authentication/deleteAccount/deleteAccount_state.dart';
import 'package:local_basket/presentation/screen/address/address_screen.dart';
import 'package:local_basket/presentation/screen/order/myOrders_screen.dart';
import 'package:local_basket/presentation/screen/profile/faqs_screen.dart';
import 'package:local_basket/presentation/screen/profile/offers_screen.dart';
import 'package:local_basket/presentation/screen/profile/terms&conditions_screen.dart';
import 'package:local_basket/presentation/screen/profile/privacy_policy_screen.dart';
import 'package:local_basket/presentation/screen/widgets/logout.dart';
import 'package:local_basket/presentation/screen/authentication/login_screen.dart';
import 'package:local_basket/presentation/screen/dashboard/dashboard_screen.dart';
import 'package:local_basket/presentation/screen/dashboard/main_dashboard_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedNavIndex = 4;

  @override
  void initState() {
    super.initState();
    context.read<CurrentCustomerCubit>().GetCurrentCustomer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF8),
      appBar: const CustomAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        child: Column(
          children: [
            _buildUserProfile(context),
            const SizedBox(height: 12),
            _buildBasicOptions(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  //
  Widget _buildUserProfile(BuildContext context) {
    return BlocBuilder<CurrentCustomerCubit, CurrentCustomerState>(
      builder: (context, state) {
        if (state is CurrentCustomerLoaded) {
          final customer = state.currentCustomerModel;
          final fullName = [
            customer.firstName?.trim() ?? '',
            customer.lastName?.trim() ?? '',
          ].where((e) => e.isNotEmpty).join(' ');
          final hasName = fullName.isNotEmpty;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => _editProfileName(customer),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFE7E7E7),
                      child: Text(
                        _initials(fullName, customer.mobile),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasName
                                ? fullName
                                : (customer.mobile ?? 'No Phone Number'),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            customer.mobile ?? 'No Phone Number',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.edit_outlined,
                      color: Colors.grey,
                      size: 19,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is CurrentCustomerError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red),
              const SizedBox(height: 12),
              Text(state.message, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed:
                    () => context
                        .read<CurrentCustomerCubit>()
                        .GetCurrentCustomer(context),
                child: const Text("Retry"),
              ),
            ],
          );
        } else if (state is CurrentCustomerLoading) {
          return const Center(child: CupertinoActivityIndicator());
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildBasicOptions(BuildContext context) {
    final List<_Option> options = [
      _Option(
        Icons.location_on_outlined,
        "Addresses",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddressScreen()),
          );
        },
      ),
      _Option(
        Icons.credit_card_outlined,
        "Payment Methods",
        onTap: () => _showComingSoon(context, 'Payment methods'),
      ),
      _Option(
        Icons.workspace_premium_outlined,
        "LB One",
        trailing: const Text(
          'Member',
          style: TextStyle(color: Colors.orange, fontSize: 11),
        ),
        onTap: () => _showComingSoon(context, 'LB One'),
      ),
      _Option(
        Icons.account_balance_wallet_outlined,
        "LB Money",
        trailing: const Text(
          '₹200',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        onTap: () => _showComingSoon(context, 'LB Money'),
      ),
      _Option(
        Icons.card_giftcard_outlined,
        "Refer & Earn",
        trailing: const Text(
          'Earn ₹200',
          style: TextStyle(color: Colors.grey, fontSize: 11),
        ),
        onTap: () => _showComingSoon(context, 'Refer & Earn'),
      ),
      _Option(
        Icons.help_outline,
        "Help & Support",
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FaqsScreen()),
            ),
      ),
      _Option(
        Icons.lock_outline,
        "Privacy Policy",
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
            ),
      ),
      _Option(
        Icons.description_outlined,
        "Terms & Conditions",
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TermsAndConditionsScreen(),
              ),
            ),
      ),
      _Option(
        Icons.logout,
        "Logout",
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => const LogOutCnfrmBottomSheet(),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
          );
        },
      ),
      // _Option(
      //   Icons.delete_forever_outlined,
      //   "Delete Account",
      //   onTap: () {
      //     showModalBottomSheet(
      //       context: context,
      //       isScrollControlled: true,
      //       useRootNavigator: true,
      //       shape: const RoundedRectangleBorder(
      //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      //       ),
      //       builder: (_) => _buildDeleteConfirmation(context),
      //     );
      //   },
      // ),
    ];

    return Column(
      children:
          options.map((opt) {
            return Material(
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                leading: Icon(
                  opt.icon,
                  color: opt.isDestructive ? Colors.red : Colors.grey.shade600,
                ),
                title: Text(
                  opt.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: opt.isDestructive ? Colors.red : Colors.black87,
                  ),
                ),
                trailing:
                    opt.trailing ??
                    Icon(
                      Icons.chevron_right,
                      color: opt.isDestructive ? Colors.red : Colors.grey,
                    ),
                onTap: opt.onTap,
              ),
            );
          }).toList(),
    );
  }

  String _initials(String fullName, String? mobile) {
    final value =
        fullName.trim().isNotEmpty ? fullName.trim() : (mobile ?? 'U');
    final parts = value.split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return value.substring(0, 1).toUpperCase();
  }

  Future<void> _editProfileName(CurrentCustomerModel customer) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _EditNameDialog(customer: customer),
    );

    if (!mounted || name == null) return;
    await context.read<UpdateCurrentCustomerCubit>().updateCustomer({
      'fullName': name,
      'email': customer.email ?? '',
      'fcmToken': null,
      'eato': true,
    }, context);
    if (!mounted) return;
    await context.read<CurrentCustomerCubit>().GetCurrentCustomer(context);
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature will be available soon')));
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedNavIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColor.PrimaryColor,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      onTap: (index) {
        setState(() => _selectedNavIndex = index);
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainDashboard()),
            );
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            );
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MyOrders()),
            );
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OffersScreen()),
            );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer_outlined),
          label: 'Offers',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildDeleteConfirmation(BuildContext context) {
    return BlocProvider.value(
      value: context.read<DeleteAccountCubit>(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColor.PrimaryColor,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              "Are you sure?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.PrimaryColor,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "This will permanently delete your account and all associated data.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
                    listener: (context, state) async {
                      if (state is DeleteAccountSuccess) {
                        Navigator.pop(context);
                        CustomSnackbars.showSuccessSnack(
                          context: context,
                          title: "Deleted",
                          message: "Your account has been deleted.",
                        );
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.clear();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      } else if (state is DeleteAccountFailure) {
                        CustomSnackbars.showErrorSnack(
                          context: context,
                          title: "Error",
                          message:
                              state.message.isEmpty
                                  ? "Failed to delete account"
                                  : state.message,
                        );
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed:
                            state is DeleteAccountLoading
                                ? null
                                : () {
                                  context
                                      .read<DeleteAccountCubit>()
                                      .deleteAccount();
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        child:
                            state is DeleteAccountLoading
                                ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text("Delete"),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Option {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  _Option(this.icon, this.title, {this.trailing, this.onTap});

  bool get isDestructive =>
      title.toLowerCase().contains("logout") ||
      title.toLowerCase().contains("delete");
}

class _EditNameDialog extends StatefulWidget {
  final CurrentCustomerModel customer;

  const _EditNameDialog({required this.customer});

  @override
  State<_EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<_EditNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: [widget.customer.firstName, widget.customer.lastName]
          .whereType<String>()
          .map((value) => value.trim())
          .where((value) => value.isNotEmpty)
          .join(' '),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit your name'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          labelText: 'Full name',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final value = _controller.text.trim();
            if (value.isNotEmpty) Navigator.pop(context, value);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
