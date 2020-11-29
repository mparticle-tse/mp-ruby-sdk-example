require 'mparticle'

# set credentials
config = MParticle::Configuration.new
config.api_key = 'us1-4e27eceae24a0c4a85f014ec98de88b0'
config.api_secret = 'ER3fm1YjEPg55IZueBgZj5-i5qjuygEw1lI-z_KiLMEu2HlINKdxMbI4X6GsZ772'

api_instance = MParticle::EventsApi.new(config)

batch = MParticle::Batch.new
batch.environment = 'development'

# set identity 
user_identities = MParticle::UserIdentities.new
user_identities.customerid = '12345'
user_identities.email = 'miles@cool.com'

# set any IDs that you have for this user
device_info = MParticle::DeviceInformation.new
device_info.ios_advertising_id = '07d2ebaa-e956-407e-a1e6-f05f871bf4e2'
device_info.android_advertising_id = 'a26f9736-c262-47ea-988b-0b0504cee874'
batch.device_info = device_info

# arbitrary example allowing you to create a segment of users trial users
batch.user_attributes = {'Account type' => 'trial', 'TrialEndDate' => '2016-12-01'}

# commerce event
product = MParticle::Product.new
product.name = 'Ruby Example Product'
product.id = 'sample-sku'
product.price = 19.99

product_action = MParticle::ProductAction.new
product_action.action = 'purchase'
product_action.products = [product]
product_action.tax_amount = 1.50
product_action.total_amount = 21.49

commerce_event = MParticle::CommerceEvent.new
commerce_event.product_action = product_action
# commerce_event.timestamp_unixtime_ms = example_timestamp

# custom event
app_event = MParticle::AppEvent.new
app_event.event_name = 'Ruby Test event'
app_event.custom_event_type = 'navigation'

batch.events = [MParticle::SessionStartEvent.new, app_event, MParticle::SessionEndEvent.new, commerce_event]
batch.user_identities = user_identities

begin

  # send events
  thread = api_instance.upload_events(batch) { |data, status_code, headers|
    if status_code == 202
      puts "Upload complete"
    end
  }

  # wait for the thread, if needed to prevent the process from terminating
  thread.join

  # you can also omit the callback and synchronously wait until the network request completes.
  data, status_code, headers = api_instance.upload_events(batch)

rescue MParticle::ApiError => e
  puts "Exception when calling mParticle: #{e}"
end