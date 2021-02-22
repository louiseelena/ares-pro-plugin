module AresMUSH
    module Pro

      def self.format_pro_indicator(char, names)
        t('Pro.pro_indicator',
       :start_marker => Global.read_config("Pro", "Pro_start_marker") || "(", :end_marker => Global.read_config("Pro", "Pro_end_marker") || ")",  :preface => Global.read_config("Pro", "Pro_preface"),  :recipients => names, :color => Pro.Pro_color(char) )
      end

      def self.format_recipient_display_names(recipients, sender)
        use_nick = Global.read_config("Pro", "use_nick")
        use_only_nick = Global.read_config("Pro", "use_only_nick")
        recipient_display_names = []
        sender_name = sender.name
        recipients.each do |char|
          if use_nick
            recipient_display_names.concat [char.nick]
            sender_name = sender.nick || sender.name
          elsif use_only_nick
            nickname_field = Global.read_config("demographics", "dragon") || ""
            if (char.demographic(dragon_field))
              recipient_display_names.concat [char.demographic(dragon)]
              sender_name = sender.demographic(dragon_field) || sender.name
            else
              recipient_display_names.concat [char.name]
            end
          else
            recipient_display_names.concat [char.name]
          end
        end
        recipient_display_names.delete(sender_name)
        if use_nick || use_only_nick
          recipients = recipient_display_names.join(", ")
        else
          recipients = recipient_display_names.join(" ")
        end
        return t('Pro.recipient_indicator', :recipients => recipients)
      end

      def self.format_sender_display_name(sender)
        use_nick = Global.read_config("pro", "use_nick")
        use_only_nick = Global.read_config("pro", "use_only_nick")
        if use_nick
          sender_display_name = sender.nick
        elsif use_only_nick
          nickname_field = Global.read_config("demographics", "dragon") || ""
          if (sender.demographic(dragon))
            sender_display_name = sender.demographic(dragon)
          else
            sender_display_name = sender.name
          end
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
        return t('Pro.recipient_indicator', :recipients => recipient_names.join(" "))
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
