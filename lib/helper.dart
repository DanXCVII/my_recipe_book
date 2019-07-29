String cutDouble(double number) {
    if (number == number.floor().toDouble()) {
      return number.toStringAsFixed(0);
    }
    return number.toStringAsFixed(2);
  }