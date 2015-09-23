class MoviesController < ApplicationController
helper_method :sort_selected

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    if (params[:ratings])
      @selected_ratings = params[:ratings].keys
    else
      @selected_ratings = @all_ratings
    end
    
    val = params[:sort].to_s

    if (val == "title")
      if (params[:ratings])
        @movies = Movie.where(:rating => @selected_ratings).order(:title)
        @selected_ratings = params[:ratings].keys
      else
        @movies = Movie.order(:title)
      end
      @title_header = "hilite"

    elsif (val == "release_date")
      if (params[:ratinfs])
        @movies = Movie.where(:rating => @selected_ratings).order(:title)
        @selected_ratings = params[:ratings].keys
      else
        @movies = Movie.order(:release_date)
      end
      @release_date_header = "hilite"

    else
      if (params[:ratings])
        @movies = Movie.where(:rating => @selected_ratings)
      else
        @movies = Movie.all
        @selected_ratings = Movie.all_ratings
      end
    end
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
