import 'package:flutter/material.dart';
import 'package:odev_3/models/dizi.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';

class Grafik extends StatelessWidget {
  final double maxKategori;
  final List<VBarChartModel> grafikVerisi;

  const Grafik(
      {required this.grafikVerisi, required this.maxKategori, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceVariant
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: ikonlar.keys
                .map((e) => Icon(
                      ikonlar[e],
                      color: Colors.deepOrange,
                    ))
                .toList(),
          ),
          Expanded(
            child: VerticalBarchart(
              background: Colors.transparent,
              labelSizeFactor: 0.4,
              labelColor:
                  MediaQuery.of(context).platformBrightness != Brightness.dark
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
              maxX: maxKategori,
              data: grafikVerisi,
              showLegend: false,
            ),
          ),
        ],
      ),
    );
  }
}
