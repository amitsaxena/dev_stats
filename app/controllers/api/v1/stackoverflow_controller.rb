require 'stack_overflow'

class Api::V1::StackoverflowController < ApplicationController
  
  before_action :valid_api_call?
  
  def index
    begin
      render :json => {:error => "Invalid request!"}.to_json, :status => 500 and return if params[:username].blank? && params[:email].blank? && params[:url].blank? && params[:user_id].blank?
      if(!params[:url].blank?)
        @so_response = StackOverflow.find_user_by_id(params[:url].strip.split("/")[-2])
      elsif(!params[:user_id].blank?)
        @so_response = StackOverflow.find_user_by_id(params[:user_id])
      else
        @so_response = StackOverflow.find_user(params[:username], params[:email])
      end
      if @so_response[:found]
        response = @so_response[:users][0]
        response[:so_reach] = StackOverflow.user_reach(@so_response[:users][0][:so_profile_url])
        response[:so_position] = StackOverflow.user_position(@so_response[:users][0][:user_id])
      else
        render :json => {:error => "User not found!"}.to_json, :status => 404 and return
      end
      render :json => response.to_json
    rescue Exception => e
      @error = e.message
      log_error(e)
      render :json => {:error => @error}.to_json, :status => 500
    end
  end
  
end
