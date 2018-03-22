#
# Cookbook Name:: crio
# Library:: CRIOCookbook::Mixins
#
# Copyright 2018, Nathan Williams <nath.e.will@gmail.com>
#

module CrioCookbook
  module Mixins
    module ResourceMethods
      def self.included(base)
        base.extend ClassMethods
        base.send :def_methods
      end

      module ClassMethods
        def def_methods
          define_method(:img_ref) { "#{new_resource.repo}:#{new_resource.tag}" }
          define_method(:podman_cmd) { "/bin/podman #{fmt_opts new_resource.global_opts}" }
          define_method(:fmt_opts) { |arr = []| arr.join(' ') }
        end
      end
    end
  end
end

class Hash
  def to_toml
    require 'toml'
    TOML::Generator.new(self).body
  end
end
