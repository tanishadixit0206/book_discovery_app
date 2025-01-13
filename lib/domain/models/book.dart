
class Book{
    final int bookId;
    final String title;
    final double price;
    final List<Author> authors; 

    Book({required this.bookId, required this.title, required this.price, required this.authors});
}

class Author{
    String name;
    int birthYear;
    int deathYear;

    Author({required this.name, required this.birthYear, required this.deathYear});
}