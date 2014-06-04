class Blog::CommentsController < Blog::BaseController
  
  before_action :load_post,
                :build_comment
  
  def create
    @comment.save!
    
    flash[:comment_success] = 'Thanks! Your comment will appear soon.'
    redirect_to blog_post_path(@cms_site.path, @blog.path, @post.slug, anchor: "new-comment")
    
  rescue ActiveRecord::RecordInvalid => e
    flash[:comment_error] = "Sorry, we couldn't save your comment. " + e.to_s.lines.first.gsub("Validation failed: ", "") + "."
    redirect_to blog_post_path(@cms_site.path, @blog.path, @post.slug, {anchor: "new-comment", author: @comment.author, email: @comment.email, content: @comment.content})
  end

protected

  def load_post
    @post = @blog.posts.published.where(:slug => params[:slug]).first!
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Blog Post not found'
    redirect_to blog_posts_path(@cms_site.path, @blog.path)
  end
  
  def build_comment
    @comment = @post.comments.new(comment_params)
  end

  def comment_params
    params.fetch(:comment, {}).permit(:author, :email, :content)
  end
end
