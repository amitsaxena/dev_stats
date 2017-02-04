class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def valid_api_call?
    if(params["api_token"].blank? || ![ENV["API_TOKEN_IVAN"]].include?(params["api_token"]))
      render :json => {:error => "Invalid API key!"}.to_json and return
    end
  end
  
  private
  
  def log_error(e)
    Rails.logger.error(e)
    Rails.logger.error(e.backtrace.join("\n"))
  end
end
