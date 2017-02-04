require 'stack_overflow'
require 'github'
class PagesController < ApplicationController
  
  prepend_before_filter :protect_from_spam, :only => [:result]
  
  def result
    begin
      render "error.js.erb" if params[:email].blank? || params[:email] !~ /\A(\S+)@(.+)\.(\S+)\z/
      if !params[:so_username].blank? || !params[:email].blank?
        fetch_so_data
      end
    rescue Exception => e
      @error = e.message
      Rails.logger.error(e)
      Rails.logger.error(e.backtrace.join("\n"))
    end
  end
  
  def github_result
    begin
      if !params[:github_username].blank? || !params[:email].blank?
        fetch_github_data
      end
    rescue Exception => e
      @error = e.message
      Rails.logger.error(e)
      Rails.logger.error(e.backtrace.join("\n"))
    end
  end
  
  def so_result
    begin
      render :nothing => true, :status => 500 if params[:so_user_id].blank?
      fetch_so_data
    rescue Exception => e
      @error = e.message
      Rails.logger.error(e)
      Rails.logger.error(e.backtrace.join("\n"))
    end
  end
  
  def fetch_so_data
    if(params[:so_username] && params[:so_username].strip =~ /^(http|https):\/\/(.)*/i)
      @so_response = StackOverflow.find_user_by_id(params[:so_username].split("/")[-2])
    elsif(!params[:so_user_id].blank?)
      @so_response = StackOverflow.find_user_by_id(params[:so_user_id])
    else
      @so_response = StackOverflow.find_user(params[:so_username], params[:email])
    end
    
    if @so_response[:found]
      @so_reach = StackOverflow.user_reach(@so_response[:users][0][:so_profile_url])
      @so_position = StackOverflow.user_position(@so_response[:users][0][:user_id])
    end
  end
  
  def fetch_github_data
    github = Github.new
    username = (!params[:github_username].blank? && params[:github_username].strip =~ /^(http|https):\/\/(.)*/i) ? params[:github_username].split("/")[-1] : params[:github_username]
    @user = github.find_user(username, params[:email])
    if @user.blank?
      @suggestions = github.username_suggestions(username, params[:email])
    else
      @contributions = github.contributions(@user[:login])
      @fav_languages = github.fav_language(@user)
    end
  end
  
end
