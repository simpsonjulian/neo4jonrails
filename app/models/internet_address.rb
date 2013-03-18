class InternetAddress
  extend ActiveModel::Naming
  include ActiveModel::Validations
  attr_reader :version, :number

  def initialize(address = '192.168.0.1', version = 4)
    @number, @version = address, version
  end

  def persisted?
    false
  end

  def to_key
    nil
  end

  def self.all
  []
  end

  def save
    true
  end

end