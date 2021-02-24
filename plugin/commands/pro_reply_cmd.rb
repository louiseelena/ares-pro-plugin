module AresMUSH
  module Pro
    class ProReplyCmd
      include CommandHandler

      attr_accessor :names, :names_raw, :message, :scene_id

      def parse_args
        self.message = cmd.args
      end

      def check_received_pros
        unless enactor.pro_received
          client.emit_failure t('pro.no_one_to_reply_to')
          return
        end
      end

      def handle
        puts enactor.pro_received
        puts enactor.pro_received_scene
        if !self.message
          #Tell what the last text recieved was
          if enactor.pro_received_scene
            client.emit_success t('pro.reply_scene', :names => enactor.pro_received, :scene => enactor.pro_received_scene)
          else
            client.emit_success t('pro.reply', :names => enactor.pro_received )
          end
        elsif enactor.pro_received_scene
          Global.dispatcher.queue_command(client, Command.new("pro #{enactor.pro_received}/#{enactor.pro_received_scene}=#{self.message}"))
        else
          Global.dispatcher.queue_command(client, Command.new("pro #{enactor.pro_received}=#{self.message}"))
        end
      end

      def log_command
          # Don't log texts
      end

    end
  end
end
