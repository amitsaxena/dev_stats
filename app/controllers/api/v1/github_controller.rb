require 'github'

class Api::V1::GithubController < ApplicationController
  
  before_action :valid_api_call?
  
  def index
    begin
      render :json => {:error => "Invalid request!"}.to_json, :status => 500 and return if params[:username].blank? && params[:url].blank?
      username = params[:username].blank? ? params[:url].strip.split("/")[-1] : params[:username]
      username.strip!
      github = Github.new
      @user = github.find_user(username)
      if @user.blank?
        render :json => {:error => "User not found!"}.to_json, :status => 404 and return
      else
        @contributions = github.contributions(@user[:login])
        @fav_languages = github.fav_language(@user)
      end
      response = {:success => true, :avatar => @user[:avatar_url], :display_name => @user[:name], :github_user_id => @user[:id],
        :public_repos => @user[:public_repos], :public_gists => @user[:public_gists], :created_at => @user[:created_at],
        :past_year_contributions => @contributions, :fav_languages => @fav_languages, :blog => @user[:blog]}
      render :json => response.to_json
    rescue Exception => e
      @error = e.message
      log_error(e)
      render :json => {:error => @error}.to_json, :status => 500
    end
  end
  
end
