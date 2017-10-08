class Article < ApplicationRecord
  def to_message
    attributes
        .reject{|a| a == 'id'}
        .reject{|a| a == 'tags'}
        .merge(tags: tags.split(/[;,]/).map(&:strip))
  end
end
