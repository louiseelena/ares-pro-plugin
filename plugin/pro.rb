$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Pro
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("pro", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
        case cmd.root
        when "pro"
          case cmd.switch
          when "color"
            return ProColorCmd
          when "newscene"
            return ProNewSceneCmd
          when "reply"
            return ProReplyCmd
          when nil
            return ProSendCmd
          end
        end
      return nil
    end

    def self.get_web_request_handler(request)
      case request.cmd
      when "addPro"
        return AddProRequestHandler
      end
      nil
    end
  end
end