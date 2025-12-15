import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';

import '../services/statistics_service.dart';

enum TimeRange {
  today,
  thisMonth,
  thisYear,
  custom,
}

enum SalesChartType { byDay, byHour }

class AdminStatisticsTab extends StatefulWidget {
  const AdminStatisticsTab({super.key});

  @override
  State<AdminStatisticsTab> createState() => _AdminStatisticsTabState();
}

class _AdminStatisticsTabState extends State<AdminStatisticsTab> {
  TimeRange _selectedRange = TimeRange.thisMonth;
  DateTime? _startDate;
  DateTime? _endDate;
  late Future<List<dynamic>> _statsFuture;
  SalesChartType _selectedChart = SalesChartType.byDay;

  @override
  void initState() {
    super.initState();
    _setDateRange(TimeRange.thisMonth);
  }

  void _setDateRange(TimeRange range) {
    final now = DateTime.now();
    DateTime start;
    DateTime end = now;

    switch (range) {
      case TimeRange.today:
        start = DateTime(now.year, now.month, now.day);
        break;
      case TimeRange.thisMonth:
        start = DateTime(now.year, now.month, 1);
        break;
      case TimeRange.thisYear:
        start = DateTime(now.year, 1, 1);
        break;
      case TimeRange.custom:
        return;
    }

    setState(() {
      _selectedRange = range;
      _startDate = start;
      _endDate = end;
      _fetchData();
    });
  }

  void _fetchData() {
    if (_startDate == null || _endDate == null) return;
    final statsService = context.read<StatisticsService>();
    setState(() {
      _statsFuture = Future.wait([
        statsService.getSalesOverview(startDate: _startDate!, endDate: _endDate!),
        statsService.getBestSellers(startDate: _startDate!, endDate: _endDate!),
        statsService.getSalesByTime(startDate: _startDate!, endDate: _endDate!, groupByUnit: 'dow'),
        statsService.getSalesByTime(startDate: _startDate!, endDate: _endDate!, groupByUnit: 'hour'),
      ]);
    });
  }

  Future<void> _selectCustomDateRange(BuildContext context) async {
    final initialRange = DateTimeRange(start: _startDate ?? DateTime.now(), end: _endDate ?? DateTime.now());
    final newRange = await showDateRangePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime.now(), initialDateRange: initialRange);

