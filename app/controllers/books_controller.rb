class BooksController < ApplicationController

  before_filter :logged_in?, :except => [:index, :show, :topic, :topics]

  # GET /books
  # GET /books.xml
  def index
    @title = 'Books'
    @description = 'Writing about books helps me figure out what I think about them.'
    @books = Book.published

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @books }
    end
  end
  
  def everything
    @title = 'Everything I\'ve read.'
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.xml
  def show
    @book = Book.find(params[:id])
    @title = @book.title
    @description = @book.thesis unless @book.thesis.blank?
    
    if @book.draft?
      if current_user || params[:draft] == 'yep'
        flash.now[:alert] = 'This is a draft.'
      else
        flash[:error] = 'You must be logged in to view this draft.'
        redirect_to books_path and return
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/new
  # GET /books/new.xml
  def new
    @book = Book.new
    @authors = Author.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
    @authors = Author.all
  end

  # POST /books
  # POST /books.xml
  def create
    @book = Book.new(params[:book])
    unless @book.new_author.blank?
      author = Author.new( extract_author_atts(@book.new_author) )
      @book.authors << author
    end

    respond_to do |format|
      if @book.save
        format.html do
          flash[:success] = 'Yay, you read another book!'
          redirect_to @book
        end
        format.xml  { render :xml => @book, :status => :created, :location => @book }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.xml
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html do
          flash[:success] = 'Update successful.'
          redirect_to @book
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.xml
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to(books_url) }
      format.xml  { head :ok }
    end
  end
  
  def topics
    @title = 'Topics covered in books I\'ve read'
    @topics = Book.topic_counts
  end
  
  def topic
    @topic = ActsAsTaggableOn::Tag.find(params[:topic])
    @books = Book.published.tagged_with(@topic)
    @title = "Books I've read about #{@topic.name}"
  end
  
  private
  
  def extract_author_atts(str)
    atts = {}
    parts = str.split(' ')
    # if a part is 'de' or ', Jr.', etc. combine it with next/previous part
    case parts.count
    when 1
      atts[:fname] = parts.first
    when 2
      atts[:fname] = parts.first
      atts[:lname] = parts.last
    when 3
      atts[:fname] = parts[0]
      atts[:mname] = parts[1]
      atts[:lname] = parts[2]
    when 4
      atts[:fname] = parts[0]
      atts[:mname] = parts[1..2].join(' ')
      atts[:lname] = parts[3]
    end
    return atts
  end
  
end
