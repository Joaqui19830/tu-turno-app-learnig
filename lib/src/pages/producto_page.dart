//import 'dart:html';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:turnosapp/src/models/producto_model.dart';
import 'package:turnosapp/src/providers/productos_providers.dart';
import 'package:turnosapp/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final productoProvider = new ProductosProvider();

  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  File? foto;

  @override
  Widget build(BuildContext context) {
    // final ProductoModel prodData  = ModalRoute.of(context)!.settings.arguments;

    final ProductoModel prodData =
        ModalRoute.of(context)!.settings.arguments as ProductoModel;

    producto = prodData;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            onPressed: () {
              _seleccionarFoto(ImageSource.gallery);
            },
            icon: Icon(Icons.photo_size_select_actual),
          ),
          /*
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: 
          ),
           IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ), */
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(),
                // _snackbar(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => producto.titulo = value!,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (value) => producto.valor = double.parse(value!),
      validator: (value) {
        if (utils.isNumeric(value!)) {
          return null;
        } else {
          return 'Solo numeros';
        }
      },
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.blue,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          textStyle: MaterialStateProperty.all<TextStyle>(
            TextStyle(color: Colors.white),
          )),
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit() {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();

    setState(() {
      _guardando = true;
    });

    if (producto.id == null) {
      productoProvider.crearProducto(producto);
    } else {
      productoProvider.editarProducto(producto);
    }
    /* setState(() {
      _guardando = false;
    }); */
    mostrarSnackbar('Registro Guardado');

    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
        content: Text(mensaje), duration: Duration(milliseconds: 1500));

    scaffoldKey.currentState!.showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      //TODO: tengo que hacer esto
      return Container();
    } else {
      return foto == null
          ? Image(
              image: AssetImage('assets/no-image.png'),
              height: 300.0,
              fit: BoxFit.cover,
            )
          : Image.file(
              foto!,
              height: 300.0,
              fit: BoxFit.cover,
            );
    }
  }

  _seleccionarFoto(ImageSource origin) async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
      source: origin,
    );
    if (pickedFile != null) {
      foto = File(pickedFile.path);
      //producto.fotoUrl == null;
    }

    if (foto != null) {
      setState(() {});

      // _seleccionarFoto() async {

      //
      /*  foto = await ImagePicker.pickImage(
      source: ImageSource.gallery
    );

    if (foto != null) {
      //limpieza

    }

    setState(() {}); */
    }
  }
}
