import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/mock_data/mock_data.dart';
import '../../../core/models/app_models.dart';
import '../../../core/widgets/worker_card.dart';
import 'customer_sequence_view.dart';
import 'worker_search_screen.dart';
import 'worker_list_screen.dart';
import 'worker_profile_screen.dart';
import 'customer_bookings_screen.dart';
import 'customer_booking_details_screen.dart';
import 'customer_notifications_screen.dart';
import 'customer_profile_screen.dart';
import 'customer_settings_screen.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({super.key});

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const _CustomerHomeDashboardTab(),
      const WorkerListScreen(),
      const CustomerBookingsScreen(),
      const _CustomerEscrowWalletTab(),
      const CustomerProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: AppColors.customerBrand),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.engineering_outlined),
            selectedIcon: Icon(Icons.engineering_rounded, color: AppColors.customerBrand),
            label: "Find Workers",
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded, color: AppColors.customerBrand),
            label: "Bookings",
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet_rounded, color: AppColors.customerBrand),
            label: "Escrow",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.customerBrand),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

// ---------------- TAB 1: RICH HOME DASHBOARD ----------------
class _CustomerHomeDashboardTab extends StatelessWidget {
  const _CustomerHomeDashboardTab();

  @override
  Widget build(BuildContext context) {
    final upcomingBooking = MockData.sampleBookings.firstWhere((b) => b.status == JobStatus.booked);
    final nearbyWorkers = MockData.sampleWorkers;
    final availableToday = MockData.sampleWorkers.where((w) => w.isAvailableToday).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.customerBrand,
              child: Text("DS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello, David 👋", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("742 Evergreen Terrace", style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, size: 24),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: const Text("2", style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CustomerNotificationsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CustomerSettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          // 1. Search Bar Action Trigger
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WorkerSearchScreen()),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search_rounded, color: AppColors.customerBrand, size: 22),
                    SizedBox(width: 12),
                    Text(
                      "What service do you need?",
                      style: TextStyle(
                        fontSize: 14.5,
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.tune_rounded, size: 18, color: AppColors.textTertiary),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // 2. Upcoming Booking Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "UPCOMING TRADE APPOINTMENT",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Text("Tomorrow", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    upcomingBooking.serviceTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        child: Text(
                          upcomingBooking.worker.avatarInitials,
                          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${upcomingBooking.worker.name} • ${upcomingBooking.timeSlot}",
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CustomerBookingDetailsScreen(booking: upcomingBooking),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white60),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text("View Booking"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CustomerSequenceView(project: MockData.sampleProjects[0]),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.textPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text("Sequence View"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 3. Quick Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.timeline_rounded,
                    title: "Sequence Builder",
                    color: AppColors.customerBrand,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CustomerSequenceView(project: MockData.sampleProjects[0]),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.shield_rounded,
                    title: "Escrow Wallet",
                    color: AppColors.workerBrand,
                    onTap: () {
                      // Navigate to escrow tab
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.history_rounded,
                    title: "All Bookings",
                    color: AppColors.accentDark,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CustomerBookingsScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. Service Categories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Service Categories",
                  style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WorkerListScreen()),
                    );
                  },
                  child: const Text("View All"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: MockData.categories.length,
              itemBuilder: (context, index) {
                final cat = MockData.categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WorkerListScreen(selectedCategoryId: cat.id),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 78,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: cat.color.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(cat.icon, color: cat.color, size: 22),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat.name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // 5. Available Today Workers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Available Today",
                      style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.successBg, borderRadius: BorderRadius.circular(4)),
                      child: const Text("Ready to Dispatch", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success)),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WorkerListScreen()),
                    );
                  },
                  child: const Text("See More"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          SizedBox(
            height: 148,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: availableToday.length,
              itemBuilder: (context, index) {
                final worker = availableToday[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: WorkerCard(
                    worker: worker,
                    compact: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => WorkerProfileScreen(worker: worker)),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // 6. Nearby & Recommended Tradespeople
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Top Rated & Recommended",
                  style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WorkerListScreen()),
                    );
                  },
                  child: const Text("View All"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: nearbyWorkers.take(4).map((worker) {
                return WorkerCard(
                  worker: worker,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => WorkerProfileScreen(worker: worker)),
                    );
                  },
                  onBookNow: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => WorkerProfileScreen(worker: worker)),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  static Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- TAB 4: ESCROW WALLET ----------------
class _CustomerEscrowWalletTab extends StatelessWidget {
  const _CustomerEscrowWalletTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Escrow & Milestone Wallet"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Funds Held in Protected Escrow", style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 6),
                Text(
                  "\$1,850.00",
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 14),
                Text(
                  "Escrow Guarantee: Funds are released only after contractor finishes milestone checklist and photo proof is approved.",
                  style: TextStyle(color: Colors.white60, fontSize: 11.5, height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            "Milestone Escrow Status",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _buildMilestoneRow("Site Demolition", "Marcus Vance", "\$650.00", "Released to Worker", AppColors.success, AppColors.successBg),
          _buildMilestoneRow("Rough Plumbing", "Rohan Patel", "\$1,200.00", "Locked in Escrow (Active Job)", AppColors.info, AppColors.infoBg),
          _buildMilestoneRow("Electrical Rough-in", "Pending Booking", "\$950.00", "Awaiting Worker Booking", AppColors.accentDark, AppColors.accentLight),
          _buildMilestoneRow("Drywall & Taping", "Sequence Step 4", "\$800.00", "Locked (Upstream Dependency)", AppColors.textTertiary, const Color(0xFFF1F5F9)),
        ],
      ),
    );
  }

  static Widget _buildMilestoneRow(String title, String worker, String amount, String status, Color fg, Color bg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text("Assigned: $worker", style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
                  child: Text(status, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: fg)),
                ),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
