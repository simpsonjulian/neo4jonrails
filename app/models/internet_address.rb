require 'ipaddr'
class InternetAddress
  extend ActiveModel::Naming
  include ActiveModel::Validations
  attr_reader :version, :number, :errors

  def initialize(number = '192.168.0.1', version = 4, neo_id = nil)
    @number = number
    @version = version
    @neo = Neography::Rest.new
    #@neo.create_node_index(model_name) unless @neo.list_indexes.include?(model_name)
    @errors = ActiveModel::Errors.new(self)
    @neo_id = neo_id

    require 'net-http-spy'
    Net::HTTP.http_logger_options = {:body => true}

  end

  def persisted?
    @neo_id.nil? ? false : true
  end

  def to_key
    nil
  end

  def model_name
    self.class.model_name
  end

  def to_param
    IPAddr.new(@number).to_i
  end



  def self.find_by_octets(number)
    cypher_results = Neography::Rest.new.execute_query("start n=node(*) where n.number! = {number} return n",
                                                       {:number => number})['data']

    cypher_to_object(cypher_results).first


  end

  def self.find_by_integer(number)
    puts 'asked for ' + number
    number_string = IPAddr.new(number.to_i, Socket::AF_INET).to_s
    puts "got  #{number_string}"

    self.find_by_octets(number_string)

  end

  def self.cypher_to_object(cypher_results)
    results = cypher_results.collect do |result|
      number = result.first['data']['number']
      version = result.first['data']['version']

      self.new(number, version, result.first['self'].split('/').last)
    end
    results
  end

  def self.find(*args)
    puts args.inspect
  end

  def self.all

    cypher_results = Neography::Rest.new.execute_query("start n=node(*) where n.type! = {type} return n",
                                                       {:type => model_name})['data']

    cypher_to_object(cypher_results)
  end

  def save
    begin
      properties = {:number => @number.to_s, :version => @version, :type => model_name}

      @neo.create_unique_node(model_name, model_name, @number, properties)
      @neo_id = Neography::Node.find(model_name, model_name, @number).neo_id

    rescue Exception => e
      @errors.add(:neo, e.message)
      return false
    end

    true
  end

  def update_attributes(params)
    node = Neography::Node.find(model_name, model_name, @number)
    params.each_pair do |key, value|
      node[key.to_sym] = value
    end
    @neo_id = node.neo_id
  end

  def destroy
    node = @neo.get_node_index(model_name, model_name, @number)
    puts node
    @neo.remove_node_from_index(model_name, model_name, @number)
    @neo.delete_node!(node)
  end

end