require 'open-uri'

class StackOverflow
  
  # Returns exact user if found else returns suggestions
  def self.find_user(name, email)
    result = {:found => false, :users => []}
    name = email.split('@')[0] if name.blank?
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
  
  def self.find_user_by_id(id)
    result = {:found => false, :users => []}
    users = RubyStackoverflow.users_by_ids([id])
    user = users.data[0]
    if !user.blank?
      avatar = user.profile_image
      user_hash = {:avatar => avatar, :name => user.display_name, :reputation => user.reputation,
        :user_id => user.user_id, :so_profile_url => user.link, :created_at => user.creation_date.to_date}
      result[:found] = true
      result[:users] = [user_hash]
    end
    return result
  end
  
  # TODO fetch top tags of a user and display in view
  def self.top_tags(user_id)
    
  end
  
  def self.user_reach(url)
    doc = Nokogiri::HTML(open(url))
    reach_str = doc.css('.stat').text.squish
    reach_str.match(/~(\S*)\speople reached/i).captures[0] rescue nil
  end
  
  def self.user_position(user_id)
    position_html = HTTParty.get("http://stackoverflow.com/users/rank?userId=#{user_id}&_=#{DateTime.now.strftime('%Q')}")
    Nokogiri::HTML(position_html.body).text
  end
  
end