    if (newRange != null) {
      setState(() {
        _selectedRange = TimeRange.custom;
        _startDate = newRange.start;
        _endDate = newRange.end;
        _fetchData();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeRangeSelector(),
            const SizedBox(height: 24),
            FutureBuilder<List<dynamic>>(
              future: _statsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.length < 4) {
                  return const Center(child: Text('Aucune donnée disponible.'));
                }

                final overview = snapshot.data![0] as SalesOverview;
                final bestSellers = snapshot.data![1] as List<BestSellerProduct>;
                final salesByDay = snapshot.data![2] as List<TimeSeriesSales>;
                final salesByHour = snapshot.data![3] as List<TimeSeriesSales>;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOverviewGrid(overview),
                    const SizedBox(height: 24),
                    _buildRevenueChart(overview),
                    const SizedBox(height: 24),
                    _buildPeakTimesChart(salesByDay, salesByHour),
                    const SizedBox(height: 24),
                    _buildBestSellersList(bestSellers),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    final selectedColor = Theme.of(context).primaryColor;
    final unselectedColor = Colors.grey.shade300;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Période', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(spacing: 8.0, runSpacing: 8.0, children: [
          ChoiceChip(label: const Text('Aujourd\'hui'), selected: _selectedRange == TimeRange.today, onSelected: (_) => _setDateRange(TimeRange.today), selectedColor: selectedColor, backgroundColor: unselectedColor, labelStyle: TextStyle(color: _selectedRange == TimeRange.today ? Colors.white : Colors.black), showCheckmark: false),
          ChoiceChip(label: const Text('Ce mois-ci'), selected: _selectedRange == TimeRange.thisMonth, onSelected: (_) => _setDateRange(TimeRange.thisMonth), selectedColor: selectedColor, backgroundColor: unselectedColor, labelStyle: TextStyle(color: _selectedRange == TimeRange.thisMonth ? Colors.white : Colors.black), showCheckmark: false),
          ChoiceChip(label: const Text('Cette année'), selected: _selectedRange == TimeRange.thisYear, onSelected: (_) => _setDateRange(TimeRange.thisYear), selectedColor: selectedColor, backgroundColor: unselectedColor, labelStyle: TextStyle(color: _selectedRange == TimeRange.thisYear ? Colors.white : Colors.black), showCheckmark: false),
          ActionChip(label: const Text('Personnalisé'), onPressed: () => _selectCustomDateRange(context), backgroundColor: _selectedRange == TimeRange.custom ? selectedColor : unselectedColor, labelStyle: TextStyle(color: _selectedRange == TimeRange.custom ? Colors.white : Colors.black)),
        ]),
      ],
    );
  }

  Widget _buildOverviewGrid(SalesOverview overview) {
    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (_startDate != null && _endDate != null) Padding(padding: const EdgeInsets.only(bottom: 16.0), child: Text('Du ${DateFormat.yMMMd('fr_FR').format(_startDate!)} au ${DateFormat.yMMMd('fr_FR').format(_endDate!)}', style: const TextStyle(fontSize: 16, color: Colors.grey))),
      GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.5, children: [
        _StatCard(title: 'C.A.', value: currencyFormat.format(overview.totalRevenue), icon: Icons.euro_symbol, color: Colors.green),
        _StatCard(title: 'Commandes', value: overview.totalOrdersCount.toString(), icon: Icons.receipt_long, color: Colors.blue),
        _StatCard(title: 'Panier moyen', value: currencyFormat.format(overview.averageCartValue), icon: Icons.shopping_cart, color: Colors.orange),
        _StatCard(title: 'Pizzas vendues', value: overview.totalPizzasSold.toString(), icon: Icons.local_pizza, color: Colors.orange.shade700),
        _StatCard(title: 'P.M. Pizza', value: currencyFormat.format(overview.averagePizzaPrice), icon: Icons.price_check, color: Colors.purple),
      ]),
    ]);
  }

  Widget _buildRevenueChart(SalesOverview overview) {
    final totalRevenue = overview.revenueFromPizzas + overview.revenueFromDrinks;
    if (totalRevenue == 0) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Répartition du C.A.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      SizedBox(height: 200, child: PieChart(PieChartData(sections: [
        PieChartSectionData(color: Colors.orange.shade400, value: overview.revenueFromPizzas, title: '${(overview.revenueFromPizzas / totalRevenue * 100).toStringAsFixed(1)}%\nPizzas', radius: 80, titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        PieChartSectionData(color: Colors.blue.shade400, value: overview.revenueFromDrinks, title: '${(overview.revenueFromDrinks / totalRevenue * 100).toStringAsFixed(1)}%\nBoissons', radius: 80, titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))
      ], sectionsSpace: 2, centerSpaceRadius: 40))),
    ]);
  }
  
  Widget _buildPeakTimesChart(List<TimeSeriesSales> salesByDay, List<TimeSeriesSales> salesByHour) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pics d\'activité', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SegmentedButton<SalesChartType>(
          style: SegmentedButton.styleFrom(
            foregroundColor: Colors.blueGrey.shade200,
            selectedForegroundColor: Colors.white,
            selectedBackgroundColor: Colors.blueGrey,
          ),
          segments: const <ButtonSegment<SalesChartType>>[
            ButtonSegment(value: SalesChartType.byDay, label: Text('Par jour'), icon: Icon(Icons.calendar_view_day)),
            ButtonSegment(value: SalesChartType.byHour, label: Text('Par heure'), icon: Icon(Icons.access_time)),
          ],
          selected: {_selectedChart},
          onSelectionChanged: (Set<SalesChartType> newSelection) {
            setState(() {
              _selectedChart = newSelection.first;
            });
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barGroups: _selectedChart == SalesChartType.byDay ? _buildBars(salesByDay, 7) : _buildBars(salesByHour, 24),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: _getBottomTitles, reservedSize: 38)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildBars(List<TimeSeriesSales> data, int count) {
    final Map<int, double> dataMap = {for (var item in data) item.timeUnit: item.totalRevenue};
    return List.generate(count, (i) {
      final unit = _selectedChart == SalesChartType.byDay ? i + 1 : i;
      return BarChartGroupData(
        x: unit,
        barRods: [BarChartRodData(toY: dataMap[unit] ?? 0, color: Colors.blueGrey, width: 16)],
      );
    });
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    String text;
    if (_selectedChart == SalesChartType.byDay) {
      const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
      text = days.elementAtOrNull(value.toInt() - 1) ?? '';
    } else {
      text = '${value.toInt()}h';
    }
    return SideTitleWidget(axisSide: meta.axisSide, space: 4, child: Text(text, style: const TextStyle(fontSize: 10)));
  }

  Widget _buildBestSellersList(List<BestSellerProduct> bestSellers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Meilleures Ventes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (bestSellers.isEmpty)
          const Text('Aucune vente enregistrée sur cette période.')
        else
          ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: bestSellers.length, itemBuilder: (context, index) {
            final product = bestSellers[index];
            return Card(margin: const EdgeInsets.only(bottom: 8.0), child: ListTile(leading: CircleAvatar(backgroundImage: (product.image != null && product.image!.isNotEmpty) ? CachedNetworkImageProvider(product.image!) : null, child: (product.image == null || product.image!.isEmpty) ? const Icon(Icons.fastfood) : null), title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)), trailing: Text('Vendu: ${product.totalSold}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey))));
          }),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(elevation: 2.0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)), Icon(icon, color: color.withOpacity(0.7))]), FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold), maxLines: 1))])));
  }
}
