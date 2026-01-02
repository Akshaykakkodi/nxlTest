class EditProductParams {
  final String? title;
  final String? price;
  final String? description;

  EditProductParams(this.title, this.price, this.description);

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "price": price,
      "description": description,
    };
  }
}
