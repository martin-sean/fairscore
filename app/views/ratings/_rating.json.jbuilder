json.extract! rating, :id, :user_id, :media_id, :score, :created_at, :updated_at
json.url rating_url(rating, format: :json)
