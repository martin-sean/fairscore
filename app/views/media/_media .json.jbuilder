json.extract! media , :id, :title, :year, :info, :created_at, :updated_at
json.url media _url(media , format: :json)
