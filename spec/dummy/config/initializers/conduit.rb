Conduit.configure do |c|
  if Rails.env.test?
    c.driver_path = Rails.root.join('lib', 'conduit', 'drivers')
  end
end