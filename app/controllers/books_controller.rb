require 'net/http'
require 'json'

class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books or /books.json
  def index
    if params[:query].present?
      query = "%#{params[:query]}%"
      @books = Book.where("LOWER(title) LIKE LOWER(?) OR LOWER(author) LIKE LOWER(?) OR LOWER(genre) LIKE LOWER(?)",
                          query, query, query)
    else
      @books = Book.all
    end
  end

  # GET /books/1 or /books/1.json
  def show
    @google_book = fetch_book_details(@book.title)
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, alert: 'Failed to create a book.', status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to books_path, status: :see_other, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def fetch_book_details(query)
    base_url = "https://www.googleapis.com/books/v1/volumes"
    api_key = ENV['GOOGLE_BOOKS_API_KEY']
    url = "#{base_url}?q=#{URI.encode_www_form_component(query)}&key=#{api_key}"

    response = Net::HTTP.get(URI(url))
    json_response = JSON.parse(response)

    json_response["items"]&.first&.dig("volumeInfo")  # Return the first book's info (if any)
  rescue => e
    Rails.logger.error("Error fetching book data from Google API: #{e.message}")
    nil
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :author, :genre, :description)
    end
end
