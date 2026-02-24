import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Chart data point
class YoChartData {
  final double x;
  final double y;
  final String? label;
  final Color? color;

  const YoChartData({required this.x, required this.y, this.label, this.color});
}

/// Pie chart data
class YoPieData {
  final double value;
  final String label;
  final Color? color;

  const YoPieData({required this.value, required this.label, this.color});
}

/// Line chart component
class YoLineChart extends StatelessWidget {
  final List<List<YoChartData>> dataSets;
  final List<Color>? lineColors;
  final List<String>? legends;
  final String? title;
  final bool showGrid;
  final bool showDots;
  final bool curved;
  final bool filled;
  final double? minY;
  final double? maxY;
  final double height;
  final EdgeInsetsGeometry? padding;
  final String Function(double)? formatX;
  final String Function(double)? formatY;

  const YoLineChart({
    super.key,
    required this.dataSets,
    this.lineColors,
    this.legends,
    this.title,
    this.showGrid = true,
    this.showDots = true,
    this.curved = true,
    this.filled = false,
    this.minY,
    this.maxY,
    this.height = 200,
    this.padding,
    this.formatX,
    this.formatY,
  });

  /// Simple single line chart
  factory YoLineChart.simple({
    Key? key,
    required List<YoChartData> data,
    Color? color,
    String? title,
    bool showGrid = true,
    bool curved = true,
    bool filled = false,
    double height = 200,
  }) {
    return YoLineChart(
      key: key,
      dataSets: [data],
      lineColors: color != null ? [color] : null,
      title: title,
      showGrid: showGrid,
      curved: curved,
      filled: filled,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = lineColors ??
        [
          context.primaryColor,
          context.successColor,
          context.warningColor,
          context.errorColor,
          context.infoColor,
        ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: context.yoTitleSmall.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
        ],
        if (legends != null && legends!.isNotEmpty) ...[
          _buildLegends(context, colors),
          const SizedBox(height: 12),
        ],
        SizedBox(
          height: height,
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(
                  show: showGrid,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: context.gray200, strokeWidth: 1),
                ),
                titlesData: _buildTitles(context),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: context.gray300),
                    left: BorderSide(color: context.gray300),
                  ),
                ),
                lineBarsData: dataSets.asMap().entries.map((entry) {
                  final color = colors[entry.key % colors.length];
                  return LineChartBarData(
                    spots: entry.value.map((d) => FlSpot(d.x, d.y)).toList(),
                    isCurved: curved,
                    color: color,
                    barWidth: 2.5,
                    dotData: FlDotData(show: showDots),
                    belowBarData: filled
                        ? BarAreaData(show: true, color: color.withAlpha(51))
                        : BarAreaData(show: false),
                  );
                }).toList(),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => context.gray800,
                    getTooltipItems: (spots) => spots.map((spot) {
                      return LineTooltipItem(
                        formatY?.call(spot.y) ?? spot.y.toStringAsFixed(1),
                        TextStyle(color: Colors.white, fontSize: 12),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegends(BuildContext context, List<Color> colors) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: legends!.asMap().entries.map((entry) {
        final color = colors[entry.key % colors.length];
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 12, height: 3, color: color),
            const SizedBox(width: 6),
            Text(entry.value, style: context.yoBodySmall),
          ],
        );
      }).toList(),
    );
  }

  FlTitlesData _buildTitles(BuildContext context) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 24,
          getTitlesWidget: (value, meta) => Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              formatX?.call(value) ?? value.toInt().toString(),
              style: context.yoBodySmall.copyWith(color: context.gray500),
            ),
          ),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) => Text(
            formatY?.call(value) ?? value.toInt().toString(),
            style: context.yoBodySmall.copyWith(color: context.gray500),
          ),
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}

/// Bar chart component
class YoBarChart extends StatelessWidget {
  final List<YoChartData> data;
  final Color? barColor;
  final Color? gradientFrom;
  final Color? gradientTo;
  final String? title;
  final bool showGrid;
  final bool horizontal;
  final double height;
  final double barWidth;
  final double borderRadius;
  final String Function(double)? formatX;
  final String Function(double)? formatY;

  const YoBarChart({
    super.key,
    required this.data,
    this.barColor,
    this.gradientFrom,
    this.gradientTo,
    this.title,
    this.showGrid = true,
    this.horizontal = false,
    this.height = 200,
    this.barWidth = 16,
    this.borderRadius = 4,
    this.formatX,
    this.formatY,
  });

