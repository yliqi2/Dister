import 'package:dister/model/listing.dart';
import 'package:flutter/material.dart';

class Listingtile extends StatefulWidget {
  final Listing listing;

  const Listingtile({super.key, required this.listing});

  @override
  State<Listingtile> createState() => _ListingtileState();
}

class _ListingtileState extends State<Listingtile> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.425,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    //TODO REFERENCIA A LA TABLA USUARIOS DONDE UID SEA UID,
                    radius: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  // Limitamos el ancho del texto a 5 caracteres
                  SizedBox(
                    width: 50, // Ajusta este valor según lo que necesites
                    child: Text(
                      //TODO REFERENCIA A LA TABLA USUARIOS DONDE UID SEA UID,
                      'nombressss',
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis, // Recorta con '...'
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  widget.listing.getFormattedLikes() != '0'
                      ? Text(
                          widget.listing.getFormattedLikes(),
                          style: const TextStyle(fontSize: 12),
                        )
                      : const SizedBox(),
                  Text(
                    widget.listing.getTimeAgo(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
