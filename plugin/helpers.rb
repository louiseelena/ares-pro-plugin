module AresMUSH
    module Pro

      def self.format_pro_indicator(char, names)
        t('pro.pro_indicator',
       :start_marker => Global.read_config("Pro", "pro_start_marker") || "<", :end_marker => Global.read_config("Pro", "pro_end_marker") || ">",  :preface => 'Projection',  :recipients => names, :color => Pro.pro_color(char) )
      end

      def self.format_recipient_display_names(recipients, sender)
        recipient_display_names = []
        sender_name = sender.name
        recipients.each do |char|
            nickname_field = Global.read_config("demographics", "nickname_field") || ""
            if (char.demographic(nickname_field))
              recipient_display_names.concat [char.demographic(nickname_field)]
              sender_name = sender.demographic(nickname_field) || sender.name
            else
              recipient_display_names.concat [char.name]
            end
        end
        recipient_display_names.delete(sender_name)
        recipients = recipient_display_names.join(", ")
        return t('pro.recipient_indicator', :recipients => recipients)
      end

      def self.format_sender_display_name(sender)
          nickname_field = Global.read_config("demographics", "nickname_field") || ""
          if (sender.demographic(nickname_field))
            sender_display_name = sender.demographic(nickname_field)
          else
            sender_display_name = sender.name
        end
        return sender_display_name
      end

      def self.format_recipient_names(recipients)
        recipient_names = []
        recipients.each do |char|
          if !char
            return { error: t('pro.no_such_character') }
          else
            recipient_names.concat [char.name]
          end
        end
        return t('pro.recipient_indicator', :recipients => recipient_names.join(" "))
      end

      def self.pro_color(char)
        char.pro_color || "%xh%xy"
      end

      def self.pro_recipient(sender, recipient, recipient_names, message, scene_id = nil)
        client = Login.find_client(sender)
        recipient_client  = Login.find_client(recipient)
        Login.emit_if_logged_in recipient, message
        Page.send_afk_message(client, recipient_client, recipient)
        puts scene_id
      end


    end
end
