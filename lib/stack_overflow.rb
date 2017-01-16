class StackOverflow
  
  # Returns exact user if found else returns suggestions
  def self.find_user(name, email)
    result = {:found => false, :users => []}
    users = RubyStackoverflow.users({inname: name, sort: 'name'})
    users.data.each do |user|
      avatar = user.profile_image
      email_md5 = avatar.split('?')[0].split('/')[-1] rescue ""
      user_hash = {:avatar => avatar, :name => user.display_name, :reputation => user.reputation,
        :user_id => user.user_id, :so_profile_url => user.link, :created_at => user.creation_date.to_date}
      if(!avatar.blank? && Digest::MD5.hexdigest(email.downcase) == email_md5)
        result[:found] = true
        result[:users] = [user_hash]
        return result
      else
        result[:users] << user_hash
      end
    end
    return result
  end
  
  def self.top_tags(user_id)
    
  end
  
  def self.scrape_profile_data(url)
    response = HTTParty.get(url)
    # Get people reached
    # Get top x% overall
  end
  
end
