class ActiveNeography
  def get_neo
    Neography::Rest.new
  end

  def to_key
    nil
  end

  def persisted?
    @neo_id.nil? ? false : true
  end
end
