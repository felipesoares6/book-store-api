require 'rails_helper'

describe 'Books API', type: :request do
  describe 'GET /books' do
    it 'should return all books' do
      get '/api/v1/books'

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(Book.count)
    end
  end

  describe 'POST /books' do
    it 'should create a new book' do
      expect {
        post '/api/v1/books', params: {
          book: { title: 'The Martian' },
          author: { first_name: 'Andy', last_name: 'Weir', age: 48 }
        }
      }.to change { Book.count and Author.count }.by(+1)

      expect(response).to have_http_status(:created)
    end
  end

  describe 'DELETE /books/:id' do
    it 'should delete the specified book' do
      book = FactoryBot.create(:book)

      expect {
        delete "/api/v1/books/#{book.id}"
      }.to change { Book.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
