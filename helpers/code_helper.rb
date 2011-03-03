require "grit"
require "active_support/core_ext/hash/reverse_merge"

module CodeHelper
  def code(file, options)
    options.reverse_merge! :language => :ruby
    
    r = Grit::Repo.new('/home/nick/projects/peters-guide')
    c = r.tag(options[:tag]).commit
    
    markup = CodeRay.scan((c.tree/file).data, options[:language]).html(:line_numbers => :inline)
    #puts CodeRay.scan((c.tree/file).data, options[:language]).inspect
    markup = range_for(markup, options[:lines]) if options[:lines]
    
    #puts markup.inspect
    
    markup = Haml::Helpers::preserve(markup) ### DISCUSS: use this outside?
    
    markup = tag(:pre) { markup }
    
    markup = wrap(markup, file, options)
    
    markup
  end
  
  def diff(file, options)
    r = Grit::Repo.new('/home/nick/projects/peters-guide')
    commit_a = r.tag(options[:tag_a]).commit
    commit_b = r.tag(options[:tag_b]).commit
    c = r.diff(commit_a.id, commit_b.id, file).first.diff
    
    
    
    #puts r.diff(commit_a.id, commit_b.id, file).first
    #puts c.inspect
    #c.shift
    #c.shift
    
    markup = CodeRay.scan(c, :diff).html
    
    #puts markup.html
     markup = Haml::Helpers::preserve(markup) ### DISCUSS: use this outside?
    
   # markup= tag(:div, markup)
    
    
    markup = wrap(markup, file, options)
  end
  
private
  def wrap(markup, file, options)
    partial 'code/wrap', :locals => {:code => markup, :file => file, :options => options}
  end
  
  # Returns the subset of lines from +markup+ for +range+.
  def range_for(markup, range)
    range = (range.begin-1..range.end-1)
    markup.split("\n")[range].join("\n")
  end
  
end
