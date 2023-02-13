class DeliveriesController < ApplicationController
  def index
    the_id = session.fetch(:user_id)

    if the_id == nil
      redirect_to("/user_sign_in", { :notice => "You have to sign in first." })
    else
      matching_deliveries = Delivery.where({ :user_id => the_id })

      @packages_w = matching_deliveries.where({ :status => "Waiting on" })

      @packages_r = matching_deliveries.where({ :status => "Received" })

      render({ :template => "deliveries/index.html.erb" })
    end
  end

  def show
    the_id = params.fetch("path_id")

    matching_deliveries = Delivery.where({ :id => the_id })

    @the_delivery = matching_deliveries.at(0)

    render({ :template => "deliveries/show.html.erb" })
  end

  def create
    the_delivery = Delivery.new
    the_delivery.description = params.fetch("query_description")
    the_delivery.arrival_date = params.fetch("query_arrival_date")
    the_delivery.details = params.fetch("query_details")
    the_delivery.status = "Waiting on"
    the_delivery.user_id = session.fetch(:user_id)

    if the_delivery.valid?
      the_delivery.save
      redirect_to("/deliveries", { :notice => "Added to list." })
    else
      redirect_to("/deliveries", { :alert => the_delivery.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_delivery = Delivery.where({ :id => the_id }).at(0)

    the_delivery.status = params.fetch("received")

    if the_delivery.valid?
      the_delivery.save
      redirect_to("/deliveries", { :notice => "Marked as received." })
    else
      redirect_to("/deliveries", { :alert => the_delivery.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_delivery = Delivery.where({ :id => the_id }).at(0)

    the_delivery.destroy

    redirect_to("/deliveries", { :notice => "Delivery deleted successfully." })
  end
end
