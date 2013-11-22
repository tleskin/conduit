Conduit::Engine.routes.draw do
  post 'responses/:request_id', to: 'responses#create'
end
