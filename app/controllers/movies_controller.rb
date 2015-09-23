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
    @all_ratings = Movie.all_ratings

    if (params[:ratings])
      @checked = params[:ratings].keys
      session[:ratings] = params[:ratings]
    elsif (session[:ratings])
      flag = 1
      @checked = session[:ratings].keys
    else
      @checked = @all_ratings
    end
  
    if (params[:sort])
      @sort_method = params[:sort] 
      session[:sort] = params[:sort]
    elsif (session[:sort])
      flag = 1
      @sort_method = session[:sort]
    else
      @sort_method = nil
    end 

    if (@sort_method.to_s == "title")
      @title_header = "hilite"
    elsif (@sort_method.to_s == "release_date")
      @release_date_header = "hilite"
    end
    
    if flag == 1
      redirect_to movies_path(:ratings => session[:ratings], :sort => session[:sort])
    end
    
    @movies = Movie.where(:rating => @checked).order(@sort_method)
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
