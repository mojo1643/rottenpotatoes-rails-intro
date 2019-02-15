class Movie < ActiveRecord::Base
    def self.with_ratings (rate_arr, sort_order)
        if sort_order.eql?("name")
          self.where(rating: rate_arr).order(:title)
        elsif sort_order.eql?("date")
          self.where(rating: rate_arr).order(:release_date)
        else
          self.where(rating: rate_arr).all
        end
    end
end
