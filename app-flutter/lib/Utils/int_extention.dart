extension PriceParsing on int {
  String priceFormat() {
    final numberString = toString();
    RegExp regExp = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return numberString.replaceAllMapped(regExp, (match) => ',');
  }
}