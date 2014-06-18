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

  def resize(type, snapshot)
    if @instance.instance_type == type
      fail 'FATAL: Instance already target type.'
    end
    stop
    backup(snapshot) unless snapshot == ['none']
    change_type(type)
    start
    @instance.instance_type
  end

  private

  def stop
    @instance.stop
    loop do
      return true if @instance.status == :stopped
      puts "[#{Time.now}] Waiting for instance to stop..."
      sleep 5
    end
  end

  def backup(snapshot)
    case snapshot
    when ['root']
      name = @instance.root_device_name
      volume =  @instance.attachments[name].volume
      create_snapshot(name, volume)
    else
      threads = []
      snapshot.each do |id|
        # AWS advertises devices as /dev/sdN and Linux sees them as
        # /dev/xvdN.  In case this ever changes, this should match
        # either pattern.
        attachments = instance.attachments.select do |k, _|
          k.match(%r{/dev/(s|xv)d#{id}\d*})
        end
        attachments.keys.each do |attachment|
          volume = @instance.attachments[attachment].volume
          threads << Thread.new { create_snapshot(attachment, volume) }
        end
      end
      threads.each { |t| t.join }
    end
  end

  def create_snapshot(name, vol)
    desc = "#{@instance.id} - #{name} - #{Time.now}"
    snap = vol.create_snapshot(desc)
    loop do
      case snap.status
      when :pending
        puts "[#{Time.now}] Snapshot pending [#{name}]: #{snap.progress || 0}%"
      when :completed
        puts "[#{Time.now}] Snapshot complete [#{name}]"
        return true
      when :error
        fail "FATAL: Failed to create snapshot: #{desc}"
      else
        puts "Snapshot status unknown [#{name}]: #{snap.status}"
      end
      sleep 5
    end
  end

  def change_type(type)
    @instance.instance_type = type
  rescue AWS::EC2::Errors::Client::InvalidParameterValue
    raise "FATAL: Invalid instance type: #{type}"
  end

  def start
    @instance.start
    loop do
      return true if @instance.status == :running
      puts "[#{Time.now}] Waiting for instance to start..."
      sleep 5
    end
  end
end
