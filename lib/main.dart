import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() => runApp(const GoodMallApp());

class GoodMallApp extends StatelessWidget {
  const GoodMallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoodMall',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;
  final pages = const [
    HomePage(),
    SimplePage(title: '订单', text: '订单列表 / 商品款支付 / 国际运费待支付提醒'),
    WalletPage(),
    SimplePage(title: '物流', text: '中国仓入库 → 出仓 → 金边仓入库 → 支付国际运费 → 自提/配送'),
    SimplePage(title: '我的', text: '个人中心 / 地址 / 自提码 / 推广赚钱 / 商家入驻 / AI客服'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: pages[tab],
    bottomNavigationBar: NavigationBar(
      selectedIndex: tab,
      onDestinationSelected: (i) => setState(() => tab = i),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: '首页'),
        NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: '订单'),
        NavigationDestination(icon: Icon(Icons.wallet_outlined), label: '钱包'),
        NavigationDestination(icon: Icon(Icons.local_shipping_outlined), label: '物流'),
        NavigationDestination(icon: Icon(Icons.person_outline), label: '我的'),
      ],
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = true;
  String error = '';
  List<dynamic> goods = [];

  @override
  void initState() {
    super.initState();
    loadGoods();
  }

  Future<void> loadGoods() async {
    setState(() {
      loading = true;
      error = '';
    });
    try {
      final data = await ApiService.get('goods/list', {'page': '1', 'pageSize': '20'});
      setState(() {
        goods = (data['data']?['items'] ?? []) as List<dynamic>;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('GoodMall 原生内测版'),
      actions: [
        IconButton(onPressed: loadGoods, icon: const Icon(Icons.refresh)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code_scanner)),
      ],
    ),
    body: RefreshIndicator(
      onRefresh: loadGoods,
      child: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          const TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: '搜索商品 / 图片搜索 / 扫一扫',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 8,
            children: [
              Chip(label: Text('包邮')),
              Chip(label: Text('附近商家')),
              Chip(label: Text('拼单')),
              Chip(label: Text('分享赚钱')),
            ],
          ),
          if (loading) const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
          if (error.isNotEmpty) Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text('接口错误：$error'),
            ),
          ),
          if (!loading && goods.isEmpty && error.isEmpty) const Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text('暂无商品'),
            ),
          ),
          ...goods.map((g) => Card(
            child: ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: Text('${g['title'] ?? '商品'}', maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text('USD: \$${g['price_usd'] ?? g['price'] ?? '-'}'),
              trailing: const Icon(Icons.chevron_right),
            ),
          )),
        ],
      ),
    ),
  );
}

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String text = '加载中...';

  @override
  void initState() {
    super.initState();
    ApiService.get('wallet/info', {'user_key': 'app_debug_user'}).then((v) {
      setState(() => text = '钱包接口：${v['message']} 余额：${v['data']?['wallet']?['balance'] ?? '-'}');
    }).catchError((e) {
      setState(() => text = '钱包接口错误：$e');
    });
  }

  @override
  Widget build(BuildContext context) => SimplePage(title: '钱包', text: text);
}

class SimplePage extends StatelessWidget {
  final String title;
  final String text;
  const SimplePage({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(text),
        ),
      ),
    ),
  );
}
