class Amount < ActiveRecord::Base
  def initialize; end

  def self.default
    1500
  end
end
