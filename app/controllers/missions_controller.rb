class MissionsController < ApplicationController
  def index
    Mission.destroy_all
    mission_creation
    @missions = Mission.order(listing_id: :asc)

    render json: @missions.to_json(except: %i[id created_at updated_at])



  end

  def mission_creation
    Booking.all.each do |booking|
      first_checkin = {
        listing_id: booking[:listing_id],
        date: booking[:start_date],
        mission_type: 'first_checkin',
        price_unit: 10 * Listing.find(booking[:listing_id]).num_rooms
      }
      Mission.create!(first_checkin)

      last_checkout = {
        listing_id: booking[:listing_id],
        date: booking[:end_date],
        mission_type: 'last_checkout',
        price_unit: 5 * Listing.find(booking[:listing_id]).num_rooms
      }
      Mission.create!(last_checkout)
    end
    Reservation.all.each do |reservation|
      date_to_check = []
      Booking.where(listing_id: reservation.listing_id).each do |booking|
        date_to_check.push(booking.end_date)
      end
      if date_to_check.exclude?(reservation.end_date)
        checkout_checkin = {
          listing_id: reservation[:listing_id],
          date: reservation[:end_date],
          mission_type: 'checkout_checkin',
          price_unit: 10 * Listing.find(reservation[:listing_id]).num_rooms
        }
        Mission.create!(checkout_checkin)
      end
    end
  end
end
