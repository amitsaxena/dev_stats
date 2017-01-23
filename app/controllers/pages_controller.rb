class PagesController < ApplicationController
  
  
  def result
    render "error.js.erb" if params[:email].blank? || params[:email] !~ /\A(\S+)@(.+)\.(\S+)\z/
    if !params[:so_username].blank?
      
    end
    if !params[:github_username].blank? || params[:email].blank?
      
    end
  end
  
end
