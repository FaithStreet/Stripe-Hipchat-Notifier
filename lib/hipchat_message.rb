require 'pry'
class HipchatMessage
  attr_accessor :type
  attr_accessor :uri
  attr_accessor :amount

  def initialize attributes={}
    self.type = attributes[:type]
    self.uri = attributes[:uri]
    self.amount = attributes[:amount]
  end

  def self.new_from_request(request_body)
    request = JSON.parse request_body
    resource = request["data"]["object"]
    attributes = {
      type: request["type"],
      id: resource['id'],
      amount: resource['amount']
    }

    self.new attributes
  end

  def to_h
    {text:"#{type} - #{amount} - #{uri}", notify:should_notify?, color:set_color}
  end

  def valid?
    type !=nil && uri != nil
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

private

  def build_from_request(request_body)
  end

end
