class Blog::PostsController < Blog::BaseController

  before_action :get_months
  
  skip_before_action :load_blog, :only => [:serve]
  
  # due to fancy routing it's hard to say if we need show or index
  # action. let's figure it out here.
  def serve
    # if there are more than one blog, blog_path is expected
    if @cms_site.blogs.count >= 2 
      params[:blog_path] = params.delete(:slug) if params[:blog_path].blank?
    end
    
    load_blog
    get_months # Not sure if necessary, but doesn't hurt
    
    if params[:slug].present?
      show && render(:show)
    else
      index && render(:index)
    end
  end

  def index
    if params[:year]
      @header = "Blog posts from " + params[:year]
      scope = @blog.posts.published.for_year(params[:year])
      if params[:month]
        month = Date.new(params[:year].to_i, params[:month].to_i)
        @header = "Blog posts from " + month.strftime("%B %Y")
        scope = scope.for_month(params[:month]) 
      end
    else
      scope = @blog.posts.published
    end

    limit = ComfyBlog.config.posts_per_page
    respond_to do |format|
      format.html do
        @posts = scope.page(params[:page]).per(limit)
      end
      format.rss do
        @posts = scope.limit(limit)
      end
    end
  end
  
  def show
    @post = if params[:slug] && params[:year] && params[:month]
      @blog.posts.published.where(:year => params[:year], :month => params[:month], :slug => params[:slug]).first!
    else
      @blog.posts.published.where(:slug => params[:slug]).first!
    end
    @comment = @post.comments.new

  rescue ActiveRecord::RecordNotFound
    render :cms_page => '/404', :status => 404
  end

  def archive
    @posts_by_month = @blog.posts.published.group_by { |p| p.published_at.beginning_of_month }.sort.reverse
  end

protected

  def get_months
    load_blog
    if @months.nil?
      @months = @blog.posts.published.map { |p| p.published_at.beginning_of_month }.uniq.sort.reverse
    end
  end
end
