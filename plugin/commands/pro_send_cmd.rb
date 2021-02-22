module AresMUSH
  module Pro
      class ProSendCmd
          include CommandHandler
# Possible commands... pro name=message; pro =message; pro name[/optional scene #]=<message>

          attr_accessor :names, :message, :scene_id, :scene, :pro, :pro_recipient, :use_only_nick

        def parse_args
          if (!cmd.args)
            #why is this here?
            self.names = []

          elsif (cmd.args.start_with?("="))
            self.names = enactor.pro_last
            self.scene_id = enactor.pro_scene
            self.message = cmd.args.after("=")

          elsif (cmd.args.include?("="))
            args = cmd.parse_args(ArgParser.arg1_equals_arg2)
            # Catch the common mistake of last-paging someone a link.
            # p http://stuff.com/stuff=this.file
            if (args.arg1 && (args.arg1.include?("http://") || args.arg1.include?("https://")) )
              self.names = enactor.pro_last
              self.message = "#{args.arg1}=#{args.arg2}"
            #Text a specific scene
            elsif ( args.arg1.include?("/") )
              if args.arg1.rest("/").is_integer?
                self.scene_id = args.arg1.rest("/")
                self.names = list_arg(args.arg1.first("/"))
                self.message = trim_arg(args.arg2)
              #Text the scene you are physically in
              elsif args.arg1.rest("/").chr.casecmp?("s")
                self.scene_id = enactor.room.scene_id
                self.names = list_arg(args.arg1.first("/"))
                self.message = trim_arg(args.arg2)
              end
            else
              #Text someone without a scene
              self.names = list_arg(args.arg1)
              self.message = trim_arg(args.arg2)
            end

          else
            #Text your last recipient and scene
            self.names = enactor.pro_last
            self.scene_id = enactor.pro_scene
            self.message = cmd.args
          end
        end

        def check_errors
          return t('dispatcher.not_allowed') if !enactor.is_approved?
          return t('Pro.pro_target_missing') if !self.names || self.names.empty?
          return nil
        end

        def handle
          puts "DOING THIS"
          # Is scene real and can you text to it?
          if self.scene_id
            scene = Scene[self.scene_id]
            if !scene
              client.emit_failure t('Pro.scene_not_found')
            end
            can_pro_scene = Scenes.can_read_scene?(enactor, scene)
            if scene.completed
              client.emit_failure t('Pro.scene_not_running')
              return
            elsif !scene.room
              raise "Trying to pose to a scene that doesn't have a room."
            elsif !can_pro_scene
              client.emit_failure t('Pro.scene_no_access')
              return
            end
            self.scene = scene
          end

          #Are recipients real, online, and in the scene?
          recipients = []
          self.names.each do |name|
            char = Character.named(name)
            if !char
              client.emit_failure t('Pro.no_such_character')
              return
            elsif (!Login.is_online?(char) && !self.scene)
              client.emit_failure t('Pro.target_offline_no_scene', :name => name.titlecase )
              return
            else
              recipients.concat [char]
            end

            #Add recipient to scene if they are not already a participant
            if self.scene
              can_pro_scene = Scenes.can_read_scene?(char, self.scene)
              if (!can_pro_scene)
                Scenes.add_to_scene(scene, t('Pro.recipient_added_to_scene', :name => char.name ),
                enactor, nil, true )
                Rooms.emit_ooc_to_room self.scene.room, t('Pro.recipient_added_to_scene',
                :name => char.name )

                if (enactor.room != self.scene.room)
                  client.emit_success t('Pro.recipient_added_to_scene',
                  :name =>char.name )
                end

                if (!scene.participants.include?(char))
                  scene.participants.add char
                end

                if (!scene.watchers.include?(char))
                  scene.watchers.add char
                end

              end
            end
          end

          recipient_display_names = Pro.format_recipient_display_names(recipients, enactor)
          recipient_names = Pro.format_recipient_names(recipients)
          sender_display_name = Pro.format_sender_display_name(enactor)

          self.use_only_nick = Global.read_config("pro", "use_only_nick")
          # If scene, add text to scene
          if self.scene
            if self.use_only_nick
              scene_id_display = "#{self.scene_id} - #{enactor.name}"
            else
              scene_id_display = self.scene_id
            end

            scene_pro = t('Pro.pro_no_scene_id', :pro => Pro.format_pro_indicator(enactor, recipient_display_names), :sender => sender_display_name, :message => message)

            self.pro = t('Pro.pro_with_scene_id', :pro => Pro.format_pro_indicator(enactor, recipient_display_names), :sender => sender_display_name, :message => message, :scene_id => scene_id_display )

            Scenes.add_to_scene(self.scene, scene_pro, enactor)
            Rooms.emit_ooc_to_room self.scene.room, scene_pro
          else
            if self.use_only_nick
              self.pro = t('Pro.pro_no_scene_id_nick', :pro => Pro.format_pro_indicator(enactor, recipient_display_names), :sender => sender_display_name, :message => message, :sender_char => enactor.name )
            else
              self.pro = t('Pro.pro_no_scene_id', :pro => Pro.format_pro_indicator(enactor, recipient_display_names), :sender => sender_display_name, :message => message)
            end

          end

        # If online, send emit to sender and recipients if they aren't in the scene's room.
          #To recipients
          recipients.each do |char|
            if (Login.is_online?(char)) && (!self.scene || char.room != self.scene.room)
              if char.page_ignored.include?(enactor)
                client.emit_failure t('pro.cant_pro_ignored', :names => char.name)
                return
              elsif (char.page_do_not_disturb)
                client.emit_ooc t('page.recipient_do_not_disturb', :name => char.name)
                return
              end
              Pro.pro_recipient(enactor, char, recipient_display_names, self.pro, self.scene_id)
            end
            pro_received = "#{recipient_names}" + " #{enactor.name}"
            pro_received.slice! "#{char.name}"
            char.update(pro_received: (pro_received.squish))
            char.update(pro_received_scene: self.scene_id)
          end

          #To sender
          if (!self.scene || enactor_room != self.scene.room)
            client.emit self.pro
          end


          enactor.update(pro_last: list_arg(recipient_names))
          enactor.update(pro_scene: self.scene_id)
      end

      def log_command
        # Don't log texts
      end
    end
  end
end
