$:.unshift File.dirname(__FILE__)

module AresMUSH
  module pro
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
            return proColorCmd
          when "newscene"
            return proNewSceneCmd
          when "reply"
            return proReplyCmd
          when nil
            return proSendCmd
          end
        end
      return nil
    end

    def self.get_web_request_handler(request)
      case request.cmd
      when "addpro"
        return AddproRequestHandler
      end
      nil
    end
  end
end