module ViteRephlex
    module PhlexHelpers
      class OohBabyILikeItRaw < Phlex::HTML
        def initialize(tag:)
              @tag = tag
          end
          def template
              if @tag.is_a?(Array)
                @tag.each {|t| unsafe_raw(t)}
              else
                unsafe_raw(@tag)
              end
          end

      end

      class Script < Phlex::HTML
          def initialize(src:, type: "module", async: false, crossorigin: false)
              @src, @type, @async, @crossorigin = src, type, async, crossorigin
          end

          def template
              script(src: @src, type: @type, async: @async, crossorigin: @crossorigin)
          end
      end

      class Link < Phlex::HTML
          def initialize(rel: 'stylesheet', href: 'main.css', **options)
            @rel, @href, @options = rel, href, options
          end
          def template
            link(rel: @rel, href: @href, **@options)
          end
      end
      #end of PhlexHelpers
    end

    # Public: Renders a script tag for vite/client to enable HMR in development.
    def vite_client_tag
      return unless src = vite_manifest.vite_client_src
      PhlexHelpers::Script.new(src: src)
    end

    # Public: Renders a script tag to enable HMR with React Refresh.
    def vite_react_refresh
      tag = vite_manifest.react_refresh_preamble
      PhlexHelpers::OohBabyILikeItRaw.new(tag) if tag
    end

    # Public: Resolves the path for the specified Vite asset.
    # Example:
    #   <%= vite_asset_path 'calendar.css' %> # => "/vite/assets/calendar-1016838bab065ae1e122.css"
    def vite_asset_path(name, **options)
      "/vite/assets/" + vite_manifest.path_for(name, **options)
    end

    # Public: Renders a ViteRephlex::PhlexHelpers::Script component.
    # When called it will render a <script> tag for the specified Vite entrypoints.
    def vite_javascript_tag(*names,
        type: 'module',
        asset_type: :javascript,
        skip_preload_tags: false,
        skip_style_tags: false,
        crossorigin: 'anonymous',
        **options)
        entries = vite_manifest.resolve_entries(*names, type: asset_type)
        tags = entries.fetch(:scripts).map {|src|
          PhlexHelpers::Script.new(src: src, crossorigin: crossorigin, type: type).call
        }

        tags.concat(vite_preload_tag(*entries.fetch(:imports), crossorigin: crossorigin)) unless skip_preload_tags
        tags.concat(vite_js_stylesheet_tag(*entries.fetch(:stylesheets))) unless skip_style_tags
        PhlexHelpers::OohBabyILikeItRaw.new(tag: tags)
    end

    # Public: Renders a ViteRephlex::PhlexHelpers::Script component.
    # When called it will render a <script> tag for the specified Vite entrypoints.
    def vite_typescript_tag(*names, **options)
      vite_javascript_tag(*names, asset_type: :typescript, **options)
    end

     # Public: Renders a ViteRephlex::PhlexHelpers::Link component.
    # When called it will render a <link> tag for the specified Vite entrypoints.
    def vite_stylesheet_tag(*names, **options)
      tags = names.map { |name|
        PhlexHelpers::Link.new(
          href: vite_asset_path(name, type: :stylesheet),
          **options).call
        }
        PhlexHelpers::OohBabyILikeItRaw.new(tag: tags)
    end

    private
    # Needed to go around the javascript + stylesheet tag in one.
    def vite_js_stylesheet_tag(*names, **options)
      tags = names.map { |name|
        PhlexHelpers::Link.new(
          href: vite_asset_path(name, type: :stylesheet),
          **options).call
        }
    end

    # Internal: Returns the current manifest loaded by Vite Ruby.
    def vite_manifest
      ViteRuby.instance.manifest
    end

    # Internal: Renders a modulepreload ViteRephlex::PhlexHelpers::Link component.
    # When called it will return a moduleprelode <link> tag.
    def vite_preload_tag(*sources, crossorigin:)
      sources.map { |source|
        href = asset_path(source)
        try(:request).try(:send_early_hints, 'Link' => %(<#{ href }>; rel=modulepreload; as=script; crossorigin=#{ crossorigin }))
        PhlexHelpers::Link.new(rel: 'modulepreload', href: href, crossorigin: crossorigin, as: 'script').call
      }
    end
end



#! Notes made during design decisions. At first I contemplated making it a roda plugin.
#* This shouldn't be a plugin. This needs to be a globally accessible component library.
#* When rendering other components, you should be able to use one of these methods to
#* get a Phlex component. It should return the complete component and not a string because you want
#* To pass it to the phlex_add_to_head but also just use render ViteRephlex::ClientTag
