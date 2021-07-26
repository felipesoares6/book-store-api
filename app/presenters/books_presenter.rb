class BooksPresenter
  def initialize(books)
    @books = books
  end

  def as_json
    @books.map do |book|
      BookPresenter.new(book).as_json
    end
  end
end
