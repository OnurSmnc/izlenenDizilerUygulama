import 'dart:io';

import 'package:odev_3/models/dizi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

final bicimlendirici = DateFormat.yMd(Platform.localeName);

class YeniDizi extends StatefulWidget {
  const YeniDizi({super.key, required this.diziEkle});

  final void Function(Dizi dizi) diziEkle;

  @override
  State<YeniDizi> createState() {
    return _YeniDiziState();
  }
}

class _YeniDiziState extends State<YeniDizi> {
  final _isimController = TextEditingController();
  double _puan = 0;
  DateTime? _secilenTarih;
  Kategori _secilenKategori = Kategori.bilimKurgu;
  final _notController = TextEditingController();

  void _tarihSeciciGoster() async {
    final bugun = DateTime.now();
    final yeniTarih = await showDatePicker(
        context: context,
        initialDate: bugun,
        firstDate: DateTime(bugun.year - 1, bugun.month, bugun.day),
        lastDate: bugun);
    setState(() {
      _secilenTarih = yeniTarih;
    });
  }

  void _diziyiKaydet() {
    if (_isimController.text.trim().isEmpty) {
      if (Platform.isIOS) {
        showCupertinoDialog(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
                  title: const Text('Hata'),
                  content: const Text('Lütfen dizi ismini girin.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        child: const Text('Kapat'))
                  ],
                ));
      } else if (Platform.isAndroid) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Hata'),
                  content: const Text('Lütfen dizi ismini girin.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        child: const Text('Kapat'))
                  ],
                ));
      }
      return;
    } else if (_puan < 1 || _puan > 5) {
      showDialog(
          context: context,
          builder: ((ctx) => AlertDialog(
                title: const Text('Hata'),
                content: const Text('Lütfen dizi puanını seçin.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('Kapat'))
                ],
              )));
      return;
    } else if (_secilenTarih == null) {
      showDialog(
          context: context,
          builder: ((ctx) => AlertDialog(
                title: const Text('Hata'),
                content: const Text('Lütfen izleme tarihini seçin.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('Kapat'))
                ],
              )));
      return;
    }

    widget.diziEkle(Dizi(
        isim: _isimController.text,
        not: _notController.text,
        puan: _puan,
        izlemeTarihi: _secilenTarih!,
        kategori: _secilenKategori));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _isimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final klavyeAlani = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 64, 16, 16 + klavyeAlani),
          child: Column(
            children: [
              if (width > 640)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        // İsim
                        maxLength: 50,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          label: Text('Dizi İsmi'),
                        ),
                        controller: _isimController,
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Text(
                      'Puan',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7), fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      allowHalfRating: true,
                      unratedColor: Colors.amber.withAlpha(50),
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        _puan = rating;
                      },
                    ),
                  ],
                )
              else
                TextField(
                  // İsim
                  maxLength: 50,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: Text('Dizi İsmi'),
                  ),
                  controller: _isimController,
                ),
              const SizedBox(
                height: 20,
              ),
              if (width > 640)
                Row(
                  children: [
                    Text(
                      'İzleme Tarihi',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7), fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: _tarihSeciciGoster,
                        icon: const Icon(Icons.date_range)),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      _secilenTarih == null
                          ? ''
                          : bicimlendirici.format(_secilenTarih!),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Text(
                      'Kategori',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7), fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    DropdownButton(
                        value: _secilenKategori,
                        items: Kategori.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _secilenKategori = value);
                        }),
                  ],
                )
              else
                Row(
                  // Puan
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Puan',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7), fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      allowHalfRating: true,
                      unratedColor: Colors.amber.withAlpha(50),
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        _puan = rating;
                      },
                    ),
                  ],
                ),
              if (width <= 640)
                Row(
                  // Tarih
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'İzleme Tarihi',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7), fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: _tarihSeciciGoster,
                        icon: const Icon(Icons.date_range)),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      _secilenTarih == null
                          ? ''
                          : bicimlendirici.format(_secilenTarih!),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              if (width <= 640)
                Row(
                  // Kategoriler
                  children: [
                    Text(
                      'Kategori',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7), fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    DropdownButton(
                        value: _secilenKategori,
                        items: Kategori.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _secilenKategori = value);
                        }),
                  ],
                ),
              TextField(
                // Notlar
                maxLength: 300,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text('Notlar'),
                ),
                controller: _notController,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                // Butonlar
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _diziyiKaydet,
                    child: const Text('Kaydet'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.redAccent)),
                    child: const Text('İptal'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
