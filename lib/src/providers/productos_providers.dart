import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:turnosapp/src/models/producto_model.dart';

class ProductosProvider {
  final String _url = 'https://flutter-varios-422b6.firebaseio.com';

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json';

    final resp =
        await http.post(Uri.parse(url), body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json';

    final resp =
        await http.put(Uri.parse(url), body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json';
    final resp = await http.get(Uri.parse(url));

    final Map<String, dynamic>? decodedData = json.decode(resp.body);
    final productos = <ProductoModel>[];

    if (decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;

      productos.add(prodTemp);
    });

    //print(productos[0].id);

    return productos;
  }

  Future<int> borrarProduto(String id) async {
    final url = '$_url/productos/$id.json';
    final resp = await http.delete(Uri.parse(url));

    print(resp.body);

    return 1;
  }
}