  @override
  Widget build(BuildContext context) {
    final color = barColor ?? context.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: context.yoTitleSmall.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          height: height,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: data.map((d) => d.y).reduce((a, b) => a > b ? a : b) * 1.2,
              gridData: FlGridData(
                show: showGrid,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) =>
                    FlLine(color: context.gray200, strokeWidth: 1),
              ),
              titlesData: _buildTitles(context),
              borderData: FlBorderData(show: false),
              barGroups: data.asMap().entries.map((entry) {
                final d = entry.value;
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: d.y,
                      width: barWidth,
                      color: d.color ?? color,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(borderRadius),
                      ),
                      gradient: gradientFrom != null && gradientTo != null
                          ? LinearGradient(
                              colors: [gradientFrom!, gradientTo!],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            )
                          : null,
                    ),
                  ],
                );
              }).toList(),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => context.gray800,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final d = data[group.x];
                    return BarTooltipItem(
                      '${d.label ?? ''}\n${formatY?.call(rod.toY) ?? rod.toY.toStringAsFixed(1)}',
                      TextStyle(color: Colors.white, fontSize: 12),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  FlTitlesData _buildTitles(BuildContext context) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= data.length) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                data[index].label ?? '',
                style: context.yoBodySmall.copyWith(color: context.gray500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) => Text(
            formatY?.call(value) ?? value.toInt().toString(),
            style: context.yoBodySmall.copyWith(color: context.gray500),
          ),
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}

/// Pie/Donut chart component
class YoPieChart extends StatelessWidget {
  final List<YoPieData> data;
  final List<Color>? colors;
  final String? title;
  final String? centerText;
  final bool donut;
  final double size;
  final double donutRadius;
  final bool showLabels;
  final bool showPercentage;
  final bool showLegend;

  const YoPieChart({
    super.key,
    required this.data,
    this.colors,
    this.title,
    this.centerText,
    this.donut = false,
    this.size = 200,
    this.donutRadius = 60,
    this.showLabels = true,
    this.showPercentage = true,
    this.showLegend = true,
  });

  /// Donut chart
  factory YoPieChart.donut({
    Key? key,
    required List<YoPieData> data,
    List<Color>? colors,
    String? title,
    String? centerText,
    double size = 200,
    double donutRadius = 60,
    bool showLegend = true,
  }) {
    return YoPieChart(
      key: key,
      data: data,
      colors: colors,
      title: title,
      centerText: centerText,
      donut: true,
      size: size,
      donutRadius: donutRadius,
      showLabels: false,
      showLegend: showLegend,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chartColors = colors ??
        [
          context.primaryColor,
          context.successColor,
          context.warningColor,
          context.errorColor,
          context.infoColor,
          Colors.purple,
          Colors.teal,
          Colors.orange,
        ];

    final total = data.fold<double>(0, (sum, d) => sum + d.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: context.yoTitleSmall.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chart
            SizedBox(
              width: size,
              height: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sections: data.asMap().entries.map((entry) {
                        final d = entry.value;
                        final color = d.color ??
                            chartColors[entry.key % chartColors.length];
                        final percentage = (d.value / total * 100);
                        return PieChartSectionData(
                          value: d.value,
                          color: color,
                          radius:
                              donut ? (size / 2 - donutRadius) : size / 2 - 10,
                          title: showLabels
                              ? (showPercentage
                                  ? '${percentage.toStringAsFixed(0)}%'
                                  : d.label)
                              : '',
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          titlePositionPercentageOffset: 0.55,
                        );
                      }).toList(),
                      centerSpaceRadius: donut ? donutRadius : 0,
                      sectionsSpace: 2,
                    ),
                  ),
                  if (donut && centerText != null)
                    Text(
                      centerText!,
                      style: context.yoTitleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),

            // Legend
            if (showLegend) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.asMap().entries.map((entry) {
                    final d = entry.value;
                    final color =
                        d.color ?? chartColors[entry.key % chartColors.length];
                    final percentage = (d.value / total * 100);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(d.label, style: context.yoBodySmall),
                          ),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: context.yoBodySmall.copyWith(
                              color: context.gray500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// Spark line - mini inline chart
class YoSparkLine extends StatelessWidget {
  final List<double> data;
  final Color? color;
  final double height;
  final double width;
  final bool showDots;
  final bool filled;

  const YoSparkLine({
    super.key,
    required this.data,
    this.color,
    this.height = 40,
    this.width = 100,
    this.showDots = false,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    final lineColor = color ?? context.primaryColor;
    final spots = data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    return SizedBox(
      width: width,
      height: height,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: lineColor,
              barWidth: 2,
              dotData: FlDotData(show: showDots),
              belowBarData: filled
                  ? BarAreaData(show: true, color: lineColor.withAlpha(51))
                  : BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
