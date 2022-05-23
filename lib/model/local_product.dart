class Product {
  final String image, title, category;
  final double price;
  final int id;
  Product(
      {required this.id,
      required this.title,
      required this.category,
      required this.price,
      required this.image});
}

List<Product> products = [
  Product(
      id: 1,
      title: "Doritos",
      category: "Snack",
      price: 7.9,
      image: "images/Product/Doritos.png"),
  Product(
      id: 2,
      title: "Lay's",
      category: "Snack",
      price: 6.3,
      image: "images/Product/Lay's.png"),
  Product(
      id: 3,
      title: "Mars",
      category: "Snack",
      price: 4.0,
      image: "images/Product/Mars.png"),
  Product(
      id: 4,
      title: "Pringles",
      category: "Snack",
      price: 8.5,
      image: "images/Product/Pringles.png"),
  Product(
      id: 5,
      title: "Snickers",
      category: "Snack",
      price: 3.2,
      image: "images/Product/Snickers.png"),
  Product(
    id: 6,
    title: "Tic-Tac",
    category: "Snack",
    price: 1.4,
    image: "images/Product/Tic-Tac.png",
  ),
];
