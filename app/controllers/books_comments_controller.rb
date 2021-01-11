class BooksCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @book_comment = current_user.books_comments.new(book_comment_params)
    @book_comment.book_id = @book.id
    @book_comment.save!
  end

  def destroy
    @book = Book.find(params[:book_id])
    @book_comment = BooksComment.find(params[:id])
    @book_comment.destroy
  end

  def book_comment_params
    params.require(:books_comment).permit(:comment)
  end
end
