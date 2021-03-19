module UsersHelper
    def gravatar_for(user, options = { size: 80, email:'' })

        size = options[:size]
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
        image_tag(gravatar_url, alt: user.name, class: "gravatar img-circle")
    end

    def get_max_ten_values(userid_postnumber_hash)
        userid_postnumber_hash.sort_by { |_, v| -v }.first(10).map(&:first)
    end

end
