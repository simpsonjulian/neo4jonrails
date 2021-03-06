
class InternetAddress < ActiveNeography
  def self.cypher_to_object(cypher_results)
    results = cypher_results.collect do |result|
      number = result.first['data']['number']
      version = result.first['data']['version']

      neo_id = result.first['self'].split('/').last
      self.new(number, version, neo_id)
    end
   results
  end

  def model_name
    self.class.model_name
  end

  extend ActiveModel::Naming
  include ActiveModel::Validations
  attr_reader :version, :number, :errors

  def initialize(number = '192.168.0.1', version = 4, neo_id = nil)
    @number = number
    @version = version
    neo = get_neo
    neo.create_node_index(model_name)
    @errors = ActiveModel::Errors.new(self)
    @neo_id = neo_id
  end

  def to_param
    @neo_id
  end


  def self.find(*args)
    cypher_results = Neography::Rest.new.execute_query("start n=node({id}) return n",
                                                           {:id => args.first.to_i})['data']
    results = cypher_to_object(cypher_results)
    results.length == 1 ? results.first : results

  end

  def self.find_by_number(number)
     cypher_results = Neography::Rest.new.execute_query("start n=node:InternetAddress(internetaddress='{number}') return n",
                                                            {:number => number})['data']
     puts cypher_results
     cypher_to_object(cypher_results)

   end

  def self.all
    cypher_results = Neography::Rest.new.execute_query("start n=node(*) where n.type! = {type} return n",
                                                       {:type => model_name})['data']
    cypher_to_object(cypher_results)
  end

  def save
    begin
      properties = {:number => @number.to_s, :version => @version, :type => model_name}
      neo = get_neo
      neo.create_unique_node(model_name, model_name.downcase, @number, properties)
      @neo_id = Neography::Node.find(model_name, model_name.downcase, @number).neo_id
    rescue Exception => e
      @errors.add(:neo, e.message)
      return false
    end

    true
  end

  def update_attributes(params)
    begin
    node = Neography::Node.find(model_name, model_name.downcase, @number)
    params.each_pair do |key, value|
      Neography::Rest.new.set_node_properties(node, {key => value})
    end
    @neo_id = node.neo_id
    rescue Exception => e
      puts e.message
      return false
    end

    true
  end

  def destroy
    neo = Neography::Rest.new
    neo.delete_node(@neo_id)
  end

end