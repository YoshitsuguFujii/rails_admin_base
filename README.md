# 管理者用の共通部分

rails engineにして切り出しました。

### stylesheetの読み込み

```
*= require yf_admin_base/application
```

### javascriptの読み込み

``` 
//= require yf_admin_base/application
```

### helperの読み込み

```ruby config/initializers/yf_admin_base.rb
class ApplicationController < ActionController::Base
  helper YfAdminBase::Engine.helpers
end
``` 
