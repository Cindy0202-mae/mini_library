puts "Cleaning database...."
Book.destroy_all

puts "Creating library...."
Book.create([
  { title: "1984", author: "George Orwell", genre: "Dystopian", description: "A chilling dystopian novel about totalitarianism." },
  { title: "To Kill a Mockingbird", author: "Harper Lee", genre: "Fiction", description: "A moving story of racial injustice in the Deep South." },
  { title: "The Hobbit", author: "J.R.R. Tolkien", genre: "Fantasy", description: "A fantastical adventure of Bilbo Baggins." }
])
