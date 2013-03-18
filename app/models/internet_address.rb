class InternetAddress
  extend ActiveModel::Naming
  include ActiveModel::Validations

  def initialize(address, version = 4)
    @address, @version = address, version
  end

  def persisted?
    false
  end

  def to_key
    nil
  end
  #
  #def errors
  #  false
  #end

  def self.all
  []
  end

end