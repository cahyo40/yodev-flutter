import 'package:flutter/material.dart';

/// Masonry grid layout (Pinterest-style)
class YoMasonryGrid extends StatelessWidget {
  final List<Widget> children;
  final int columns;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry? padding;

  const YoMasonryGrid({
    super.key,
    required this.children,
    this.columns = 2,
    this.spacing = 8,
    this.runSpacing = 8,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnChildren = List.generate(columns, (_) => <Widget>[]);

        for (int i = 0; i < children.length; i++) {
          final columnIndex = i % columns;
          columnChildren[columnIndex].add(children[i]);
        }

        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int colIndex = 0; colIndex < columns; colIndex++) ...[
                if (colIndex > 0) SizedBox(width: spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0;
                          i < columnChildren[colIndex].length;
                          i++) ...[
                        columnChildren[colIndex][i],
                        if (i < columnChildren[colIndex].length - 1)
                          SizedBox(height: runSpacing),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Responsive masonry grid
class YoResponsiveMasonryGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry? padding;

  const YoResponsiveMasonryGrid({
    super.key,
    required this.children,
    this.spacing = 8,
    this.runSpacing = 8,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 1200
            ? 4
            : constraints.maxWidth > 900
                ? 3
                : constraints.maxWidth > 600
                    ? 2
                    : 1;

        return YoMasonryGrid(
          columns: columns,
          spacing: spacing,
          runSpacing: runSpacing,
          padding: padding,
          children: children,
        );
      },
    );
  }
}
