import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tottho_apa_flutter/Screens/incomplete_order_screen.dart';
import 'package:tottho_apa_flutter/Screens/login_screen.dart';
import 'package:tottho_apa_flutter/Screens/new_order_screen.dart';
import 'package:tottho_apa_flutter/Screens/total_delivery_screen.dart';
import 'package:tottho_apa_flutter/Screens/total_order_screen.dart';
import 'dart:math'; // Import the math package for random number generation
import '../Api/dashBoard_service.dart';
import '../Providers/dashboard_provider.dart';
import '../Providers/user_provider.dart';
import 'all_merchant_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? name;
  Future<void> _fetchDashboardData(BuildContext context) async {
    try {
      final userToken = Provider.of<UserProvider>(context, listen: false).user.token;
      final data = await DashboardService.fetchDashboardData(userToken);

      Provider.of<DashboardProvider>(context, listen: false).updateDashboardData(data);
    } catch (e) {
      // Handle data fetch failure
      print('Failed to fetch dashboard data: $e');
      // Display an error message to the user
    }
  }

  Future<void> _refreshDashboardData() async {
    await _fetchDashboardData(context);
  }

  @override
  void initState() {
    super.initState();

    _fetchDashboardData(context); // Fetch dashboard data on screen load
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('লাল সবুজ'),
      ),
      drawer: Drawer(
        child: DrawerContent(),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDashboardData,
          child: Dashboard()),
    );
  }
}

class DrawerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Column(
      children: [
        Container(
          height: 180,
          width: MediaQuery.of(context).size.width,
          color: Colors.green.withOpacity(.5),
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              userProvider.user.full_name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: ListTile(

            leading: Icon(Icons.home),
            title: Text('Home'),
          ),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profile'),
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Add Merchant'),
        ),
        GestureDetector(
          onTap: (){
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllMerchantScreen())); // Navigating to AllMerchantScreen
          },
          child: ListTile(
            leading: Icon(Icons.store),
            title: Text('All Merchant'),
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewOrderScreen()));
          },
          child: ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('New Order'),
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TotalDeliveryScreen()));
          },
          child: ListTile(
            leading: Icon(Icons.delivery_dining),
            title: Text('Today Delivery'),
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TotalOrderScreen()));
          },
          child: ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Total Order'),
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IncompleteOrderScreen()));
          },
          child: ListTile(
            leading: Icon(Icons.close),
            title: Text('Incomplete Order'),
          ),
        ),
        GestureDetector(
          onTap: () async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('token', '');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ),
        ListTile(
          leading: Icon(Icons.update),
          title: Text('Update'),
        ),
      ],
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(16),
      children: [
        DashboardCard(Icons.star, 'New Order', dashboardProvider.totalPending.toString()),
        DashboardCard(Icons.person, 'Today delivery', dashboardProvider.totalShipped.toString()),
        DashboardCard(Icons.shop, 'Total Order', dashboardProvider.totalOrder.toString()),
        DashboardCard(Icons.shopping_cart, 'Total Order Cost', '৳ '+dashboardProvider.totalOrderPrice.toString()),
        DashboardCard(Icons.thumb_up, 'Incomplete Order', dashboardProvider.totalProcessing.toString()),
        DashboardCard(Icons.chat_bubble, 'Total merchant', dashboardProvider.totalMerchant.toString()),
      ],
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String count;
  DashboardCard(this.icon, this.name, this.count);

  // Generate a random color with reduced opacity
  Color _generateRandomColor() {
    final random = Random();
    final color = Colors.primaries[random.nextInt(Colors.primaries.length)].withOpacity(0.3);
    return color;
  }

  @override
  Widget build(BuildContext context) {
    final randomColor = _generateRandomColor();
    return Container(
      width: double.infinity, // Expand the container to fill the cell
      decoration: BoxDecoration(
        color: randomColor,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.all(8),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            left: 8,
            child: Text(
              name,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              'Count: $count',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Icon(icon, size: 22),
          ),
        ],
      ),
    );
  }
}
