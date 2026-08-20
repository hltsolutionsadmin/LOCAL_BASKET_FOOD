import 'package:local_basket/core/constants/colors.dart';
import 'package:local_basket/presentation/screen/widgets/restaurantMenu/menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final bool enableIncrement;

  const CartItemCard({
    super.key,
    required this.item,
    required this.quantity,
    required this.onQuantityChanged,
    this.enableIncrement = true,
  });

  @override
  Widget build(BuildContext context) {
    final isVeg = (item['type']?.toLowerCase() ?? '') == 'veg';
    final price = item['price'] ?? item['unitPrice'] ?? item['totalPrice'] ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          vegNonVegIcon(isVeg),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? '',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: const Color(0xFF1F1F1F),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  "₹$price",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: const Color(0xFF2F2F2F),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 104,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColor.PrimaryColor.withValues(alpha: 0.18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => onQuantityChanged(quantity - 1),
                  borderRadius: BorderRadius.circular(8),
                  child: const SizedBox(
                    width: 30,
                    height: 34,
                    child: Icon(Icons.remove, size: 18, color: Colors.red),
                  ),
                ),
                Text(
                  '$quantity',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColor.PrimaryColor,
                  ),
                ),
                InkWell(
                  onTap:
                      enableIncrement
                          ? () => onQuantityChanged(quantity + 1)
                          : null,
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 30,
                    height: 34,
                    child: Icon(
                      Icons.add,
                      size: 18,
                      color:
                          enableIncrement ? AppColor.PrimaryColor : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
