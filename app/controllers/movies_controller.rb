class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # logger.info "Processing the request..."
    
    # initialize variables
    if(params.has_key?(:sort_order))
      sort_order = params[:sort_order]
      session[:sort_order] = sort_order;
    elsif(session[:sort_order]!=nil)
      sort_order = session[:sort_order]
    end
    
    # check if ratings params is present otherwise show all ratings from db
    all_ratings = Movie.uniq.pluck(:rating) # get all ratings
    user_selected_ratings = []
    all_ratings_tmp = {}
    if(params.has_key?(:ratings))
      all_ratings.each do |key|
        all_ratings_tmp[key] = false
        if params[:ratings].include? key
          user_selected_ratings.push(key)
          all_ratings_tmp[key] = true
        end
      end
      @all_ratings = all_ratings_tmp
      session[:ratings] = params[:ratings]
    elsif(!params.has_key?(:ratings) && session[:ratings]!=nil)
     # retrieve from session
      all_ratings.each do |key|
        all_ratings_tmp[key] = false
        if session[:ratings].include? key
          user_selected_ratings.push(key)
          all_ratings_tmp[key] = true
        end
      end
      @all_ratings = all_ratings_tmp
    else
      # by default show all ratings
      user_selected_ratings = Movie.uniq.pluck(:rating)
      all_ratings.each do |key|
        all_ratings_tmp[key] =  true
      end
      @all_ratings = all_ratings_tmp
    end
    
    #retrieve movies according to params
    @movies = Movie.with_ratings(user_selected_ratings, sort_order)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
