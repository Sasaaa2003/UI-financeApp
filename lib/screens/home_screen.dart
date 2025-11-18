import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../widgets/atm_card.dart';
import '../models/transaction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactions = [
      TransactionModel('Coffee Shop', '-Rp35.000', 'Food'),
      TransactionModel('Grab Ride', '-Rp25.000', 'Travel'),
      TransactionModel('Gym Membership', '-Rp150.000', 'Health'),
      TransactionModel('Movie Ticket', '-Rp60.000', 'Event'),
      TransactionModel('Salary', '+Rp5.000.000', 'Income'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text(
          'Finance Mate',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1668C7),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Gretting Professional =====
            const Text(
              'Hello, Loppy',
              style: TextStyle(
                fontSize: 22,
                color: Color(0xFF1E2A39),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Track your financial activity',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 24),

            // ====== Professional Cards ======
            SizedBox(
              height: 220,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                itemCount: 4,
                itemBuilder: (context, index) {
                  double scale = (index == _currentPage.round()) ? 1.0 : 0.93;

                  return TweenAnimationBuilder(
                    tween: Tween(begin: scale, end: scale),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: index == _currentPage.round() ? 1 : 0.55,
                          child: child,
                        ),
                      );
                    },
                    child: _buildCard(index),
                  );
                },
              ),
            ),

            const SizedBox(height: 28),

            // ====== Menu (Professional Blue) ======
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SmallAnimatedButton(
                  icon: Icons.health_and_safety,
                  label: 'Health',
                ),
                SmallAnimatedButton(
                  icon: Icons.travel_explore,
                  label: 'Travel',
                ),
                SmallAnimatedButton(
                  icon: Icons.fastfood,
                  label: 'Food',
                ),
                SmallAnimatedButton(
                  icon: Icons.event,
                  label: 'Event',
                ),
              ],
            ),

            const SizedBox(height: 32),

            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E2A39),
              ),
            ),
            const SizedBox(height: 10),

            AnimationLimiter(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final tx = transactions[index];

                  IconData icon;
                  Color iconColor;
                  int spendingLevel = 0;

                  switch (tx.category) {
                    case 'Food':
                      icon = Icons.fastfood_rounded;
                      iconColor = Colors.blue.shade400;
                      spendingLevel = 2;
                      break;
                    case 'Travel':
                      icon = Icons.travel_explore_rounded;
                      iconColor = Colors.indigo.shade400;
                      spendingLevel = 3;
                      break;
                    case 'Health':
                      icon = Icons.health_and_safety_rounded;
                      iconColor = Colors.cyan.shade600;
                      spendingLevel = 1;
                      break;
                    case 'Event':
                      icon = Icons.event_rounded;
                      iconColor = Colors.blueGrey.shade400;
                      spendingLevel = 2;
                      break;
                    default:
                      icon = Icons.attach_money_rounded;
                      iconColor = Colors.green.shade400;
                      spendingLevel = 0;
                  }

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 450),
                    child: SlideAnimation(
                      verticalOffset: 32,
                      child: FadeInAnimation(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Card(
                            color: Colors.white,
                            elevation: 1.5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 22,
                                backgroundColor: iconColor.withOpacity(0.15),
                                child: Icon(icon, color: iconColor, size: 22),
                              ),
                              title: Text(
                                tx.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    tx.category,
                                    style: const TextStyle(
                                      color: Colors.black45,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Row(
                                    children: List.generate(
                                      3,
                                      (i) => Icon(
                                        Icons.star_rounded,
                                        size: 14,
                                        color: i < spendingLevel
                                            ? Colors.amber.shade600
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                tx.amount,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: tx.amount.startsWith('-')
                                      ? Colors.red.shade400
                                      : Colors.green.shade600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====== PROFESSIONAL BLUE ATM CARDS ======
  Widget _buildCard(int index) {
    switch (index) {
      case 0:
        return const AtmCard(
          bankName: 'Main Account',
          cardNumber: '**** 2345',
          balance: 'Rp12.500.000',
          color1: Color(0xFF1E88E5),
          color2: Color(0xFF1565C0),
        );
      case 1:
        return const AtmCard(
          bankName: 'Savings Account',
          cardNumber: '**** 8765',
          balance: 'Rp5.350.000',
          color1: Color(0xFF42A5F5),
          color2: Color(0xFF1976D2),
        );
      case 2:
        return const AtmCard(
          bankName: 'Business Account',
          cardNumber: '**** 9988',
          balance: 'Rp25.200.000',
          color1: Color(0xFF64B5F6),
          color2: Color(0xFF1E88E5),
        );
      case 3:
        return const AtmCard(
          bankName: 'Backup Account',
          cardNumber: '**** 4433',
          balance: 'Rp3.000.000',
          color1: Color(0xFF90CAF9),
          color2: Color(0xFF42A5F5),
        );
      default:
        return const SizedBox();
    }
  }
}

// ====== PROFESSIONAL BUTTON ======
class SmallAnimatedButton extends StatefulWidget {
  final IconData icon;
  final String label;

  const SmallAnimatedButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  State<SmallAnimatedButton> createState() => _SmallAnimatedButtonState();
}

class _SmallAnimatedButtonState extends State<SmallAnimatedButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) => setState(() => _scale = 0.9);
  void _onTapUp(TapUpDetails details) => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: () => setState(() => _scale = 1.0),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xFF1E88E5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: const Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: Colors.white, size: 24),
                const SizedBox(height: 6),
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
