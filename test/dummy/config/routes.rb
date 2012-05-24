Rails.application.routes.draw do

  mount BcmsEvent::Engine => "/bcms_event"
	mount_browsercms
end
