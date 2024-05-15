import 'package:odev_3/models/dizi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DiziOgesi extends StatelessWidget {
  const DiziOgesi(this.dizi, {super.key});

  final Dizi dizi;

  @override
  Widget build(context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  dizi.isim,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Spacer(),
                if (dizi.isFavorite) Icon(Icons.favorite),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                RatingBarIndicator(
                  rating: dizi.puan,
                  itemSize: 24,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star_rounded,
                    color: Colors.deepOrange,
                  ),
                  unratedColor: Colors.deepOrange.withAlpha(50),
                ),
                const Spacer(),
                Icon(
                  ikonlar[dizi.kategori],
                  color: Colors.blueGrey,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(dizi.bicimliTarih),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                dizi.not.isEmpty
                    ? const SizedBox(
                        height: 0.1,
                      )
                    : Text('Not: ${dizi.not}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
