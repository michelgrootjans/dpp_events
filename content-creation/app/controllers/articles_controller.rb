class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    @drafts = Article.where(status: :draft).order('updated_at desc')
    @availables = Article.where(status: :available).order('updated_at desc')
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params.merge(reference: SecureRandom.urlsafe_base64, status: :draft))

    respond_to do |format|
      if @article.save
        format.html { redirect_to articles_url, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params.merge(status: :draft))
        format.html { redirect_to articles_url, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def finish
    article = Article.find(params[:id])
    article.update_attributes(status: :available)
    message = {type: "ArticleWasMadeAvailable", payload: {article: article.to_message}}
    Publisher.publish("articles", message)
    redirect_to articles_url
  end

  def recall
    article = Article.find(params[:id])
    article.update_attributes(status: :draft)
    message = {type: "ArticleWasRecalled", payload: {article_reference: article.reference }}
    Publisher.publish("articles", message)
    redirect_to articles_url
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :content, :tags)
    end
end
