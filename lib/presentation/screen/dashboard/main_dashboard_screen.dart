import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_basket/components/custom_topbar.dart';
import 'package:local_basket/core/constants/colors.dart';
import 'package:local_basket/presentation/cubit/notifications/fcmToken/fcm_token_cubit.dart';
import 'package:local_basket/presentation/cubit/address/getAddress/getAddress_cubit.dart';
import 'package:local_basket/presentation/cubit/address/getAddress/getAddress_state.dart';
import 'package:local_basket/presentation/screen/notifications/notifications_screen.dart';
import 'package:local_basket/presentation/screen/order/myOrders_screen.dart';
import 'package:local_basket/presentation/screen/address/address_screen.dart';
import 'package:local_basket/presentation/screen/profile/offers_screen.dart';
import 'package:local_basket/presentation/screen/profile/profile_screen.dart';
import 'package:local_basket/presentation/screen/widgets/dashboard/offersCard_widget.dart';
import 'dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:local_basket/core/utils/push_notication_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_basket/presentation/cubit/authentication/currentcustomer/update/update_current_customer_cubit.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedNavIndex = 0;
  final NotificationServices _notificationServices = NotificationServices();

  Future<void> _normalizeOfferStateOnFoodTap() async {
    final prefs = await SharedPreferences.getInstance();
    final wasOfferFlow = prefs.getBool('is_offer_flow') ?? false;
    final wasOfferApplied = prefs.getBool('offer_applied') ?? false;

    await prefs.remove('is_offer_flow');
    await prefs.remove('offer_applied');
    await prefs.remove('offer_id');
    await prefs.remove('offer_coupon');
    await prefs.remove('offer_started_at');

    if (!wasOfferFlow && !wasOfferApplied) return;
    if (!mounted) return;
  }

  @override
  void initState() {
    super.initState();
    _initNotifications();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<GetAddressCubit>().fetchAddress(context);
      }
    });
  }

  Future<void> _initNotifications() async {
    await _notificationServices.forgroundMessage();

    if (!mounted) return;
    await _notificationServices.firebaseInit(context);

    if (!mounted) return;
    await _notificationServices.setupInteractMessage(context);

    if (!mounted) return;
    await _notificationServices.isRefreshToken();

    // Notification permission is requested inside getDeviceToken() above.
    // Location permission is requested right after, so both prompts appear
    // back-to-back on first landing here, instead of waiting until the
    // user drills into the Food dashboard.
    final fcmToken = await _notificationServices.getDeviceToken();
    if (mounted && fcmToken != null) {
      final storage = FlutterSecureStorage();
      final savedAuthToken = await storage.read(key: 'TOKEN');
      if (savedAuthToken != null && savedAuthToken.isNotEmpty) {
        print('Updating customer with FCM token: $fcmToken');
        final payload = {
          'fullName': '',
          'email': '',
          'local_basket': true,
          'fcmToken': fcmToken,
        };
        if (mounted) {
          context.read<UpdateCurrentCustomerCubit>().updateCustomer(
            payload,
            context,
          );

          final deviceType = Platform.isAndroid ? 'ANDROID' : 'IOS';
          debugPrint('Storing FCM token via fcm-token API: $fcmToken');
          context.read<FcmTokenCubit>().storeFcmToken(
            fcmToken: fcmToken,
            deviceType: deviceType,
          );
        }
      }
    }

    if (!mounted) return;
    await _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('📍 MainDashboard initial permission status: $permission');

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        debugPrint('📍 MainDashboard after requestPermission: $permission');
      }
    } catch (e) {
      debugPrint('❌ MainDashboard location permission request failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF8),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _openAddressScreen,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: AppColor.PrimaryColor,
                              size: 21,
                            ),
                            const SizedBox(width: 7),
                            Expanded(child: _SavedHomeAddress()),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                _HeaderIcon(
                  icon: Icons.notifications_none_rounded,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: _openFoodDashboard,
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE9E5E2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                    const SizedBox(width: 9),
                    const Expanded(
                      child: Text(
                        'Search for restaurants or cuisines',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                    Icon(
                      Icons.tune_rounded,
                      color: AppColor.PrimaryColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            const OffersCarousel(height: 150),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _QuickCategory(
                  icon: Icons.delivery_dining,
                  title: 'Food\nDelivery',
                  onTap: _openFoodDashboard,
                ),
                _QuickCategory(
                  icon: Icons.star_outline_rounded,
                  title: 'Special\nZone',
                  onTap: () => _openCategoryTab('Special Zone'),
                ),
                _QuickCategory(
                  icon: Icons.set_meal_outlined,
                  title: 'Fresh\nMeat',
                  onTap: () => _openCategoryTab('Fresh Meat'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _SectionTitle(
              title: 'Top picks for you',
              onTap: _openFoodDashboard,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 190,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _RestaurantCard(
                    name: 'Pizza Time',
                    image: 'assets/images/avif/pizza.avif',
                    rating: '4.4',
                    time: '30 mins',
                    price: 'Pizza, Italian',
                  ),
                  _RestaurantCard(
                    name: 'Biryani House',
                    image: 'assets/images/avif/biriyani.avif',
                    rating: '4.6',
                    time: '25 mins',
                    price: 'Biryani, North Indian',
                  ),
                  _RestaurantCard(
                    name: 'Fresh Rolls',
                    image: 'assets/images/jpg/rolls.jpg',
                    rating: '4.3',
                    time: '20 mins',
                    price: 'Rolls, Snacks',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _SectionTitle(title: 'Offers for you', onTap: () {}),
            const SizedBox(height: 11),
            _buildDiscountCard(),
            const SizedBox(height: 12),
            _buildFlatOfferCard(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColor.PrimaryColor,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: (index) {
          switch (index) {
            case 1:
              _openFoodDashboard();
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyOrders()),
              );
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OffersScreen()),
              );
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined),
            label: "Offers",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  void _openFoodDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  void _openCategoryTab(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _UnderDevelopmentScreen(title: title)),
    );
  }

  void _openAddressScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddressScreen()),
    ).then((_) {
      if (mounted) {
        context.read<GetAddressCubit>().fetchAddress(context);
      }
    });
  }

  Widget _buildDiscountCard() {
    return _OfferRow(
      color: const Color(0xFFF1F2FF),
      accent: const Color(0xFF26358F),
      title: '60% OFF',
      subtitle: 'UPTO ₹120',
      detail: 'On orders above ₹199',
      code: 'WELCOME60',
    );
  }

  Widget _buildFlatOfferCard() {
    return _OfferRow(
      color: const Color(0xFFFFF2E8),
      accent: AppColor.PrimaryColor,
      title: 'FLAT ₹80 OFF',
      subtitle: 'On orders above ₹249',
      detail: 'Use code FLAT80',
      code: 'FLAT80',
    );
  }
}

class _SavedHomeAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAddressCubit, GetAddressState>(
      builder: (context, state) {
        String addressText = 'Getting address...';

        if (state is GetAddressSuccess) {
          if (state.addressModel.content.isEmpty) {
            addressText = 'Add a delivery address';
          } else {
            final address = state.addressModel.content.first;
            final parts =
                [
                      address.addressLine1,
                      address.city,
                      address.state,
                      address.postalCode,
                    ]
                    .whereType<String>()
                    .map((part) => part.trim())
                    .where((part) => part.isNotEmpty)
                    .toList();
            addressText = parts.isEmpty ? 'Saved address' : parts.join(', ');
          }
        } else if (state is GetAddressFailure) {
          addressText = 'Add a delivery address';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Home', style: TextStyle(fontWeight: FontWeight.w800)),
            Text(
              addressText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                color:
                    addressText == 'Add a delivery address'
                        ? AppColor.PrimaryColor
                        : Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: AppColor.PrimaryColor, size: 23),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFFE9E5E2)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SectionTitle({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'See all',
            style: TextStyle(
              color: AppColor.PrimaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _OfferRow extends StatelessWidget {
  final Color color;
  final Color accent;
  final String title;
  final String subtitle;
  final String detail;
  final String code;

  const _OfferRow({
    required this.color,
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: accent,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            code,
            style: TextStyle(
              color: accent,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final String name;
  final String image;
  final String rating;
  final String time;
  final String price;

  const _RestaurantCard({
    required this.name,
    required this.image,
    required this.rating,
    required this.time,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              height: 125,
              width: 155,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              const Icon(Icons.star, size: 13, color: Colors.green),
              const SizedBox(width: 3),
              Text(rating, style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 6),
              Text(
                "• $time",
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          Text(price, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _QuickCategory extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _QuickCategory({required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 92,
        width: 92,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.deepOrange.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.deepOrange, size: 23),
            ),
            const SizedBox(height: 7),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🚧 Under Development Screen
class _UnderDevelopmentScreen extends StatefulWidget {
  final String title;
  const _UnderDevelopmentScreen({required this.title});

  @override
  State<_UnderDevelopmentScreen> createState() =>
      _UnderDevelopmentScreenState();
}

class _UnderDevelopmentScreenState extends State<_UnderDevelopmentScreen> {
  final _notificationServices = NotificationServices();

  Future<void> _initFcmAndUpdate() async {
    await _notificationServices.requestNotificationPermissions();
    await _notificationServices.enableForegroundNotifications();
    _notificationServices.initializeFirebaseMessaging(context);
    await _notificationServices.setupNotificationInteraction(context);

    final token = await _notificationServices.getDeviceToken();
    if (!mounted) return;

    final storage = FlutterSecureStorage();
    final savedAuthToken = await storage.read(key: 'TOKEN');

    if (token != null && savedAuthToken != null && savedAuthToken.isNotEmpty) {
      _updateFcmToken(token);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      final storage = FlutterSecureStorage();
      final savedAuthToken = await storage.read(key: 'TOKEN');
      if (savedAuthToken != null && savedAuthToken.isNotEmpty) {
        _updateFcmToken(newToken);
      }
    });
  }

  void _updateFcmToken(String token) {
    if (!mounted) return;
    final deviceType = Platform.isAndroid ? 'ANDROID' : 'IOS';
    debugPrint('Storing refreshed FCM token via fcm-token API: $token');
    context.read<FcmTokenCubit>().storeFcmToken(
      fcmToken: token,
      deviceType: deviceType,
    );
  }

  @override
  void initState() {
    super.initState();
    _initFcmAndUpdate();
  }

  IconData _getIcon() {
    switch (widget.title.toLowerCase()) {
      case "special zone":
        return Icons.star;

      case "fresh meat":
        return Icons.set_meal;
      case "grocery":
        return Icons.local_grocery_store;
      default:
        return Icons.fastfood;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.White,
      appBar: CustomAppBar(title: widget.title),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_getIcon(), size: 100, color: AppColor.PrimaryColor),
              const SizedBox(height: 20),
              Text(
                "${widget.title}\nComing Soon!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColor.PrimaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "We’re working hard to bring you\npremium ${widget.title} experience.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.PrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Notify Me",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
