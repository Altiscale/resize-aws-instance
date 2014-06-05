require 'aws-sdk'
require 'resize_aws_instance/version'

# ResizeAwsInstance
class ResizeAwsInstance
  attr_accessor :aws
  attr_accessor :instance

  def initialize(key, secret, region, id)
    @aws = AWS::EC2.new(
      access_key_id: key,
      secret_access_key: secret,
      region: region
    )
    @instance = @aws.instances[id]
    return @instance if @instance.root_device_type == :ebs
    fail 'FATAL: Non EBS root volume.'
  end

  def resize(type)
    fail 'Instance already target type.' if @instance.instance_type == type
    stop
    change_type(type)
    start
    @instance.instance_type
  end

  private

  def stop
    loop do
      @instance.stop
      break if @instance.status == :stopped
      puts "[#{Time.now}] Waiting for instance to stop..."
      sleep 5
    end
  end

  def change_type(type)
    @instance.instance_type = type
  rescue AWS::EC2::Errors::Client::InvalidParameterValue
    raise "Invalid instance type: #{type}"
  end

  def start
    loop do
      @instance.start
      break if @instance.status == :running
      puts "[#{Time.now}] Waiting for instance to start..."
      sleep 5
    end
  end
end
