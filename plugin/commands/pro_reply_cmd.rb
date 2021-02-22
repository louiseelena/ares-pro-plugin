module AresMUSH
  module Pro
    class ProReplyCmd
      include CommandHandler

      attr_accessor :names, :names_raw, :message, :scene_id

      def parse_args
        self.message = cmd.args
      end

      def check_received_Pros
        unless enactor.Pro_received
          client.emit_failure t('Pro.no_one_to_reply_to')
          return
        end
      end

      def handle
        puts enactor.Pro_received
        puts enactor.Pro_received_scene
        if !self.message
          #Tell what the last text recieved was
          if enactor.Pro_received_scene
            client.emit_success t('Pro.reply_scene', :names => enactor.Pro_received, :scene => enactor.Pro_received_scene)
          else
            client.emit_success t('Pro.reply', :names => enactor.Pro_received )
          end
        elsif enactor.Pro_received_scene
          Global.dispatcher.queue_command(client, Command.new("Pro #{enactor.Pro_received}/#{enactor.Pro_received_scene}=#{self.message}"))
        else
          Global.dispatcher.queue_command(client, Command.new("Pro #{enactor.Pro_received}=#{self.message}"))
        end
      end

      def log_command
          # Don't log texts
      end

    end
  end
end
