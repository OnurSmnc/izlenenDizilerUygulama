import 'package:odev_3/models/dizi.dart';
import 'package:odev_3/widgets/dizi_listesi/dizi_ogesi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:odev_3/widgets/dizilerim.dart';
import 'package:odev_3/widgets/dizi_duzenle.dart';

class DiziListesi extends StatelessWidget {
  const DiziListesi(
      {Key? key,
      required this.diziler,
      required this.diziSil,
      required this.favoriEkle,
      required this.favoriCikar})
      : artan = false,
        kriter = SiralamaKriteri.isim;
  DiziListesi.sirala(
      {Key? key,
      required this.diziler,
      required this.diziSil,
      required this.favoriEkle,
      required this.favoriCikar,
      required this.kriter,
      this.artan = true})
      : super(key: key) {
    sirala(kriter, artan);
  }

  final List<Dizi> diziler;
  final SiralamaKriteri kriter;
  final bool artan;

  final void Function(Dizi dizi) diziSil;
  final void Function(Dizi dizi) favoriEkle;
  final void Function(Dizi dizi) favoriCikar;

  void _modalGoster(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: double.infinity),
        isScrollControlled: true,
        builder: (context) => DiziDuzenlePopup(
              dizi: diziler[index],
              diziGuncelle: (guncellenenDizi) {
                diziler[index] = guncellenenDizi;
              },
            ),
        useSafeArea: true);
  }

  void favoriEkleCikar(BuildContext context, int index) {
    if (!diziler[index].isFavorite) {
      diziler[index].isFavorite = true;
    } else {
      diziler[index].isFavorite = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return diziler.isEmpty
        ? const Center(
            child: Text(
              'Henüz Dizi Eklemediniz',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          )
        : ListView.builder(
            itemCount: diziler.length,
            itemBuilder: (context, index) => Slidable(
              key: ValueKey(index),
              startActionPane: ActionPane(
                motion: ScrollMotion(),
                dismissible: DismissiblePane(onDismissed: () {}),
                children: [
                  SlidableAction(
                    onPressed: (context) => {diziSil(diziler[index])},
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Sil',
                  ),
                  SlidableAction(
                    onPressed: (context) => _modalGoster(context, index),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    icon: Icons.update,
                    label: 'Güncelle',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                dismissible: DismissiblePane(
                  onDismissed: () {},
                ),
                children: [
                  SlidableAction(
                    onPressed: (context) => {favoriEkle(diziler[index])},
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    icon: Icons.favorite,
                    label: 'Favorilere Ekle',
                  ),
                  SlidableAction(
                    onPressed: (context) => {favoriCikar(diziler[index])},
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.cancel,
                    label: 'Favorilerden Çıkar',
                  ),
                ],
              ),
              child: DiziOgesi(diziler[index]),
            ),
          );
  }

  void sirala(SiralamaKriteri kriter, bool artan) {
    switch (kriter) {
      case SiralamaKriteri.isim:
        diziler.sort((a, b) => a.isim.compareTo(b.isim));
        break; // Dikkat: Her case'in sonunda break eklemek önemlidir.
      case SiralamaKriteri.kategori:
        diziler.sort(
            (a, b) => a.kategori.toString().compareTo(b.kategori.toString()));
        break;
      case SiralamaKriteri.puan:
        diziler.sort((a, b) => a.puan.compareTo(b.puan));
        break;
      case SiralamaKriteri.tarih:
        diziler.sort((a, b) => a.izlemeTarihi.compareTo(b.izlemeTarihi));
        break;
    }
    if (!artan) {
      for (int i = 0; i < diziler.length / 2; i++) {
        Dizi tmp = diziler[i];
        diziler[i] = diziler[diziler.length - 1 - i];
        diziler[diziler.length - 1 - i] = tmp;
      }
    }
    List<Dizi> favoriDiziler = [];
    List<Dizi> favoriOlmayanDiziler = [];

    for (var dizi in diziler) {
      if (dizi.isFavorite) {
        favoriDiziler.add(dizi);
      } else {
        favoriOlmayanDiziler.add(dizi);
      }
    }
    diziler.clear();
    diziler.addAll(favoriDiziler);
    diziler.addAll(favoriOlmayanDiziler);
  }
}
