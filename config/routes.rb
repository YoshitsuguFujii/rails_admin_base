RailsAdminBase::Engine.routes.draw do
  resources :upload_file do
    collection do
      post :tmp_upload
      patch :tmp_upload
    end
  end
end
