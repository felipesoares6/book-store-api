class Api::V1::BooksController < ApplicationController
  MAX_PAGINATION_LIMIT = 100

  def index
    @books = Book.limit(limit).offset(params[:offset])

    render json: BooksPresenter.new(@books).as_json
  end

  def show
    @book = Book.find(params[:id])

    render json: BookPresenter.new(@book).as_json, status: :ok
  end

  def create
    @author = Author.create!(author_params)
    @book = Book.new(book_params.merge(author_id: @author.id))

    if @book.save
      render json: BookPresenter.new(@book).as_json, status: :created
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def update
    @book = Book.find(params[:id])

    if @book.update(book_params)
      render json: @book, status: :ok
    else
      render json: @book.errors, status: :bad_request
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy!

    head :no_content
  end

  private

  def limit
    [
      params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i,
      MAX_PAGINATION_LIMIT
    ].min
  end

  def book_params
    params.require(:book).permit(:title)
  end

  def author_params
    params.require(:author).permit(:first_name, :last_name, :age)
  end
end
