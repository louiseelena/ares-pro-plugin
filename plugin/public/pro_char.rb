module AresMUSH
    class Character
        attribute :pro_last, :type => DataType::Array, :default => []
        attribute :pro_last_scene, :type => DataType::Array, :default => []
        attribute :pro_received
        attribute :pro_received_scene
        attribute :pro_color
        attribute :pro_scene
    end
  end