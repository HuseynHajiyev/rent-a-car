class Car < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_one_attached :photo

  include PgSearch::Model
  pg_search_scope :search_by_car_model_and_address,
                  against: %i[car_model address],
                  using: {
                    tsearch: { prefix: true } # <-- now `superman batm` will return something!
                  }

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
