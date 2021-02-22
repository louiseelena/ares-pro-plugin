module AresMUSH
    module Pro

      def self.format_Pro_indicator(char, names)
        t('Pro.Pro_indicator',
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
            nickname_field = Global.read_config("demographics", "nickname_field") || ""
            if (char.demographic(nickname_field))
              recipient_display_names.concat [char.demographic(nickname_field)]
              sender_name = sender.demographic(nickname_field) || sender.name
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
        use_nick = Global.read_config("Pro", "use_nick")
        use_only_nick = Global.read_config("Pro", "use_only_nick")
        if use_nick
          sender_display_name = sender.nick
        elsif use_only_nick
          nickname_field = Global.read_config("demographics", "nickname_field") || ""
          if (sender.demographic(nickname_field))
            sender_display_name = sender.demographic(nickname_field)
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
            return { error: t('Pro.no_such_character') }
          else
            recipient_names.concat [char.name]
          end
        end
        return t('Pro.recipient_indicator', :recipients => recipient_names.join(" "))
      end

      def self.Pro_color(char)
        char.Pro_color || "%xh%xy"
      end

      def self.Pro_recipient(sender, recipient, recipient_names, message, scene_id = nil)
        client = Login.find_client(sender)
        recipient_client  = Login.find_client(recipient)
        Login.emit_if_logged_in recipient, message
        Page.send_afk_message(client, recipient_client, recipient)
        puts scene_id
      end


    end
end
