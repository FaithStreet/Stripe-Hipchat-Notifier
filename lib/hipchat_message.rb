class HipchatMessage
  attr_accessor :type
  attr_accessor :id
  attr_accessor :amount
  attr_accessor :resource

  def initialize attributes={}
    @type = attributes[:type]
    @id = attributes[:id]
    @amount = attributes[:amount]
    @resource = attributes[:resource]
  end

  def self.new_from_request(request_body)
    request = JSON.parse request_body
    resource = request["data"]["object"]
    attributes = {
      type: request["type"],
      id: resource['id'],
      amount: resource['amount'],
      resource: resource
    }

    self.new attributes
  end

  def to_h
    {text:"#{type} - #{amount} - #{id} : #{resource.reject {|k,v| !v.is_a?(String) || k == 'object' || k == 'id'}}", notify:should_notify?, color:set_color}
  end

  def valid?
    type !=nil && id != nil
  end

  def should_notify?
    case type
    when 'charge.succeeded'
      true
    when 'charge.failed'
      true
    when 'charge.dispute.create'
      true
    when 'transfer.paid'
      true
    when 'transfer.failed'
      true
    else
      false
    end
  end

  def set_color
    case type
    when 'charge.failed'
      'red'
    when 'charge.failed'
      'red'
    when 'charge.refunded'
      'green'
    when 'charge.succeeded'
      'green'
    when 'charge.succeeded'
      'green'
    when /hold/
      'yellow'
    when /refund/
      'yellow'
    else
      'gray'
    end
  end
end
