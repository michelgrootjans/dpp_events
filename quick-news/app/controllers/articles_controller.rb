class ArticlesController < ApplicationController
  def index
    @articles = Article.order('updated_at desc')
  end

  def show
    @article = Article.find(params[:id])
  end
end
