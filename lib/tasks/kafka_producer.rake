namespace :kafka do
  task :produce do
    require "kafka"
    require "faker"
    require "securerandom"

    # Prefix is required by Heroku multi-tenant Kafka
    topic = "#{ENV['KAFKA_PREFIX']}test_orders"
    puts "Prefix: #{ENV['KAFKA_PREFIX']}"
    puts " Topic: #{topic}"
    
    kafka_client.deliver_message(order.to_json, topic: topic)
  end
end

def kafka_client
  tmp_ca_file = Tempfile.new('ca_certs')
  tmp_ca_file.write(ENV.fetch('KAFKA_TRUSTED_CERT'))
  tmp_ca_file.close

  puts "ssl_ca_cert_file_path: #{tmp_ca_file.path}"

  @_kafka ||= Kafka.new(
    seed_brokers: ENV.fetch('KAFKA_URL'),
    ssl_ca_cert_file_path: tmp_ca_file.path,
    ssl_client_cert: ENV.fetch('KAFKA_CLIENT_CERT'),
    ssl_client_cert_key: ENV.fetch('KAFKA_CLIENT_CERT_KEY'),
    ssl_verify_hostname: false,
  )
end

def order
  line_items = items

  {
    "key": SecureRandom.uuid,
    "status": "in_progress",
    "centsPrice": line_items.map { |li| li[:centsPrice] }.sum,
    "currency": "AUD",
    "lineItems": line_items,
    "createdAt": Time.now.utc,
    "updatedAt": Time.now.utc,
    "customerName": Faker::Name.name,
    "customerAddress": Faker::Address.street_address,
    "customerSuburb": ["Richmond", "South Yarra", "Bundoora"].sample,
    "customerPostcode": ["3121", "3141", "3121"].sample,
    "customerState": ["VIC", "TAS", "NSW"].sample,
    "customerEmail": Faker::Internet.email,
    "customerPhone": Faker::PhoneNumber.phone_number
  }
end

def items
  Array.new(rand(1..5)).map do |i|
    {
      "itemId": SecureRandom.uuid,
      "name": Faker::Food.dish,
      "quantity": rand(1..3),
      "centsPrice": rand(100..3000),
      "currency": "AUD"
    }
  end 
end
