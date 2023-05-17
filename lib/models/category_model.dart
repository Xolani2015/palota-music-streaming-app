import 'package:flutter/widgets.dart';

class CategoryModel {
  String? href;
  List<CategoryIcons>? icons;
  String? name;
  String? type;
  String? id;
  Image? image;

  CategoryModel({this.href, this.icons, this.name, this.type, this.id});

  static CategoryModel invalid() =>
      CategoryModel(href: null, icons: null, id: null, name: null, type: null);

  CategoryModel.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    if (json['icons'] != null) {
      icons = <CategoryIcons>[];
      json['icons'].forEach((v) {
        icons!.add(new CategoryIcons.fromJson(v));
      });
    }
    name = json['name'];
    type = json['type'];
    id = json['id'];

    if (icons != null) {
      image = Image.network(icons![0].url!);
    } else {
      //TODO: find defaul image or something
      image = Image.network('');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    if (this.icons != null) {
      data['icons'] = this.icons!.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}

class CategoryIcons {
  Null? height;
  String? url;
  Null? width;

  CategoryIcons({this.height, this.url, this.width});

  CategoryIcons.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    url = json['url'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['url'] = this.url;
    data['width'] = this.width;
    return data;
  }
}
