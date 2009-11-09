require 'rails_best_practices/checks/check'

module RailsBestPractices
  module Checks
    class UseFilterCheck < Check

      def interesting_nodes
        [:class]
      end

      def interesting_files
        /_controller.rb$/
      end

      def evaluate_start(node)
        @methods = {}
        node.grep_nodes({:node_type => :defn}).each { |method_node| remember_method(method_node) }
        @methods.each do |first_call, method_names|
          add_error "use filter for #{first_call.to_ruby} in #{method_names.join(',')}" if method_names.size > 1
        end
      end

      private

      def remember_method(method_node)
        method_name = method_node.message_name
        first_call = method_node.body[1]
        @methods[first_call] ||= []
        @methods[first_call] << method_name
      end
    end
  end
end