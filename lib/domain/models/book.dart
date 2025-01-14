
class Book{
    final int bookId;
    final String title;
    final List<Author> authors; 
    final List<String> translators;
    final List<String> subjects;
    final List<String> bookshelves;
    final List<String> languages;
    final bool copyright;
    final String mediaType;
    final Map<String,String> formats;
    final int downloadCount;
    Book({
        required this.bookId,
        required this.title, 
        required this.authors,
        required this.translators,
        required this.subjects,
        required this.bookshelves,
        required this.languages,
        required this.copyright,
        required this.mediaType,
        required this.formats,
        required this.downloadCount
        });

    factory Book.fromJson(Map<String,dynamic> json){
        return Book(
            bookId: json['id']!=null?(json['id'] as int):0, 
            title: json['title'] as String, 
            authors: (json['authors'] as List<dynamic>).map((author)=> Author.fromJson(author as Map<String,dynamic>)).toList(), 
            translators: List<String>.from(json['languages'] as List),
            subjects: List<String>.from(json['subjects'] as List), 
            bookshelves: List<String>.from(json['bookshelves'] as List), 
            languages: List<String>.from(json['languages'] as List), 
            copyright: json['copyright'], 
            mediaType: json['media_type'], 
            formats: Map<String,String>.from(json['formats'] as Map), 
            downloadCount: json['download_count']!=null?(json['download_count']as int):0,
            );
    }

    Map<String,dynamic> toJson()=>{
        'id':bookId,
        'title':title,
        'authors':authors,
        'translators':translators,
        'subjects':subjects,
        'bookshelves':bookshelves,
        'languages':languages,
        'copyright':copyright,
        'media_type':mediaType,
        'formats':formats,
        'download_count':downloadCount
    };
}

class Author{
    String name;
    int birthYear;
    int deathYear;

    Author({required this.name, required this.birthYear, required this.deathYear});

    factory Author.fromJson(Map<String,dynamic> json){
        return Author(
            name:json['name'] as String,
            birthYear: json['birth_year']!=null?(json['birth_year']as int):0,
            deathYear: json['death_year']!=null?(json['death_year'] as int):0
        );
    }

    Map<String,dynamic> toJson()=>{
        'name':name,
        'birth_year':birthYear,
        'death_year':deathYear
    };
}