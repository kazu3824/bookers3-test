class SearchesController < ApplicationController
  def search
      method = params[:method]
       @word = params[:word]
       @model = params[:model]
      if @model == "book"
       @records = Book.search(method,@word)
      else
       @records = User.search(method,@word)
      end
  end
end
