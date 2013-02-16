# 3rd-party
require "jekyll"


# internal
require "jekyll/assets_plugin/configuration"
require "jekyll/assets_plugin/environment"


module Jekyll
  module AssetsPlugin
    module SitePatch

      def assets_config
        @assets_config ||= Configuration.new(self.config["assets"] || {})
      end


      def assets
        @assets ||= Environment.new self
      end


      def asset_path *args
        asset     = assets[*args]
        baseurl   = "#{assets_config.baseurl}/"
        cachebust = assets_config.cachebust

        case cachebust
        when :none then baseurl << asset.logical_path
        when :soft then baseurl << asset.logical_path << "?cb=#{asset.digest}"
        when :hard then baseurl << asset.digest_path
        else raise "Unknown cachebust strategy: #{cachebust.inspect}"
        end
      end

    end
  end
end


Jekyll::Site.send :include, Jekyll::AssetsPlugin::SitePatch