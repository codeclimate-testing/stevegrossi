class PostsController < ApplicationController

  caches_action :index, :show, :tag, if: proc{ !current_user }

  def index
    posts = Post.published.includes(:book, :tags).to_a
    @posts = Kaminari.paginate_array(posts).page(params[:page])
  end

  def show
    @post = Post.friendly.includes(book: :authors).find(params[:id])
    if @post.draft?
      if current_user || params[:draft] == 'yep'
        flash.now.alert = 'This is a draft.'
      else
        redirect_to posts_path, flash: { error: 'You must be logged in to view that draft.' }
      end
    end
  end

  def tags
    @tags = Post.published_tag_counts
  end

  def tag
    @tag = Tag.find_by_slug!(params[:slug])
    @posts = Post.tagged_with(@tag).published.includes(:book, :tags)
  end

end
