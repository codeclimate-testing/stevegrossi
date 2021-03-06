class Meta::PostsController < Meta::DashboardController

  cache_sweeper :post_sweeper unless Rails.env.test?

  def index
    @posts = Post.order("published_at DESC")
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.friendly.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.published_at ||= Time.current if params[:commit] == "Publish"
    if @post.save
      redirect_to @post, notice: view_context.notify(:new, :post)
    else
      render :new
    end
  end

  def update
    @post = Post.friendly.find(params[:id])
    @post.attributes = post_params
    if params[:commit] == "Publish"
      @post.published_at ||= Time.current
    elsif params[:commit] == "Unpublish"
      @post.published_at = nil
    end
    if @post.save
      redirect_to @post, notice: view_context.notify(:updated, :post)
    else
      render :edit
    end
  end

  def destroy
    @post = Post.friendly.find(params[:id])
    title = @post.title
    @post.destroy
    redirect_to meta_posts_path, notice: "You deleted <b>#{title}</b>."
  end

  private

  def post_params
    params.require(:post).permit(:content, :idea, :link_url, :published_at, :title, :book_id, tag_ids: [])
  end

end
