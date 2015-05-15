# 管理者用の共通部分

主要部分をrails engineにして切り出しました。

You might need jQuery, Lodash or Underscore.js, backbone.js, fontawesome.css.

### stylesheetの読み込み
add to assets/stylesheet/application.css.scss

```
*= require rails_admin_base/application
```

### javascriptの読み込み
add to assets/javascript/application.js

``` 
//= require rails_admin_base/application
```

### helperの読み込み

add to config/initializers/rails_admin_base.rb

```ruby 
class ApplicationController < ActionController::Base
  helper RailsAdminBase::Engine.helpers
end
``` 


### FileUploaderを組み込む
rails g rails_admin_base:file_uploader_install
