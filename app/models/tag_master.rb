class TagMaster < ApplicationRecord
  enum tag_type: { content: 0, category: 1 }
end
