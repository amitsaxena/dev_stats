require 'stack_overflow'
class PagesController < ApplicationController  
  
  def result
    render "error.js.erb" if params[:email].blank? || params[:email] !~ /\A(\S+)@(.+)\.(\S+)\z/
    if !params[:so_username].blank?
      @so_response = StackOverflow.find_user(params[:so_username], params[:email])
      if @so_response[:found]
        @so_reach = StackOverflow.user_reach(@so_response[:users][0][:so_profile_url])
        @so_position = StackOverflow.user_position(@so_response[:users][0][:user_id])
      end
    end
    if !params[:github_username].blank? || params[:email].blank?
      
    end
  end
  
end
