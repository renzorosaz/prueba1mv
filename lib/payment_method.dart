class PaymentMethod {
  String? id;
  bool? selected;
  String? label;
  String? type;

  PaymentMethod(
    this.selected,
    this.id,
    this.label,
    this.type,
  );
}
