class SearchesController < ApplicationController
  def search
      method = params[:search_method]
       @word = params[:search_word]
       @model = params[:search_model]
      if @model == "book"
       @books = Book.search(method,@word)
      else
       @users = User.search(method,@word)
      end
  end
end
