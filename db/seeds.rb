require 'net/http'
require 'json'

Bookmark.destroy_all
List.destroy_all
Movie.destroy_all

url = URI("https://tmdb.lewagon.com/movie/top_rated")
response = Net::HTTP.get(url)
movies = JSON.parse(response)["results"]

created_movies = movies.map do |movie|
  Movie.create!(
    title: movie["title"],
    overview: movie["overview"],
    poster_url: "https://image.tmdb.org/t/p/w500#{movie['poster_path']}",
    rating: movie["vote_average"]
  )
end

list_names = ["Drama", "Comedy", "Classic", "To rewatch", "Girl Power"]
created_lists = list_names.map do |name|
  List.create!(name: name)
end

created_lists.each do |list|
  3.times do
    movie = created_movies.sample
    Bookmark.create!(
      list: list,
      movie: movie,
      comment: "Recommended movie for #{list.name} category"
    )
  end
end
