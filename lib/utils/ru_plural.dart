String ruPlural(int n, String one, String few, String many) {
  final nAbs = n.abs();
  final mod10 = nAbs % 10;
  final mod100 = nAbs % 100;
  if (mod100 >= 11 && mod100 <= 14) return many;
  if (mod10 == 1) return one;
  if (mod10 >= 2 && mod10 <= 4) return few;
  return many;
}

String formatCount(int n, String one, String few, String many) {
  return '$n ${ruPlural(n, one, few, many)}';
}