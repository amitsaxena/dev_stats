require 'stack_overflow'
require 'github'
class PagesController < ApplicationController  
  
  def result
    begin
      render "error.js.erb" if params[:email].blank? || params[:email] !~ /\A(\S+)@(.+)\.(\S+)\z/
      if !params[:so_username].blank?
        @so_response = StackOverflow.find_user(params[:so_username], params[:email])
        if @so_response[:found]
          @so_reach = StackOverflow.user_reach(@so_response[:users][0][:so_profile_url])
          @so_position = StackOverflow.user_position(@so_response[:users][0][:user_id])
        end
      end
      if !params[:github_username].blank? || !params[:email].blank?
        github = Github.new
        @user = github.find_user(params[:github_username], params[:email])
        if @user.blank?
          @suggestions = github.username_suggestions(params[:github_username], params[:email])
        else
          @fav_languages = github.fav_language(@user)
        end
      end
    rescue Exception => e
      @error = e.message
      Rails.logger.error(e)
      Rails.logger.error(e.backtrace.join("\n"))
      # TODO display error at top
      # render "error" and return
    end
  end
  
end
