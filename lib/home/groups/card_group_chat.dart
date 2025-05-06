import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CardGroupChat extends StatelessWidget {
  final int idnex;
  const CardGroupChat({super.key, required this.idnex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          idnex % 2 == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        idnex % 2 == 0
            ? IconButton(onPressed: () {}, icon: Icon(Iconsax.message_edit))
            : SizedBox(),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(idnex % 2 == 0 ? 16 : 0),
              topRight: Radius.circular(idnex % 2 == 0 ? 0 : 16),
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
          color:
              idnex % 2 == 0
                  ? Theme.of(context).colorScheme.onSecondary
                  : Theme.of(context).colorScheme.onPrimary,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 2,
              ),
              child: Column(
                crossAxisAlignment:
                    idnex % 2 == 0
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                children: [
                  idnex % 2 == 0
                      ? SizedBox()
                      : Text(
                        'Nour Abdullah',
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(color: Colors.amber),
                      ),
                  SizedBox(height: 5),
                  Text('Hello'),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '12:00 AM',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(width: 5),
                      idnex % 2 == 0
                          ? Icon(Iconsax.tick_circle, size: 12)
                          : SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
