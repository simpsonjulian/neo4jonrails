class InternetAddress
  extend ActiveModel::Naming
  include ActiveModel::Validations
  attr_reader :version, :number, :errors

  def initialize(number = '192.168.0.1', version = 4)
    @number = number
    puts @number.inspect
    @version = version
    @neo = Neography::Rest.new
    @neo.create_node_index(model_name)  unless @neo.list_indexes.include?(model_name)
    @errors = ActiveModel::Errors.new(self)
  end

  def persisted?
    false
  end

  def to_key
    nil
  end

  def model_name
    self.class.model_name
  end

  def self.all

    #require 'net-http-spy'
    #Net::HTTP.http_logger_options = {:body => true}
    cypher_results = Neography::Rest.new.execute_query("start n=node(*) where n.type! = {type} return n",
                                            {:type => model_name})['data']

    results = cypher_results.collect do |result|
      number = result.first['data']['number']
      version = result.first['data']['version']
      self.new(number, version)
    end
    results
  end

  def save
    begin
    properties = {:number => @number.to_s, :version => @version, :type => model_name}

    @neo.create_unique_node(model_name, model_name, @number, properties)
    rescue Exception => e
      @errors.add(:neo, e.message)
      puts e.message
      puts e.backtrace
      return false
    end

    true
  end

end