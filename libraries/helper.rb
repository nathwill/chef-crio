#
# Cookbook Name:: crio
# Library:: CRIOCookbook::Helpers
#
# Copyright 2018, Nathan Williams <nath.e.will@gmail.com>
#

class Hash
  def to_toml
    require 'toml'
    TOML::Generator.new(self).body
  end
end
