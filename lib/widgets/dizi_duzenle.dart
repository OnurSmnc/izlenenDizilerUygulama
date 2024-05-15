import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:odev_3/models/dizi.dart';

final bicimlendirici = DateFormat.yMd(Platform.localeName);

class DiziDuzenlePopup extends StatefulWidget {
  final Dizi dizi;
  final void Function(Dizi dizi) diziGuncelle;

  const DiziDuzenlePopup(
      {Key? key, required this.dizi, required this.diziGuncelle})
      : super(key: key);

  @override
  _YeniDiziPopupState createState() => _YeniDiziPopupState();
}

class _YeniDiziPopupState extends State<DiziDuzenlePopup> {
  final _isimController = TextEditingController();
  double _puan = 0;
  DateTime? _secilenTarih;
  Kategori _secilenKategori = Kategori.bilimKurgu;
  final _notController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isimController.text = widget.dizi.isim;
    _puan = widget.dizi.puan;
    _secilenTarih = widget.dizi.izlemeTarihi;
    _secilenKategori = widget.dizi.kategori;
    _notController.text = widget.dizi.not ?? '';
  }

  void _tarihSeciciGoster() async {
    final bugun = DateTime.now();
    final yeniTarih = await showDatePicker(
        context: context,
        initialDate: _secilenTarih ?? bugun,
        firstDate: DateTime(bugun.year - 1, bugun.month, bugun.day),
        lastDate: bugun);
    setState(() {
      _secilenTarih = yeniTarih;
    });
  }

  void _diziyiGuncelle() {
    final guncellenenDizi = Dizi(
      isim: _isimController.text,
      not: _notController.text,
      puan: _puan,
      izlemeTarihi: _secilenTarih ?? DateTime.now(),
      kategori: _secilenKategori,
    );
    widget.diziGuncelle(guncellenenDizi);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final klavyeAlani = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  // İsim
                  maxLength: 50,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Dizi İsmi',
                  ),
                  controller: _isimController,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Puan',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7), fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    RatingBar.builder(
                      initialRating: _puan,
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
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'İzleme Tarihi',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7), fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                        onPressed: _tarihSeciciGoster,
                        icon: const Icon(Icons.date_range)),
                    const SizedBox(width: 10),
                    Text(
                      _secilenTarih == null
                          ? ''
                          : bicimlendirici.format(_secilenTarih!),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Kategori',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7), fontSize: 16),
                    ),
                    const SizedBox(width: 10),
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
                const SizedBox(height: 20),
                TextField(
                  // Notlar
                  maxLength: 300,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Notlar',
                  ),
                  controller: _notController,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _diziyiGuncelle,
                      child: const Text('Güncelle'),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      child: const Text('İptal'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
