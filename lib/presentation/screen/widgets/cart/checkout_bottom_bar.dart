import 'package:local_basket/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CheckoutBottomBar extends StatelessWidget {
  final double subtotal;
  final double deliveryCharge;
  final double total;
  final bool loading;

  /// When true, a coupon/promo code is applied and only Cash on Delivery is
  /// offered for this order; otherwise only Pay Online (Razorpay) is offered.
  final bool codAvailable;
  final VoidCallback onPlaceOrder;
  final VoidCallback onCodOrder;

  const CheckoutBottomBar({
    super.key,
    required this.subtotal,
    required this.deliveryCharge,
    required this.total,
    required this.loading,
    required this.onPlaceOrder,
    required this.onCodOrder,
    this.codAvailable = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonText =
        codAvailable ? "Proceed to Checkout" : "Proceed to Checkout";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: SafeArea(
        top: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.only(left: 16, right: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF252525),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColor.PrimaryColor.withValues(alpha: 0.24),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "To Pay",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "₹${total.toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed:
                      loading
                          ? null
                          : (codAvailable ? onCodOrder : onPlaceOrder),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.PrimaryColor,
                    disabledBackgroundColor: AppColor.PrimaryColor.withValues(
                      alpha: 0.65,
                    ),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                      loading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                buttonText,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
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
