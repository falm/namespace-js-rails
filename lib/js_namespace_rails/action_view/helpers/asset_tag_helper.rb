
module ActionView::Helpers::AssetTagHelper

  alias_method :javascript_include_tag_without_controller, :javascript_include_tag

  def javascript_include_tag(*source)

    origin_result = javascript_include_tag_without_controller(*source)

    if defined?(controller_path) && !@_included
      controller_underscore = controller_path.gsub(/\//,'_')
      @_included = true
      script = <<STRING
        document.addEventListener('DOMContentLoaded', function() {
          document.getElementsByTagName('body')[0].setAttribute('data-controller', '#{controller_underscore}');
          document.getElementsByTagName('body')[0].setAttribute('data-action', '#{action_name}');
          window.JsSpace.params = #{@js_namespace_rails_params.to_json};
        });
STRING
      origin_result + concat(javascript_tag(script, defer: 'defer'))
    end

    origin_result

  end

end
