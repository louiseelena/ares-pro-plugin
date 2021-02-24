module AresMUSH
  module pro
      class proNewSceneCmd
        include CommandHandler

        attr_accessor :names, :names_raw, :message, :scene_id

    def parse_args
      if (!cmd.args)
        self.names = []
      else
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        if (args.arg1 && (args.arg1.include?("http://") || args.arg1.include?("https://")) )
          self.names = []
        else
          self.names = list_arg(args.arg1)
          self.names_raw = trim_arg(args.arg1)
          self.message = trim_arg(args.arg2)
        end
      end
    end

    def check_approved
      return nil if enactor.is_approved?
      return t('dispatcher.not_allowed')
    end

    def check_pro_target
      return t('pro.pro_new_scene_target_missing') if !self.names || self.names.empty?
      return nil
    end

    def handle

      self.names.each do |name|
        char = Character.named(name)
        if !char
          client.emit_failure t('pro.no_such_character')
          return
        end
      end

      scene_type = Global.read_config("pro", "scene_type")
      location = Global.read_config("pro", "location")
      scene = Scenes.start_scene(enactor, location, true, scene_type, true)

      # Scenes.create_scene_temproom(scene)

      Global.logger.info "Scene #{scene.id} started by #{enactor.name} in Temp pro Room."

      # Checks if the names are valid. If so, starts a scene.
      Global.dispatcher.queue_command(client, Command.new("pro #{self.names_raw}/#{scene.id}=#{self.message}"))

      scene.participants.add enactor
      scene.watchers.add enactor

      self.names.each do |name|
        char = Character.named(name)
        if (!scene.participants.include?(char))
          scene.participants.add char
        end
        if (!scene.watchers.include?(char))
          scene.watchers.add char
        end
      end

    end
  end
  end
end
