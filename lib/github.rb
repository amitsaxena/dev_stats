class Github
  
  def initialize
    @client = Octokit::Client.new(:client_id => ENV["GITHUB_CLIENT_ID"], :client_secret => ENV["GITHUB_CLIENT_SECRET"])
  end
  
  def find_user(username, email)
    begin
      user = @client.user(username) if !username.blank?
      user = find_user_by_email(email) if user.blank?
      return user
    rescue Octokit::NotFound
      find_user_by_email(email)
    end
  end
  
  def find_user_by_email(email)
    begin
      users = @client.search_users(email)
      if(users.total_count == 1)
        user = @client.user(users[:items][0][:login])
        return user
      else
        return nil
      end
    rescue Octokit::NotFound
      return nil
    end
  end
  
  def username_suggestions(username, email)
    begin
      users = []
      users_email = @client.search_users(email) if !email.blank?
      users_username = @client.search_users(username) if !username.blank?
      users += users_email[:items][0..4] if !users_email.blank? && !users_email[:items].blank?
      users += users_username[:items][0..4] if !users_username.blank? && !users_username[:items].blank?
      return users.uniq
    rescue
      # Ignore exception - failure of search API should not result in error
    end
  end
  
  def fav_language(user)
    Octokit.auto_paginate = true
    repos = user.rels[:repos].get(:type => :all).data
    return nil if repos.blank?
    
    language_data = repos.map{|repo| @client.languages(:owner => repo[:owner][:login], :repo => repo[:name])}
    language_sum = {}
    language_data.each do |data|
      data.each do |lang, bytes|
        language_sum[lang] = (language_sum[lang] || 0) + bytes
      end
    end
    fav_languages = language_sum.sort_by{|k, v| v}.reverse[0..4].map{|a| a[0].to_s}
    return fav_languages
  end
  
end
