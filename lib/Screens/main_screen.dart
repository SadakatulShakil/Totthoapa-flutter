import 'dart:math'; // Import the math package for random number generation

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tottho_apa_flutter/Screens/add_merchant_screen.dart';
import 'package:tottho_apa_flutter/Screens/incomplete_order_screen.dart';
import 'package:tottho_apa_flutter/Screens/login_screen.dart';
import 'package:tottho_apa_flutter/Screens/new_order_screen.dart';
import 'package:tottho_apa_flutter/Screens/profile_screen.dart';
import 'package:tottho_apa_flutter/Screens/total_delivery_screen.dart';
import 'package:tottho_apa_flutter/Screens/total_order_screen.dart';
import 'package:upgrader/upgrader.dart';

import '../Api/dashBoard_service.dart';
import '../Models/add_merchant_model.dart';
import '../Providers/dashboard_provider.dart';
import '../Providers/user_provider.dart';
import '../Widgets/connectivity_dialog.dart';
import 'all_merchant_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<void> _initFuture;
  var isConnected = false;
  merchantDataModel userData = merchantDataModel.nullConstructor();
  Future<void> _fetchDashboardData(BuildContext context) async {
    try {
      final userToken = Provider.of<UserProvider>(context, listen: false).user.token;
      print("token:=-----> "+ userToken.toString());
      final data = await DashboardService.fetchDashboardData(userToken);
      print("dataStates:=-----> "+ data.toString());
      Provider.of<DashboardProvider>(context, listen: false).updateDashboardData(data);
    } catch (e) {
      // Handle data fetch failure
      print('Failed to fetch dashboard data: $e');
      Get.snackbar(
        "Warning!",
        "Authentication failed. Your session has expired",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', '');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      // Display an error message to the user
    }
  }

  Future<void> _refreshDashboardData() async {
    var result = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = (result != ConnectivityResult.none);
    });
    if(!isConnected){
      showDialog(
        context: context,
        builder: (context) => ConnectivityDialog(),
      );
    }else{
      _fetchDashboardData(context); // Fetch dashboard data on screen load
    }
  }

  Future<void> checkConnectivity() async {

  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      _fetchDashboardData(context);
    });

  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print("name_context: "+ userProvider.user.full_name.toString());
    return UpgradeAlert(
      upgrader: Upgrader(
          canDismissDialog: false,
          showIgnore: false,
          showLater: false
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('appbar_dashboard'.tr),
        ),
        drawer: Drawer(
          child: DrawerContent(userData),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshDashboardData,
            child: Dashboard()),
      ),
    );
  }
}

class DrawerContent extends StatelessWidget {
  merchantDataModel userData;
  DrawerContent(this.userData);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print("name: "+ userProvider.user.full_name.toString());
    return Column(
      children: [
        Stack(
          children: [
            // Image
            Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/laalsobuj_t_apa.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            // Green Shadow
            Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              color: Colors.green.withOpacity(0.8), // Semi-transparent green color
            ),
            // Text
            Positioned(
              left: 0,
              right: 0,
              top: 20,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    userProvider.user.full_name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: ListTile(

            leading: Icon(Icons.home),
            title: Text('drawer_one'.tr),
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()));
          },
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('drawer_two'.tr),
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMerchant('add', userData)));
          },
          child: ListTile(
            leading: Icon(Icons.add),
            title: Text('drawer_three'.tr),
          ),
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
            title: Text('drawer_four'.tr),
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
            title: Text('new_order'.tr),
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
            title: Text('today_delivery'.tr),
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
            title: Text('total_order'.tr),
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
            title: Text('incomplete_order'.tr),
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
            title: Text('logout'.tr),
          ),
        ),
        GestureDetector(
          onTap: (){
            //Provider.of<LanguageProvider>(context, listen: false).toggleLanguage(context);
          },
          child: ListTile(
            leading: Icon(Icons.language),
            title: Text('switch_to_english'.tr),
          ),
        ),
      ],
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    return Stack(
      children: [
        // Background Image
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0, right: 15),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/beck_logo.png'), // Replace with your image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // White Shading
        Container(
          color: Colors.white.withOpacity(0.85), // Adjust opacity as needed
        ),

        // Content
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 50),
          children: [
            DashboardCard(Icons.star, 'new_order'.tr, dashboardProvider.totalPending.toString()),
            DashboardCard(Icons.delivery_dining, 'today_delivery'.tr, dashboardProvider.totalShipped.toString()),
            DashboardCard(Icons.shop, 'total_order'.tr, dashboardProvider.totalOrder.toString()),
            DashboardCard(Icons.price_change, 'total_order_cost'.tr, '৳ '+dashboardProvider.totalOrderPrice.toString()),
            DashboardCard(Icons.cancel, 'incomplete_order'.tr, dashboardProvider.totalProcessing.toString()),
            DashboardCard(Icons.people, 'total_merchant'.tr, dashboardProvider.totalMerchant.toString()),
          ],
        ),
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
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              'Count: $count',
              style: TextStyle(fontSize: 14),
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
