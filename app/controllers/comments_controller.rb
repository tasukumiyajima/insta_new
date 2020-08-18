class CommentsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,   only: :destroy

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.micropost_id = params[:micropost_id]
    if @comment.save
      flash[:success] = "コメントが投稿されました"
      redirect_to request.referrer || root_url
    else
      flash[:danger] = "コメントの投稿に失敗しました"
      redirect_to request.referrer || root_url
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = "コメントが削除されました。"
    redirect_to request.referrer || root_url
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :micropost_id)
    end

    # 自分のコメントか、自分の投稿のコメントのみ消去できる
    # つまり他人の投稿についている他人のコメントは消去できない
    def correct_user
      @comment = Comment.find(params[:id])
      @micropost = Micropost.find(params[:micropost_id])
      redirect_to(root_url) unless current_user?(@comment.user || @micropost.user)
    end

end
