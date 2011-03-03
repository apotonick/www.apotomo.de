module BoxHelper
  def meta_box(options)
    options[:branch_link] = link options[:branch], "https://github.com/apotonick/apotomo_peters_guide/#{options[:branch]}"
    
    options[:version_links] = []
    for version in options[:versions].sort do
      version_string = page_link(version, "#{options[:branch]}-#{version}")
      version_string << " (Rails 2.3)" if version == "0.1" # FIXME: haha.
      
      options[:version_links] << version_string
    end
    
    options[:version_links] = options[:version_links].join(", ")
    
  
    partial 'meta_box', :locals => options
  end
end
