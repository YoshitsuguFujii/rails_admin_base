module RailsAdminBase
  module Controllers
    module ControllerFilter
      # js側でcontrollerとaction名を拾えるようにする
      def set_controller_action_name_for_js
        gon.controller_name = controller_name
        gon.action_name = action_name
      end

      #
      # for health check
      #
      def hello
        render text: HelloResponse.first.body
      end
    end
  end
end
