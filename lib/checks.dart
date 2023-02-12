bool isInt(String value) {
  try {
    int.parse(value);
    return true;
  } catch (e) {
    return false;
  }
}
