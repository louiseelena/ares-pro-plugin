module AresMUSH
  module Pro
    class ProColorCmd
      include CommandHandler
      
      attr_accessor :option
      
      def parse_args
        self.option = trim_arg(cmd.args)
      end

      def handle
        enactor.update(Pro_color: self.option)
        client.emit_success t('Pro.color_set', :option => self.option)
      end
    end
  end
end
