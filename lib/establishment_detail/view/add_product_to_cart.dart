import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mikhuy/theme/app_colors.dart';
import 'package:mikhuy/theme/app_theme.dart';
import 'package:models/models.dart';

class AddToCart extends StatefulWidget {
  const AddToCart(this._product, {super.key});
  final Product _product;

  @override
  State<StatefulWidget> createState() => _AddToCart();
}

class _AddToCart extends State<AddToCart> {
  int _counter = 1;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            child: Container(
              height: 5,
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.grey.shade500,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Agregar al carrito",
            style: Theme.of(context).textTheme.headline2,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget._product.name,
                style: Theme.of(context).textTheme.headline1,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grey.shade100,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (isCounterValid(_counter)) _counter--;
                          });
                        },
                        icon: Icon(
                          MdiIcons.minus,
                          color: AppColors.acadia,
                        )),
                    Text('${_counter}'),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _counter++;
                          });
                        },
                        icon: Icon(
                          MdiIcons.plus,
                          color: AppColors.acadia,
                        )),
                  ],
                ),
              )
            ],
          ),
          Text(
            'Bs ${widget._product.price}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                child: ElevatedButton(
                  key: const Key('Cancel_AddProduct_ToCar_flatButton'),
                  onPressed: () => Navigator.of(context).pop(),
                  style: AppTheme.secondaryButton,
                  child: const Text('CANCELAR'),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  key: const Key('AddProduct_ToCar_flatButton'),
                  onPressed: () {
                    
                  },
                  style: AppTheme.secondaryButton,
                  child: const Text('AGREGAR AL CARRITO'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  bool isCounterValid(int counter) {
    if (counter != 1 || counter > 1) return true;
    return false;
  }
}
